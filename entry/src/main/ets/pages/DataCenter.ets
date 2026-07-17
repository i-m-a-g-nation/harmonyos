import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { BleService } from '../utils/BleService';
import { ReminderConfig } from '../common/model/ReminderConfig'


// ===================== 类型定义【前置，解决ArkTS编译顺序报错】 =====================
type JsonField = string | number | boolean | null;
type HealthRange = 'today' | '7d' | '30d';
type HealthReducer = 'avg' | 'sum' | 'max' | 'min' | 'latest';

interface KVPair {
  key: string;
  value: string;
}

interface HealthMetricRecord {
  timestamp: number;
  value: number;
  value2: number;
  value3: number;
  value4: number;
  value5: number;
  status: string;
  extra: string;
}

class StatsObj {
  min: number;
  max: number;
  sum: number;
  count: number;
  constructor(min: number, max: number, sum: number, count: number) {
    this.min = min;
    this.max = max;
    this.sum = sum;
    this.count = count;
  }
}

// ===================== 持久化Key常量 =====================
export class DataKey {
  static readonly PROFILE_NAME: string = 'profile_name';
  static readonly PROFILE_GENDER: string = 'profile_gender';
  static readonly PROFILE_HEIGHT: string = 'profile_height';
  static readonly PROFILE_WEIGHT: string = 'profile_weight';
  static readonly PROFILE_BIRTH: string = 'profile_birth';

  static readonly REMINDER_VIBRATE: string = 'reminder_vibrate';

  static readonly TIP_WATER: string = 'tip_water';
  static readonly TIP_EYE: string = 'tip_eye';
  static readonly TIP_LEVEL: string = 'tip_level';
  static readonly TIP_VENTILATION: string = 'tip_ventilation';


  static readonly SET_WRIST_RAISE: string = 'my_wrist_raise';
  static readonly SET_VIBRATION_MODE: string = 'my_vibration_mode';
  static readonly TIP_NOTIFY: string = 'tip_notify';
  static readonly TIP_SEDENTARY: string = 'tip_sedentary';
  static readonly TIP_BP_PERIODIC: string = 'tip_bp_periodic';
  static readonly TIP_SPO2_PERIODIC: string = 'tip_spo2_periodic';
  static readonly TIP_GEOFENCE: string = 'tip_geofence';

  static readonly EXE_AUTO_PAUSE: string = 'exe_auto_pause';
  static readonly EXE_VIBRATE_REMIND: string = 'exe_vibrate_remind';
  static readonly EXE_SCREEN_ALWAYS_ON: string = 'exe_screen_always_on';
  static readonly EXE_HR_REMIND: string = 'exe_hr_remind';

  static readonly GOAL_KCAL: string = 'goal_kcal';
  static readonly GOAL_STEPS: string = 'goal_steps';
  static readonly GOAL_EXERCISE_MIN: string = 'goal_exercise_min';

  static readonly TODAY_KCAL: string = 'today_kcal';
  static readonly TODAY_STEPS: string = 'today_steps';
  static readonly TODAY_EXERCISE_MIN: string = 'today_exercise_min';
  static readonly TODAY_DISTANCE_KM: string = 'today_distance_km';
  static readonly TODAY_AVG_HR: string = 'today_avg_hr';

  static readonly DEV_CONNECTED: string = 'dev_connected';
  static readonly DEV_STATUS_TEXT: string = 'dev_status_text';
  static readonly DEV_BATTERY: string = 'dev_battery';
  static readonly DEV_VERSION: string = 'dev_version';
  static readonly DEV_BLUETOOTH_ON: string = 'dev_bluetooth_on';
  static readonly DEV_SYNC_ON: string = 'dev_sync_on';
  static readonly DEV_LAST_COMMAND: string = 'dev_last_command';
  static readonly DEV_LAST_COMMAND_TS: string = 'dev_last_command_ts';
  static readonly SELECTED_DEVICE_ID: string = 'selected_device_id';

  static readonly BP_SERIES_7D: string = 'bp_series_7d';
  static readonly BP_SERIES_30D: string = 'bp_series_30d';
  static readonly PULSE_SERIES_30D: string = 'pulse_series_30d';

