import promptAction from '@ohos.promptAction';
import { router } from '@kit.ArkUI';

export class BleGuard {
  private static readonly CONNECT_PAGE_URL: string = 'pages/DeviceConnect';
  private static readonly TITLE: string = '提示';
  private static readonly DEFAULT_MSG: string = '请先连接蓝牙工位终端。';
  private static connected: boolean = false;

  static setConnected(v: boolean): void {
    BleGuard.connected = v;
  }

  private static isConnected(): boolean {
    return BleGuard.connected;
  }

  static async onClick(action: () => void | Promise<void>): Promise<void> {
    if (BleGuard.isConnected()) {
      try {
        await action();
      } catch (e) {
        console.error('BleGuard action execute error', e);
      }
      return;
    }
    try {
      const res = await promptAction.showDialog({
        title: BleGuard.TITLE,
        message: BleGuard.DEFAULT_MSG,
        buttons: [
          { text: '取消', color: '#666666' },
          { text: '去连接', color: '#0A59F7' }
        ]
      });
      if (res.index === 1) {
        try {
          router.pushUrl({ url: BleGuard.CONNECT_PAGE_URL });
        } catch (err) {
          console.error('BleGuard router pushUrl error', err);
        }
      }
    } catch {
      // ignore dialog exception
    }
  }

  static async onClickMsg(message: string, action: () => void | Promise<void>): Promise<void> {
    if (BleGuard.isConnected()) {
      try {
        await action();
      } catch (e) {
        console.error('BleGuard action execute error', e);
      }
      return;
    }
    try {
      const res = await promptAction.showDialog({
        title: BleGuard.TITLE,
        message,
        buttons: [
          { text: '取消', color: '#666666' },
          { text: '去连接', color: '#0A59F7' }
        ]
      });
      if (res.index === 1) {
        try {
          router.pushUrl({ url: BleGuard.CONNECT_PAGE_URL });
        } catch (err) {
          console.error('BleGuard router pushUrl error', err);
        }
      }
    } catch {
      // ignore dialog exception
    }
  }
}