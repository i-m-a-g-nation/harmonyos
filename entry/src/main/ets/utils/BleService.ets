import { ble } from '@kit.ConnectivityKit';
import { BleGuard } from './BleGuard';

export interface BleDiscoveredDevice {
  displayName: string;
  deviceId: string;
  resolvedAddress: string;
  rssi: number;
  name: string;
  advertisementText: string;
  lastSeen: number;
}

type PacketHandler = (packet: string) => void | Promise<void>;

interface BleCharacteristicRef {
  serviceUuid: string;
  characteristicUuid: string;
}

export class BleService {
  private static readonly TARGET_DEVICE_NAME: string = 'MY_WATCH';
  private static readonly ADV_COMPANY_ID_LEN: number = 0x3;
  private static readonly ADV_EXPLICIT_MAC_LEN: number = 6;

  private static readonly SERVICE_UUID: string = '0000FF11-0000-1000-8000-00805F9B34FF';
  private static readonly NOTIFY_UUID: string = '0000FF12-0000-1000-8000-00805F9B34FF';
  private static readonly WRITE_UUID: string = '0000FF22-0000-1000-8000-00805F9B34FF';

  private static scannerOn: boolean = false;
  private static discoveredMap: Map<string, BleDiscoveredDevice> = new Map<string, BleDiscoveredDevice>();
  private static deviceFindHandler: ((devices: Array<BleDiscoveredDevice>) => void) | null = null;
  private static client: ble.GattClientDevice | null = null;
  private static connectedDeviceId: string | null = null;
  private static connected: boolean = false;
  private static packetHandler: PacketHandler | null = null;

  private static writeRef: BleCharacteristicRef | null = null;
  private static notifyRefs: Array<BleCharacteristicRef> = [];
  private static writing: boolean = false;
  private static rxBuffer: string = '';

  static setPacketHandler(handler: PacketHandler | null): void {
    BleService.packetHandler = handler;
  }

  static getConnectedDeviceId(): string {
    return BleService.connectedDeviceId ?? '';
  }

  static isConnected(): boolean {
    return BleService.connected;
  }

  static async startScan(onListChanged: (devices: Array<BleDiscoveredDevice>) => void): Promise<void> {
    try {
      BleService.stopScan();
      BleService.discoveredMap.clear();
      BleService.deviceFindHandler = onListChanged;

      try {
        ble.off('BLEDeviceFind', BleService.onDeviceFind);
      } catch (e) {
        // ignore
      }

      ble.on('BLEDeviceFind', BleService.onDeviceFind);

      const scanFilters: ble.ScanFilter[] = [];
      // 关键修复：清空所有自定义参数，使用空对象
      const scanOptions: ble.ScanOptions = {};
      ble.startBLEScan(scanFilters, scanOptions);
      BleService.scannerOn = true;
    } catch (err) {
      console.error('startScan error', err);
    }
  }

  private static onDeviceFind(results: Array<ble.ScanResult>): void {
    const now = Date.now();
    for (let i = 0; i < results.length; i++) {
      const r = results[i];
      if (r == null) continue;
      const advertisementText = BleService.describeAdvertisement(r);
      const explicitMac = BleService.extractExplicitMac(r);
      const watchName = (typeof r.deviceName === 'string' && r.deviceName.length > 0) ? r.deviceName : '';
      if (watchName !== '' && watchName !== BleService.TARGET_DEVICE_NAME) {
        continue;
      }
      const name = watchName.length > 0 ? watchName : BleService.TARGET_DEVICE_NAME;
      const item: BleDiscoveredDevice = {
        displayName: explicitMac.length > 0 ? explicitMac : 'MAC unavailable',
        deviceId: r.deviceId,
        resolvedAddress: explicitMac.length > 0 ? explicitMac : '',
        name: name,
        advertisementText: advertisementText,
        rssi: r.rssi,
        lastSeen: now,
      };
      BleService.discoveredMap.set(r.deviceId, item);
    }
    BleService.emitScanList();
  }

  static stopScan(): void {
    if (!BleService.scannerOn) {
      return;
    }
    try {
      ble.stopBLEScan();
    } catch (e) {
      // ignore
    }
    try {
      ble.off('BLEDeviceFind', BleService.onDeviceFind);
    } catch {
      // ignore
    }
    BleService.deviceFindHandler = null;
    BleService.scannerOn = false;
  }

  private static emitScanList(): void {
    if (BleService.deviceFindHandler == null) return;
    const arr: Array<BleDiscoveredDevice> = Array.from(BleService.discoveredMap.values());
    arr.sort((a, b) => (b.rssi - a.rssi));
    BleService.deviceFindHandler(arr);
  }