  static readonly BSUGAR_CURRENT: string = 'bsugar_current';
  static readonly BSUGAR_PERCENT: string = 'bsugar_percent';
  static readonly BSUGAR_STATUS: string = 'bsugar_status';
  static readonly BSUGAR_SERIES_TODAY: string = 'bsugar_series_today';
  static readonly BSUGAR_SERIES_7D: string = 'bsugar_series_7d';
  static readonly BSUGAR_SERIES_30D: string = 'bsugar_series_30d';

  static readonly SPO2_CURRENT: string = 'spo2_current';
  static readonly SPO2_STATUS: string = 'spo2_status';
  static readonly SPO2_SERIES_TODAY: string = 'spo2_series_today';
  static readonly SPO2_SERIES_7D: string = 'spo2_series_7d';
  static readonly SPO2_SERIES_30D: string = 'spo2_series_30d';

  static readonly STRESS_RANGE_TEXT: string = 'stress_range_text';
  static readonly STRESS_AVG: string = 'stress_avg';
  static readonly STRESS_SERIES_7D: string = 'stress_series_7d';
  static readonly STRESS_SERIES_30D: string = 'stress_series_30d';

  static readonly HR_REST_PERCENT: string = 'hr_rest_percent';
  static readonly HR_REST_SERIES_TODAY: string = 'hr_rest_series_today';
  static readonly HR_REST_SERIES_7D: string = 'hr_rest_series_7d';
  static readonly HR_REST_SERIES_30D: string = 'hr_rest_series_30d';

  static readonly SLEEP_TOTAL_H: string = 'sleep_total_h';
  static readonly SLEEP_QUALITY: string = 'sleep_quality';
  static readonly SLEEP_STATUS: string = 'sleep_status';
  static readonly SLEEP_AWAKE_MIN: string = 'sleep_awake_min';
  static readonly SLEEP_REM_MIN: string = 'sleep_rem_min';
  static readonly SLEEP_LIGHT_MIN: string = 'sleep_light_min';
  static readonly SLEEP_DEEP_MIN: string = 'sleep_deep_min';
  static readonly SLEEP_BAR_7D: string = 'sleep_bar_7d';
  static readonly SLEEP_BAR_30D: string = 'sleep_bar_30d';

  static readonly UI_BP_RANGE: string = 'ui_bp_range';
  static readonly UI_BSUGAR_RANGE: string = 'ui_bsugar_range';
  static readonly UI_SPO2_RANGE: string = 'ui_spo2_range';
  static readonly UI_STRESS_RANGE: string = 'ui_stress_range';
  static readonly UI_SLEEP_RANGE: string = 'ui_sleep_range';
  static readonly UI_EXERCISE_TYPE: string = 'ui_exercise_type';
  static readonly UI_HR_REST_RANGE: string = 'ui_hr_rest_range';

  static readonly HEALTH_BP_RECORDS: string = 'health_bp_records';
  static readonly HEALTH_BSUGAR_RECORDS: string = 'health_bsugar_records';
  static readonly REMINDER_CONFIG: string = 'reminder_config';
  static readonly HEALTH_SPO2_RECORDS: string = 'health_spo2_records';
  static readonly HEALTH_STRESS_RECORDS: string = 'health_stress_records';
  static readonly HEALTH_HR_RECORDS: string = 'health_hr_records';
  static readonly HEALTH_SLEEP_RECORDS: string = 'health_sleep_records';
}

// ===================== 核心数据中心类 =====================
export class DataCenter {

  private static ctx: common.UIAbilityContext | null = null;
  private static pref: preferences.Preferences | null = null;
  private static initPromise: Promise<preferences.Preferences> | null = null;
  private static readonly prefName: string = 'app_datacenter';
  private static readonly DAY_MS: number = 24 * 60 * 60 * 1000;
  static reminderConfig: ReminderConfig = new ReminderConfig();

  // 页面数据更新回调，UI订阅使用
  static onDataUpdated: (() => void) | null = null;

  // 【新增 1】专门用于提醒设置页面刷新数据的回调
  private static refreshReminderUICallback: (() => void) | null = null;

