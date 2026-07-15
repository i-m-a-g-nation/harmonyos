/**
 * 专注数据仓储层
 * MVP：使用 Preferences 保存当前会话最小恢复数据 + 实现 FocusSummaryPort 接口
 */
import { FocusSummary, FocusSummaryPort } from 'shared';
import preferences from '@ohos.data.preferences';
import { common } from '@kit.AbilityKit';
import { SessionSnapshot, FocusPhase, SessionRecord } from '../service/focusService';

const FOCUS_STORE_KEY = 'focus_local_store';

/** 时长配置接口 */
interface DurationConfig {
  focusMin: number;
  restMin: number;
}

export class FocusRepository implements FocusSummaryPort {
  private store: preferences.Preferences | null = null;
  private context: common.Context | null = null;

  /**
   * 初始化Preferences存储，需要传入Context
   */
  async init(context: common.Context): Promise<void> {
    this.context = context;
    this.store = await preferences.getPreferences(context, FOCUS_STORE_KEY);
  }

  /**
   * 实现 FocusSummaryPort - 获取今日摘要
   */
  getTodaySummary(): FocusSummary {
    return {
      focusedMinutes: this.getLocalFocusMinutes(),
      completedPomodoros: this.getLocalPomodoros()
    };
  }

  /**
   * 保存会话快照（用于前后台恢复）
   */
  async saveSessionSnapshot(snapshot: SessionSnapshot): Promise<void> {
    const store: preferences.Preferences = await this.getStore();
    store.putSync('session_phase', snapshot.phase);
    store.putSync('session_is_running', snapshot.isRunning);
    store.putSync('session_remaining', snapshot.remainingSeconds);
    store.putSync('session_timestamp', snapshot.timestamp);
    store.putSync('session_pomodoros', snapshot.todayPomodoros);
    store.putSync('session_focus_seconds', snapshot.todayFocusSeconds);
    await store.flush();
  }

  /**
   * 读取会话快照
   */
  getSessionSnapshot(): SessionSnapshot | null {
    const store: preferences.Preferences | null = this.getStoreSync();
    if (store === null) {
      return null;
    }

    const phaseVal: preferences.ValueType = store.getSync('session_phase', '');
    if (typeof phaseVal !== 'string' || phaseVal === '') {
      return null;
    }

    const isRunningVal: preferences.ValueType = store.getSync('session_is_running', false);
    const remainingVal: preferences.ValueType = store.getSync('session_remaining', 0);
    const timestampVal: preferences.ValueType = store.getSync('session_timestamp', 0);
    const pomodorosVal: preferences.ValueType = store.getSync('session_pomodoros', 0);
    const focusSecondsVal: preferences.ValueType = store.getSync('session_focus_seconds', 0);

    const phase: FocusPhase = phaseVal as FocusPhase;
    const isRunning: boolean = (typeof isRunningVal === 'boolean') ? isRunningVal : false;
    const remainingSeconds: number = (typeof remainingVal === 'number') ? remainingVal : 0;
    const timestamp: number = (typeof timestampVal === 'number') ? timestampVal : 0;
    const todayPomodoros: number = (typeof pomodorosVal === 'number') ? pomodorosVal : 0;
    const todayFocusSeconds: number = (typeof focusSecondsVal === 'number') ? focusSecondsVal : 0;

    const snapshot: SessionSnapshot = {
      phase: phase,
      isRunning: isRunning,
      remainingSeconds: remainingSeconds,
      timestamp: timestamp,
      todayPomodoros: todayPomodoros,
      todayFocusSeconds: todayFocusSeconds
    };
    return snapshot;
  }

  /**
   * 清除会话快照
   */
  async clearSessionSnapshot(): Promise<void> {
    const store: preferences.Preferences = await this.getStore();
    store.deleteSync('session_phase');
    store.deleteSync('session_is_running');
    store.deleteSync('session_remaining');
    store.deleteSync('session_timestamp');
    store.deleteSync('session_pomodoros');
    store.deleteSync('session_focus_seconds');
    await store.flush();
  }

  /**
   * 保存每日统计数据
   */
  async saveDailyStats(pomodoros: number, focusSeconds: number): Promise<void> {
    const store: preferences.Preferences = await this.getStore();
    store.putSync('today_pomodoros', pomodoros);
    store.putSync('today_focus_seconds', focusSeconds);
    await store.flush();
  }

  /**
   * 保存时长配置
   */
  async saveDurationConfig(focusMin: number, restMin: number): Promise<void> {
    const store: preferences.Preferences = await this.getStore();
    store.putSync('config_focus_min', focusMin);
    store.putSync('config_rest_min', restMin);
    await store.flush();
  }

  /**
   * 保存会话记录
   */
  async saveSessionRecords(records: SessionRecord[]): Promise<void> {
    const store: preferences.Preferences = await this.getStore();
    store.putSync('session_records_json', JSON.stringify(records));
    await store.flush();
  }

  /**
   * 读取会话记录
   */
  getSessionRecords(): SessionRecord[] {
    const store: preferences.Preferences | null = this.getStoreSync();
    if (store === null) {
      return [];
    }
    const jsonVal: preferences.ValueType = store.getSync('session_records_json', '');
    if (typeof jsonVal !== 'string' || jsonVal === '') {
      return [];
    }
    const parsed: Object = JSON.parse(jsonVal);
    return parsed as SessionRecord[];
  }

  /**
   * 读取时长配置
   */
  getDurationConfig(): DurationConfig | null {
    const store: preferences.Preferences | null = this.getStoreSync();
    if (store === null) {
      return null;
    }
    const focusMinVal: preferences.ValueType = store.getSync('config_focus_min', -1);
    const focusMin: number = (typeof focusMinVal === 'number') ? focusMinVal : -1;
    if (focusMin === -1) {
      return null;
    }
    const restMinVal: preferences.ValueType = store.getSync('config_rest_min', 5);
    const restMin: number = (typeof restMinVal === 'number') ? restMinVal : 5;
    const config: DurationConfig = {
      focusMin: focusMin,
      restMin: restMin
    };
    return config;
  }

  private getLocalPomodoros(): number {
    const store: preferences.Preferences | null = this.getStoreSync();
    if (store === null) {
      return 0;
    }
    const val: preferences.ValueType = store.getSync('today_pomodoros', 0);
    return (typeof val === 'number') ? val : 0;
  }

  private getLocalFocusMinutes(): number {
    const store: preferences.Preferences | null = this.getStoreSync();
    if (store === null) {
      return 0;
    }
    const val: preferences.ValueType = store.getSync('today_focus_seconds', 0);
    const seconds: number = (typeof val === 'number') ? val : 0;
    return Math.floor(seconds / 60);
  }

  private async getStore(): Promise<preferences.Preferences> {
    if (this.store === null) {
      if (this.context === null) {
        throw new Error('FocusRepository not initialized');
      }
      this.store = await preferences.getPreferences(this.context, FOCUS_STORE_KEY);
    }
    return this.store;
  }

  private getStoreSync(): preferences.Preferences | null {
    if (this.store !== null) {
      return this.store;
    }
    return null;
  }
}