  static async connect(deviceId: string): Promise<void> {
    try {
      if (deviceId.length === 0) {
        throw new Error('empty deviceId');
      }
      if (BleService.connected && BleService.connectedDeviceId === deviceId) {
        return;
      }
      await BleService.disconnect();

      const client: ble.GattClientDevice = ble.createGattClientDevice(deviceId);
      BleService.client = client;
      BleService.connectedDeviceId = deviceId;
      BleService.connected = false;
      BleService.writeRef = null;
      BleService.notifyRefs = [];
      BleService.rxBuffer = '';

      client.on('BLEConnectionStateChange', (stateInfo: ble.BLEConnectionChangeState) => {
        if (stateInfo.state === 2) {
          BleService.connected = true;
          BleGuard.setConnected(true);
        } else if (stateInfo.state === 0) {
          BleService.connected = false;
          BleGuard.setConnected(false);
          BleService.writeRef = null;
          BleService.notifyRefs = [];
        }
      });

      client.on('BLECharacteristicChange', (data: ble.BLECharacteristic): void => {
        const raw = BleService.decodeText(data.characteristicValue);
        if (raw.length === 0) return;
        BleService.consumeIncomingText(raw);
      });

      client.connect();
      await BleService.waitForConnected(12000);
      await BleService.discoverAndBindCharacteristics();
    } catch (err) {
      console.error('connect error', err);
      await BleService.disconnect();
      throw new Error('err');
    }
  }

  static async disconnect(): Promise<void> {
    const client = BleService.client;
    if (client !== null) {
      try {
        client.disconnect();
      } catch {
        // ignore
      }
      try {
        client.close();
      } catch {
        // ignore
      }
    }
    BleService.client = null;
    BleService.connected = false;
    BleGuard.setConnected(false);
    BleService.connectedDeviceId = null;
    BleService.writeRef = null;
    BleService.notifyRefs = [];
    BleService.rxBuffer = '';
  }

  static async sendPacket(packet: string): Promise<boolean> {
    try {
      if (!BleService.connected || BleService.client === null || BleService.writeRef === null) {
        return false;
      }
      if (packet.trim().length === 0) {
        return false;
      }
      const lockOk = await BleService.waitWriteLock(1800);
      if (!lockOk) {
        return false;
      }
      BleService.writing = true;
      const text = packet.endsWith('\n') ? packet : `${packet}\n`;
      const bytes = BleService.encodeText(text);
      let offset = 0;
      const CHUNK_SIZE = 20;
      while (offset < bytes.byteLength) {
        const len = Math.min(CHUNK_SIZE, bytes.byteLength - offset);
        const chunk = new Uint8Array(bytes.slice(offset, offset + len));
        const charObj: ble.BLECharacteristic = {
          serviceUuid: BleService.writeRef.serviceUuid,
          characteristicUuid: BleService.writeRef.characteristicUuid,
          characteristicValue: chunk as ArrayBuffer,
          descriptors: []
        };
        await BleService.client.writeCharacteristicValue(charObj, ble.GattWriteType.WRITE_NO_RESPONSE);
        offset += len;
        await BleService.sleep(20);
      }
      return true;
    } catch {
      return false;
    } finally {
      BleService.writing = false;
    }
  }

  private static async waitForConnected(timeoutMs: number): Promise<void> {
    const start = Date.now();
    while (!BleService.connected) {
      if (Date.now() - start > timeoutMs) {
        throw new Error('BLE connect timeout');
      }
      await BleService.sleep(120);
    }
  }

  private static async discoverAndBindCharacteristics(): Promise<void> {
    try {
      const client = BleService.client;
      if (client === null) throw new Error('BLE client missing');
      const services: Array<ble.GattService> = await client.getServices();
      const notifyCandidates: Array<BleCharacteristicRef> = [];
      const writeCandidates: Array<BleCharacteristicRef> = [];
      const serviceTarget = BleService.normalizeUuid(BleService.SERVICE_UUID);
      const notifyTarget = BleService.normalizeUuid(BleService.NOTIFY_UUID);
      const writeTarget = BleService.normalizeUuid(BleService.WRITE_UUID);

      for (let i = 0; i < services.length; i++) {
        const serv = services[i];
        if (BleService.normalizeUuid(serv.serviceUuid) !== serviceTarget) {
          continue;
        }
        const chars: Array<ble.BLECharacteristic> = serv.characteristics;
        for (let j = 0; j < chars.length; j++) {
          const ch = chars[j];
          const normalized = BleService.normalizeUuid(ch.characteristicUuid);
          if (normalized === notifyTarget) {
            notifyCandidates.push({ serviceUuid: serv.serviceUuid, characteristicUuid: ch.characteristicUuid });
          }
          if (normalized === writeTarget) {
            writeCandidates.push({ serviceUuid: serv.serviceUuid, characteristicUuid: ch.characteristicUuid });
          }
        }
      }

      if (notifyCandidates.length === 0 || writeCandidates.length === 0) {
        throw new Error(`profile mismatch: require ${serviceTarget}/${notifyTarget}/${writeTarget}`);
      }
      BleService.notifyRefs = [notifyCandidates[0]];
      BleService.writeRef = writeCandidates[0];

      let enableCount = 0;
      for (let i = 0; i < BleService.notifyRefs.length; i++) {
        const ref = BleService.notifyRefs[i];
        const ch: ble.BLECharacteristic = {
          serviceUuid: ref.serviceUuid,
          characteristicUuid: ref.characteristicUuid,
          characteristicValue: new ArrayBuffer(0),
          descriptors: []
        };
        try {
          await client.setCharacteristicChangeNotification(ch, true);
          enableCount += 1;
        } catch {
          // ignore partial notify failures
        }
      }
      if (enableCount === 0) {
        throw new Error('BLE notify enable failed');
      }
    } catch (err) {
      console.error('discoverAndBindCharacteristics error', err);
      throw new Error('err');
    }
  }