  static init(ctx: common.UIAbilityContext): void {
    DataCenter.ctx = ctx;
  }

  private static async ensurePref(): Promise<preferences.Preferences> {
    if (DataCenter.pref !== null) {
      return DataCenter.pref;
    }
    if (DataCenter.initPromise !== null) {
      return DataCenter.initPromise;
    }
    if (DataCenter.ctx === null) {
      throw new Error('DataCenter.init() not called: missing UIAbilityContext');
    }
    DataCenter.initPromise = preferences.getPreferences(DataCenter.ctx, { name: DataCenter.prefName }).then((p) => {
      DataCenter.pref = p;
      return p;
    });
    return DataCenter.initPromise;
  }

  static async getString(key: string, def: string = ''): Promise<string> {
    try {
      const p: preferences.Preferences = await DataCenter.ensurePref();
      const v: preferences.ValueType = await p.get(key, def);
      if (typeof v === 'string') return v;
      return def;
    } catch (err) {
      console.error('getString error', err);
      return def;
    }
  }

  static async getNumber(key: string, def: number = 0): Promise<number> {
    try {
      const p: preferences.Preferences = await DataCenter.ensurePref();
      const v: preferences.ValueType = await p.get(key, def);
      if (typeof v === 'number') return v;
      if (typeof v === 'string') {
        const n: number = Number(v);
        if (isFinite(n)) return n;
      }
      if (typeof v === 'boolean') return v ? 1 : 0;
      return def;
    } catch (err) {
      console.error('getNumber error', err);
      return def;
    }
  }

  static async getBoolean(key: string, def: boolean = false): Promise<boolean> {
    try {
      const p: preferences.Preferences = await DataCenter.ensurePref();
      const v: preferences.ValueType = await p.get(key, def);
      if (typeof v === 'boolean') return v;
      if (typeof v === 'number') return v !== 0;
      if (typeof v === 'string') {
        const s = v.trim().toLowerCase();
        if (s === 'true' || s === '1') return true;
        if (s === 'false' || s === '0') return false;
      }
      return def;
    } catch (err) {
      console.error('getBoolean error', err);
      return def;
    }
  }

  static async setString(key: string, value: string): Promise<void> {
    try {
      const p: preferences.Preferences = await DataCenter.ensurePref();
      await p.put(key, value);
      await p.flush();
    } catch (err) {
      console.error('setString error', err);
    }
  }

  static async setNumber(key: string, value: number): Promise<void> {
    try {
      const p: preferences.Preferences = await DataCenter.ensurePref();
      await p.put(key, value);
      await p.flush();
    } catch (err) {
      console.error('setNumber error', err);
    }
  }

  static async setBoolean(key: string, value: boolean): Promise<void> {
    try {
      const p: preferences.Preferences = await DataCenter.ensurePref();
      await p.put(key, value);
      await p.flush();
    } catch (err) {
      console.error('setBoolean error', err);
    }
  }

  static async isDeviceConnected(): Promise<boolean> {
    return DataCenter.getBoolean(DataKey.DEV_CONNECTED, false);
  }

  static async isDeviceSyncEnabled(): Promise<boolean> {
    return DataCenter.getBoolean(DataKey.DEV_SYNC_ON, false);
  }

  static async saveReminderConfig(config: ReminderConfig): Promise<void> {
    DataCenter.reminderConfig = config
    await DataCenter.setString(DataKey.REMINDER_CONFIG, JSON.stringify(config))
    console.info("提醒配置保存成功", JSON.stringify(config))

    // 【修改 2】保存成功后，触发回调，通知页面更新
    if (DataCenter.refreshReminderUICallback) {
      DataCenter.refreshReminderUICallback();
    }
  }

  static async getReminderConfig(): Promise<ReminderConfig> {
    const raw = await DataCenter.getString(DataKey.REMINDER_CONFIG, '')

    // 如果完全没有存过数据，就返回默认的新对象
    if (raw.length === 0) {
      // 如果内存里有缓存的旧对象，也先保留 (一般第一次进来这里)
      if (DataCenter.reminderConfig) {
        return DataCenter.reminderConfig
      }
      return new ReminderConfig()
    }

    try {
      const obj = JSON.parse(raw) as ReminderConfig
      const config = new ReminderConfig()
      config.sedentaryEnable = obj.sedentaryEnable
      config.sedentaryInterval = obj.sedentaryInterval
      config.waterEnable = obj.waterEnable
      config.waterInterval = obj.waterInterval
      config.eyeEnable = obj.eyeEnable
      config.eyeInterval = obj.eyeInterval
      config.ventilationEnable = obj.ventilationEnable
      config.co2Limit = obj.co2Limit
      config.quietStart = obj.quietStart
      config.quietEnd = obj.quietEnd
      config.level = obj.level

      // 存入内存缓存
      DataCenter.reminderConfig = config
      return config

    } catch (err) {
      console.error("读取提醒配置失败，使用内存缓存或默认", JSON.stringify(err))
      // 如果解析失败，只要内存里有，就返回内存里的旧数据，千万不要返回 new ReminderConfig()!
      if (DataCenter.reminderConfig) {
        return DataCenter.reminderConfig
      }
      return new ReminderConfig()
    }
  }

  // 【新增 3】注册设置页面的刷新回调
  static registerRefreshReminderUI(callback: () => void) {
    DataCenter.refreshReminderUICallback = callback;
  }

  // 【新增 4】取消注册
  static unregisterRefreshReminderUI() {
    DataCenter.refreshReminderUICallback = null;
  }

  static async sendDeviceKVCommand(key: string, value: string | number | boolean, requireSync: boolean = false): Promise<boolean> {
    const connected = BleService.isConnected() || await DataCenter.isDeviceConnected();
    if (!connected) return false;
    if (requireSync) {
      const syncEnabled = await DataCenter.isDeviceSyncEnabled();
      if (!syncEnabled) return false;
    }
    const cmdKey = key.trim().toUpperCase();
    if (cmdKey.length === 0) return false;

    let valueText: string = '';
    if (typeof value === 'boolean') {
      valueText = value ? '1' : '0';
    } else if (typeof value === 'number') {
      valueText = isFinite(value) ? String(value) : '0';
    } else {
      const normalized = value.replace(/[\[\]]/g, ' ').trim();
      valueText = normalized.length > 0 ? `"${normalized}"` : `""`;
    }
    const packet = `$${cmdKey}:${valueText}`;
    await DataCenter.setString(DataKey.DEV_LAST_COMMAND, packet);
    await DataCenter.setNumber(DataKey.DEV_LAST_COMMAND_TS, Date.now());
    return BleService.sendPacket(packet);
  }

  static async getNumberArray(key: string, def: number[] = []): Promise<number[]> {
    const raw: string = await DataCenter.getString(key, '');
    if (raw.length === 0) return def;
    try {
      const parsed = JSON.parse(raw) as Array<number>;
      if (!Array.isArray(parsed)) return def;
      const out: number[] = [];
      for (let i = 0; i < parsed.length; i++) {
        out.push(isFinite(parsed[i]) ? parsed[i] : 0);
      }
      return out;
    } catch (err) {
      console.error('getNumberArray parse error', err);
      return def;
    }
  }

  static async getNumberArrayFixed(key: string, len: number, fill: number = 0): Promise<number[]> {
    const arr: number[] = await DataCenter.getNumberArray(key, []);
    const out: number[] = [];
    for (let i = 0; i < len; i++) {
      if (i < arr.length) {
        out.push(arr[i]);
      } else {
        out.push(fill);
      }
    }
    return out;
  }

  static async setNumberArray(key: string, arr: number[]): Promise<void> {
    await DataCenter.setString(key, JSON.stringify(arr));
  }

  static async getStringArray(key: string, def: string[] = []): Promise<string[]> {
    const raw: string = await DataCenter.getString(key, '');
    if (raw.length === 0) return def;
    try {
      const parsed = JSON.parse(raw) as Array<string>;
      if (!Array.isArray(parsed)) return def;
      const out: string[] = [];
      for (let i = 0; i < parsed.length; i++) {
        out.push(String(parsed[i]));
      }
      return out;
    } catch (err) {
      console.error('getStringArray parse error', err);
      return def;
    }
  }