  private static consumeIncomingText(chunk: string): void {
    BleService.rxBuffer += chunk;
    const lines: Array<string> = BleService.rxBuffer.split('\n');
    BleService.rxBuffer = lines.pop() ?? '';
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i].trim();
      if (line === '') continue;
      BleService.dispatchPacket(line);
    }
  }

  private static dispatchPacket(packet: string): void {
    if (BleService.packetHandler === null) return;
    void BleService.packetHandler(packet);
  }

  private static encodeText(text: string): Uint8Array {
    const out: number[] = [];
    for (let i = 0; i < text.length; i++) {
      const code = text.charCodeAt(i);
      if (code < 0x80) {
        out.push(code);
      } else if (code < 0x800) {
        out.push(0xC0 | (code >> 6));
        out.push(0x80 | (code & 0x3F));
      } else {
        out.push(0xE0 | (code >> 12));
        out.push(0x80 | ((code >> 6) & 0x3F));
        out.push(0x80 | (code & 0x3F));
      }
    }
    return new Uint8Array(out);
  }

  private static decodeText(buf: ArrayBuffer): string {
    if (buf.byteLength <= 0) return '';
    return String.fromCharCode(...new Uint8Array(buf));
  }

  private static async sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(() => resolve(), ms));
  }

  private static async waitWriteLock(timeoutMs: number): Promise<boolean> {
    const start = Date.now();
    while (BleService.writing) {
      if (Date.now() - start > timeoutMs) {
        return false;
      }
      await BleService.sleep(20);
    }
    return true;
  }

  private static normalizeUuid(u: string): string {
    return u.trim().toUpperCase();
  }

  private static normalizeAddress(address: string): string {
    const raw = address.trim();
    const compact = raw.replace(/[:\-]/g, '');
    const parts: string[] = [];
    for (let i = 0; i < compact.length; i += 2) {
      parts.push(compact.substring(i, i + 2).toUpperCase());
    }
    return parts.join(':');
  }

  private static extractExplicitMac(result: ble.ScanResult): string {
    if (result.data.byteLength <= 0) return '';
    const data = new Uint8Array(result.data);
    return BleService.findExplicitMac(data);
  }

  private static describeAdvertisement(result: ble.ScanResult): string {
    const parts: string[] = [];
    const serialized = BleService.safeSerializeScanResult(result);
    parts.push(`RSSI: ${result.rssi}`);
    if (serialized.length > 0) {
      parts.push(serialized);
    }
    return parts.length > 0 ? parts.join(' | ') : 'No adv payload captured';
  }

  private static safeSerializeScanResult(result: ble.ScanResult): string {
    try {
      return JSON.stringify(result);
    } catch {
      return '';
    }
  }

  private static findExplicitMac(data: Uint8Array): string {
    const minLen = BleService.ADV_COMPANY_ID_LEN + BleService.ADV_EXPLICIT_MAC_LEN;
    if (data.length < minLen) {
      return '';
    }
    const compIdLen = BleService.ADV_COMPANY_ID_LEN;
    const macLen = BleService.ADV_EXPLICIT_MAC_LEN;
    for (let start = 0; start <= data.length - minLen; start++) {
      if (data[start] !== compIdLen) continue;
      let allZero = true;
      const macParts: string[] = [];
      for (let i = 0; i < macLen; i++) {
        const byteVal = data[start + compIdLen + i];
        macParts.push(byteVal.toString(16).padStart(2, '0').toUpperCase());
        if (byteVal !== 0) allZero = false;
      }
      if (!allZero) {
        return BleService.normalizeAddress(macParts.join(':'));
      }
    }
    return '';
  }
}