  static async setStringArray(key: string, arr: string[]): Promise<void> {
    await DataCenter.setString(key, JSON.stringify(arr));
  }

  static async setManyItems(items: KVPair[]): Promise<void> {
    try {
      const p: preferences.Preferences = await DataCenter.ensurePref();
      for (let i = 0; i < items.length; i++) {
        await p.put(items[i].key, items[i].value);
      }
      await p.flush();
    } catch (err) {
      console.error('setManyItems error', err);
    }
  }

  static calcStats(data: number[]): StatsObj {
    if (data.length === 0) {
      return new StatsObj(0, 0, 0, 0);
    }
    let minV: number = data[0];
    let maxV: number = data[0];
    let sum: number = 0;
    for (let i = 0; i < data.length; i++) {
      const v = data[i];
      if (v < minV) minV = v;
      if (v > maxV) maxV = v;
      sum += v;
    }
    return new StatsObj(minV, maxV, sum, data.length);
  }

  static calcStatsIgnoreZero(data: number[]): StatsObj {
    const valid: number[] = [];
    for (let i = 0; i < data.length; i++) {
      if (data[i] > 0) {
        valid.push(data[i]);
      }
    }
    if (valid.length === 0) {
      return new StatsObj(0, 0, 0, 0);
    }
    return DataCenter.calcStats(valid);
  }

  static getNormalizedRange(_value: string): HealthRange {
    if (_value.indexOf('30d') >= 0) return '30d';
    if (_value.indexOf('7d') >= 0) return '7d';
    if (_value === '30d' || _value === '7d' || _value === 'today') {
      return _value;
    }
    return 'today';
  }

  static getRangePointCount(value: string): number {
    const range: HealthRange = DataCenter.getNormalizedRange(value);
    if (range === '30d') return 30;
    if (range === '7d') return 7;
    return 24;
  }

  static getLatestRecord(records: HealthMetricRecord[]): HealthMetricRecord | null {
    if (records.length === 0) return null;
    let latest: HealthMetricRecord = records[0];
    for (let i = 1; i < records.length; i++) {
      if (records[i].timestamp > latest.timestamp) {
        latest = records[i];
      }
    }
    return latest;
  }

  static getRecordValue(record: HealthMetricRecord, valueIndex: number): number {
    if (valueIndex === 0) return record.value;
    if (valueIndex === 1) return record.value2;
    if (valueIndex === 2) return record.value3;
    if (valueIndex === 3) return record.value4;
    if (valueIndex === 4) return record.value5;
    return record.value;
  }

  static getDayStartTimestamp(ts: number): number {
    const d: Date = new Date(ts);
    d.setHours(0, 0, 0, 0);
    return d.getTime();
  }

  static async getLatestHealthRecordByRange(key: string, rangeValue: string): Promise<HealthMetricRecord | null> {
    const records = await DataCenter.getHealthRecords(key);
    return DataCenter.getLatestRecord(records);
  }

  static async getHealthRecords(key: string, def: HealthMetricRecord[] = []): Promise<HealthMetricRecord[]> {
    const raw: string = await DataCenter.getString(key, '');
    if (raw.length === 0) return def;
    try {
      const parsed = JSON.parse(raw) as Array<Record<string, JsonField>>;
      if (!Array.isArray(parsed)) return def;
      const out: HealthMetricRecord[] = [];
      for (let i = 0; i < parsed.length; i++) {
        const normalized = DataCenter.normalizeHealthRecord(parsed[i]);
        if (normalized !== null) {
          out.push(normalized);
        }
      }
      out.sort((a: HealthMetricRecord, b: HealthMetricRecord) => a.timestamp - b.timestamp);
      return out;
    } catch (err) {
      console.error('getHealthRecords parse error', err);
      return def;
    }
  }

  static async setHealthRecords(key: string, records: HealthMetricRecord[]): Promise<void> {
    await DataCenter.setString(key, JSON.stringify(records));
  }

  static async appendHealthRecord(key: string, record: HealthMetricRecord): Promise<void> {
    const records = await DataCenter.getHealthRecords(key, []);
    records.push(record);
    await DataCenter.setHealthRecords(key, records);
  }

  static async applyBluetoothPacket(packet: string): Promise<void> {
    const pairs: KVPair[] = DataCenter.parseBluetoothPacket(packet);
    if (pairs.length === 0) return;

    const map: Record<string, string> = {};
    for (let i = 0; i < pairs.length; i++) {
      const k = DataCenter.normalizeBtKey(pairs[i].key);
      map[k] = pairs[i].value;
    }

    const items: KVPair[] = [];
    DataCenter.pushNumberFromMap(items, map, 'today_kcal', DataKey.TODAY_KCAL);
    DataCenter.pushNumberFromMap(items, map, 'today_steps', DataKey.TODAY_STEPS);
    DataCenter.pushNumberFromMap(items, map, 'today_exercise_min', DataKey.TODAY_EXERCISE_MIN);
    DataCenter.pushNumberFromMap(items, map, 'today_distance_km', DataKey.TODAY_DISTANCE_KM);
    DataCenter.pushNumberFromMap(items, map, 'today_avg_hr', DataKey.TODAY_AVG_HR);

    const stress = DataCenter.readNumMap(map, 'stress');
    if (stress !== null) {
      const ts = DataCenter.readNumMap(map, 'stress_ts');
      const status = DataCenter.readStrMap(map, 'stress_status');
      await DataCenter.appendHealthRecord(DataKey.HEALTH_STRESS_RECORDS, {
        timestamp: DataCenter.resolveBtTimestamp(ts, Date.now()),
        value: stress,
        value2: 0,
        value3: 0,
        value4: 0,
        value5: 0,
        status: status !== null ? status : '',
        extra: ''
      });
    }

    const hr = DataCenter.readNumMap(map, 'hr');
    if (hr !== null) {
      const ts = DataCenter.readNumMap(map, 'hr_ts');
      const status = DataCenter.readStrMap(map, 'hr_status');
      await DataCenter.appendHealthRecord(DataKey.HEALTH_HR_RECORDS, {
        timestamp: DataCenter.resolveBtTimestamp(ts, Date.now()),
        value: hr,
        value2: 0,
        value3: 0,
        value4: 0,
        value5: 0,
        status: status !== null ? status : '',
        extra: ''
      });
    }

    const sleepTotal = DataCenter.readNumMap(map, 'sleep_total_min');
    const sleepAwake = DataCenter.readNumMap(map, 'sleep_awake_min');
    const sleepRem = DataCenter.readNumMap(map, 'sleep_rem_min');
    const sleepLight = DataCenter.readNumMap(map, 'sleep_light_min');
    const sleepDeep = DataCenter.readNumMap(map, 'sleep_deep_min');
    if (sleepTotal !== null || sleepAwake !== null || sleepRem !== null || sleepLight !== null || sleepDeep !== null) {
      const ts = DataCenter.readNumMap(map, 'sleep_ts');
      const status = DataCenter.readStrMap(map, 'sleep_status');
      const quality = DataCenter.readStrMap(map, 'sleep_quality');
      await DataCenter.appendHealthRecord(DataKey.HEALTH_SLEEP_RECORDS, {
        timestamp: DataCenter.resolveBtTimestamp(ts, Date.now()),
        value: sleepTotal !== null ? sleepTotal : 0,
        value2: sleepAwake !== null ? sleepAwake : 0,
        value3: sleepRem !== null ? sleepRem : 0,
        value4: sleepLight !== null ? sleepLight : 0,
        value5: sleepDeep !== null ? sleepDeep : 0,
        status: status !== null ? status : '',
        extra: quality !== null ? quality : ''
      });
    }

    // 通知UI刷新
    if (DataCenter.onDataUpdated) {
      DataCenter.onDataUpdated();
    }
  }

  // ===================== 修复缺失的内部辅助方法 =====================
  private static resolveBtTimestamp(ts: number | null, now: number): number {
    if (ts === null) return now;
    const normalized = DataCenter.normalizeTimestamp(ts);
    return normalized > 0 ? normalized : now;
  }

  private static normalizeHealthRecord(raw: Record<string, JsonField>): HealthMetricRecord | null {
    const timestamp = DataCenter.pickNumber(raw, ['ts', 'time', 'timestamp'], 0);
    if (timestamp <= 0) return null;
    return {
      timestamp: DataCenter.normalizeTimestamp(timestamp),
      value: DataCenter.pickNumber(raw, ['value', 'systolic', 'systolicPressure', 'glucose', 'stress', 'heartRate', 'restingHeartRate', 'totalMin'], 0),
      value2: DataCenter.pickNumber(raw, ['value2', 'diastolic'], 0),
      value3: DataCenter.pickNumber(raw, ['value3', 'remMin'], 0),
      value4: DataCenter.pickNumber(raw, ['value4', 'lightMin'], 0),
      value5: DataCenter.pickNumber(raw, ['value5', 'deepMin'], 0),
      status: DataCenter.pickString(raw, ['status'], ''),
      extra: DataCenter.pickString(raw, ['extra', 'quality'], '')
    };
  }

  private static normalizeTimestamp(ts: number): number {
    // ns 19位
    if (ts >= 1e18) {
      return Math.round(ts / 1000000);
    }
    // us 16位
    if (ts >= 1e15) {
      return Math.round(ts / 1000);
    }
    // ms 13位
    if (ts >= 1e12) {
      return ts;
    }
    // 秒 10位
    return Math.round(ts * 1000);
  }

  private static pickNumber(raw: Record<string, JsonField>, keys: string[], def: number): number {
    for (let i = 0; i < keys.length; i++) {
      const key = keys[i];
      // 替代 in 运算符：判断字段不等于undefined
      const value = raw[key];
      if (value === undefined) {
        continue;
      }

      if (typeof value === 'number') {
        // 手写判断有限数字，替代 Number.isFinite
        if (!(value === Infinity || value === -Infinity || value !== value)) {
          return value;
        }
      }
      if (typeof value === 'string') {
        const parsed = Number(value);
        if (!(parsed === Infinity || parsed === -Infinity || parsed !== parsed)) {
          return parsed;
        }
      }
      if (typeof value === 'boolean') {
        return value ? 1 : 0;
      }
    }
    return def;
  }

  private static pickString(raw: Record<string, JsonField>, keys: string[], def: string): string {
    for (let i = 0; i < keys.length; i++) {
      const key = keys[i];
      const value = raw[key];
      // key不存在则value为undefined，直接跳过
      if (value === undefined) {
        continue;
      }
      if (typeof value === 'string') {
        return value;
      }
    }
    return def;
  }

  private static filterRecordsByRange(records: HealthMetricRecord[], _rangeValue: string): HealthMetricRecord[] {
    const range: HealthRange = DataCenter.getNormalizedRange(_rangeValue);
    const now: number = Date.now();
    const todayStart: number = DataCenter.getDayStartTimestamp(now);
    let startInclusive: number;
    let endExclusive: number = todayStart + DataCenter.DAY_MS;
    if (range === 'today') {
      startInclusive = todayStart;
    } else if (range === '7d') {
      startInclusive = todayStart - (7 - 1) * DataCenter.DAY_MS;
    } else if (range === '30d') {
      startInclusive = todayStart - (30 - 1) * DataCenter.DAY_MS;
    } else {
      startInclusive = todayStart;
    }
    const out: HealthMetricRecord[] = [];
    for (let i = 0; i < records.length; i++) {
      const ts: number = records[i].timestamp;
      if (ts >= startInclusive && ts < endExclusive) {
        out.push(records[i]);
      }
    }
    return out;
  }

  private static buildTodayHourlySeries(records: HealthMetricRecord[], valueIndex: number, reducer: HealthReducer): number[] {
    const now: number = Date.now();
    const todayStart: number = DataCenter.getDayStartTimestamp(now);
    const bucketData: number[][] = [];
    const latestTs: number[] = [];
    for (let i = 0; i < 24; i++) {
      bucketData.push([]);
      latestTs.push(0);
    }
    for (let i = 0; i < records.length; i++) {
      const record = records[i];
      if (record.timestamp < todayStart || record.timestamp >= todayStart + DataCenter.DAY_MS) {
        continue;
      }
      const hourIndex: number = new Date(record.timestamp).getHours();
      const value: number = DataCenter.getRecordValue(record, valueIndex);
      if (!isFinite(value)) continue;
      if (reducer === 'latest') {
        if (record.timestamp >= latestTs[hourIndex]) {
          latestTs[hourIndex] = record.timestamp;
          bucketData[hourIndex] = [value];
        }
      } else {
        bucketData[hourIndex].push(value);
      }
    }
    return DataCenter.finalizeSeries(bucketData, reducer);
  }

  private static buildDailySeries(records: HealthMetricRecord[], days: number, valueIndex: number, reducer: HealthReducer): number[] {
    const now: number = Date.now();
    const todayStart: number = DataCenter.getDayStartTimestamp(now);
    const startInclusive: number = todayStart - (days - 1) * DataCenter.DAY_MS;
    const bucketData: number[][] = [];
    const latestTs: number[] = [];
    for (let i = 0; i < days; i++) {
      bucketData.push([]);
      latestTs.push(0);
    }
    for (let i = 0; i < records.length; i++) {
      const record = records[i];
      const recordDayStart = DataCenter.getDayStartTimestamp(record.timestamp);
      if (recordDayStart < startInclusive || recordDayStart > todayStart) {
        continue;
      }
      const bucketIndex: number = Math.floor((recordDayStart - startInclusive) / DataCenter.DAY_MS);
      if (bucketIndex < 0 || bucketIndex >= days) {
        continue;
      }
      const value: number = DataCenter.getRecordValue(record, valueIndex);
      if (!isFinite(value)) continue;
      if (reducer === 'latest') {
        if (record.timestamp >= latestTs[bucketIndex]) {
          latestTs[bucketIndex] = record.timestamp;
          bucketData[bucketIndex] = [value];
        }
      } else {
        bucketData[bucketIndex].push(value);
      }
    }
    return DataCenter.finalizeSeries(bucketData, reducer);
  }

  private static finalizeSeries(bucketData: number[][], reducer: HealthReducer): number[] {
    const out: number[] = [];
    for (let i = 0; i < bucketData.length; i++) {
      const values = bucketData[i];
      if (values.length === 0) {
        out.push(0);
        continue;
      }
      if (reducer === 'sum') {
        let sum = 0;
        for (let j = 0; j < values.length; j++) sum += values[j];
        out.push(sum);
        continue;
      }
      if (reducer === 'max') {
        let max = values[0];
        for (let j = 1; j < values.length; j++) {
          if (values[j] > max) max = values[j];
        }
        out.push(max);
        continue;
      }
      if (reducer === 'min') {
        let min = values[0];
        for (let j = 1; j < values.length; j++) {
          if (values[j] < min) min = values[j];
        }
        out.push(min);
        continue;
      }
      if (reducer === 'latest') {
        out.push(values[values.length - 1]);
        continue;
      }
      // avg
      let sum = 0;
      for (let j = 0; j < values.length; j++) sum += values[j];
      out.push(sum / values.length);
    }
    return out;
  }

  private static parseBluetoothPacket(packet: string): KVPair[] {
    const pairs: KVPair[] = [];
    const segments = packet.split(',');
    for (const seg of segments) {
      const colonIdx = seg.indexOf(':');
      if (colonIdx <= 0) continue;
      const key = seg.substring(0, colonIdx).trim();
      const value = seg.substring(colonIdx + 1).trim();
      pairs.push({ key, value });
    }
    return pairs;
  }

  private static normalizeBtKey(s: string): string {
    return s.trim().toLowerCase();
  }

  private static readNumMap(map: Record<string, string>, key: string): number | null {
    const raw = map[DataCenter.normalizeBtKey(key)];
    if (raw === undefined) return null;
    const n = Number(raw);
    if (isFinite(n)) return n;
    return null;
  }

  private static readStrMap(map: Record<string, string>, key: string): string | null {
    const raw = map[DataCenter.normalizeBtKey(key)];
    if (raw === undefined) return null;
    return raw;
  }

  private static pushNumberFromMap(items: KVPair[], map: Record<string, string>, btKey: string, dataKey: string): void {
    const v = DataCenter.readNumMap(map, btKey);
    if (v !== null) {
      items.push({ key: dataKey, value: String(v) });
    }
  }
}