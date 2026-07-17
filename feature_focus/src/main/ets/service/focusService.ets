/**
 * 专注业务核心服务
 * service层：处理业务规则与状态逻辑
 * 支持：计时、暂停、恢复、结束、前后台时间戳恢复
 */

/** 专注阶段枚举 */
export enum FocusPhase {
  IDLE = 'idle',
  FOCUS = 'focus',
  REST = 'rest'
}

/** 专注默认规则配置 */
export class FocusRule {
  public static readonly DEFAULT_FOCUS_MIN = 25;
  public static readonly DEFAULT_REST_MIN = 5;
  public static readonly MIN_FOCUS_MIN = 5;
  public static readonly MAX_FOCUS_MIN = 60;
  public static readonly MIN_REST_MIN = 1;
  public static readonly MAX_REST_MIN = 30;
}

/** 会话恢复数据 */
export interface SessionSnapshot {
  phase: FocusPhase;
  isRunning: boolean;
  remainingSeconds: number;
  timestamp: number; // 记录快照时的时间戳(ms)
  todayPomodoros: number;
  todayFocusSeconds: number;
}

/** 单次会话记录（用于条形图展示） */
export interface SessionRecord {
  type: string; // 'focus' | 'rest'
  durationMin: number;
  startTime: string; // 格式化时间如 "14:30"
  timestamp: number;
}

/** 专注核心引擎服务 */
export class FocusService {
  // 配置
  private focusDurationMin: number = FocusRule.DEFAULT_FOCUS_MIN;
  private restDurationMin: number = FocusRule.DEFAULT_REST_MIN;

  // 运行状态
  private phase: FocusPhase = FocusPhase.IDLE;
  private isRunning: boolean = false;
  private remainingSeconds: number = this.focusDurationMin * 60;
  private timer: number | null = null;

  // 统计数据
  private todayPomodoros: number = 0;
  private todayFocusSeconds: number = 0;

  // 会话记录（用于条形图展示）
  private sessionRecords: SessionRecord[] = [];

  // 记录当前阶段开始时间和设定时长，用于阶段完成时计算
  private currentSessionStartTime: number = 0;
  private currentSessionDurationMin: number = 0;

  // 状态回调
  private stateChangeCb: (() => void) | null = null;

  setStateListener(cb: () => void): void {
    this.stateChangeCb = cb;
  }

  /**
   * 开始专注（防重复）
   * 重复点击不会创建多个计时器
   * 若当前处于休息阶段，先记录休息会话再切换到专注
   */
  start(): void {
    if (this.isRunning) return;
    // 休息阶段强制重启：先记录当前休息会话
    if (this.phase === FocusPhase.REST) {
      this.recordSession();
    }
    if (this.phase === FocusPhase.IDLE || this.phase === FocusPhase.REST) {
      this.phase = FocusPhase.FOCUS;
      this.remainingSeconds = this.focusDurationMin * 60;
    }
    // 记录当前阶段开始时间
    this.currentSessionStartTime = Date.now();
    this.isRunning = true;
    this.startTimer();
    this.notifyStateChange();
  }

  /**
   * 暂停计时
   * 暂停期间剩余时间不减少
   */
  pause(): void {
    if (!this.isRunning) return;
    this.isRunning = false;
    this.stopTimer();
    this.notifyStateChange();
  }

  /**
   * 恢复计时
   */
  resume(): void {
    if (this.isRunning || this.phase === FocusPhase.IDLE) return;
    this.isRunning = true;
    this.startTimer();
    this.notifyStateChange();
  }

  /**
   * 重置所有状态
   */
  reset(): void {
    this.stopTimer();
    this.isRunning = false;
    this.phase = FocusPhase.IDLE;
    this.remainingSeconds = this.focusDurationMin * 60;
    this.notifyStateChange();
  }

  /**
   * 结束当前会话（手动触发）
   * 记录当前阶段后切换到下一阶段或停止
   */
  finish(): void {
    this.stopTimer();
    // 记录当前阶段
    this.recordSession();
    if (this.phase === FocusPhase.FOCUS) {
      this.todayPomodoros++;
      this.phase = FocusPhase.REST;
      this.remainingSeconds = this.restDurationMin * 60;
      // 自动启动休息计时
      this.currentSessionStartTime = Date.now();
      this.isRunning = true;
      this.startTimer();
    } else if (this.phase === FocusPhase.REST) {
      this.phase = FocusPhase.IDLE;
      this.remainingSeconds = this.focusDurationMin * 60;
      this.isRunning = false;
    }
    this.notifyStateChange();
  }

  private startTimer(): void {
    if (this.timer !== null) {
      return; // 防重复计时器
    }
    this.timer = setInterval(() => {
      this.remainingSeconds--;
      if (this.phase === FocusPhase.FOCUS) {
        this.todayFocusSeconds++;
      }
      if (this.remainingSeconds <= 0) {
        this.onPhaseComplete();
      }
      this.notifyStateChange();
    }, 1000);
  }

  private stopTimer(): void {
    if (this.timer !== null) {
      clearInterval(this.timer);
      this.timer = null;
    }
  }

  /**
   * 阶段完成处理
   * 专注完成后自动进入休息，休息完成后回到空闲
   */
  private onPhaseComplete(): void {
    this.stopTimer();
    // 记录当前阶段
    this.recordSession();
    if (this.phase === FocusPhase.FOCUS) {
      this.todayPomodoros++;
      this.phase = FocusPhase.REST;
      this.remainingSeconds = this.restDurationMin * 60;
      // 自动启动休息计时
      this.currentSessionStartTime = Date.now();
      this.isRunning = true;
      this.startTimer();
    } else if (this.phase === FocusPhase.REST) {
      this.phase = FocusPhase.IDLE;
      this.remainingSeconds = this.focusDurationMin * 60;
      this.isRunning = false;
    }
  }

  /**
   * 设置时长配置
   */
  setDuration(focusMin: number, restMin: number): void {
    const focus = Math.max(FocusRule.MIN_FOCUS_MIN, Math.min(FocusRule.MAX_FOCUS_MIN, focusMin));
    const rest = Math.max(FocusRule.MIN_REST_MIN, Math.min(FocusRule.MAX_REST_MIN, restMin));
    this.focusDurationMin = focus;
    this.restDurationMin = rest;
    if (this.phase === FocusPhase.IDLE) {
      this.remainingSeconds = this.focusDurationMin * 60;
    }
    this.notifyStateChange();
  }

  /**
   * 创建当前会话快照（用于持久化恢复）
   */
  createSnapshot(): SessionSnapshot {
    return {
      phase: this.phase,
      isRunning: this.isRunning,
      remainingSeconds: this.remainingSeconds,
      timestamp: Date.now(),
      todayPomodoros: this.todayPomodoros,
      todayFocusSeconds: this.todayFocusSeconds
    };
  }

  /**
   * 从快照恢复会话
   * 根据时间戳计算前后台切换后的剩余时间
   */
  restoreFromSnapshot(snapshot: SessionSnapshot): void {
    this.stopTimer();

    this.phase = snapshot.phase;
    this.todayPomodoros = snapshot.todayPomodoros;
    this.todayFocusSeconds = snapshot.todayFocusSeconds;

    if (snapshot.isRunning && snapshot.phase !== FocusPhase.IDLE) {
      // 计算从快照到现在的经过时间
      const elapsedMs = Date.now() - snapshot.timestamp;
      const elapsedSeconds = Math.floor(elapsedMs / 1000);
      const correctedRemaining = snapshot.remainingSeconds - elapsedSeconds;

      if (correctedRemaining <= 0) {
        // 计时已超时，自动完成当前阶段
        if (snapshot.phase === FocusPhase.FOCUS) {
          this.todayPomodoros++;
          this.todayFocusSeconds += snapshot.remainingSeconds; // 只加实际剩余
          this.phase = FocusPhase.REST;
          this.remainingSeconds = this.restDurationMin * 60;
          // 自动启动休息计时
          this.currentSessionStartTime = Date.now();
          this.isRunning = true;
          this.startTimer();
        } else {
          this.phase = FocusPhase.IDLE;
          this.remainingSeconds = this.focusDurationMin * 60;
          this.isRunning = false;
        }
      } else {
        this.remainingSeconds = correctedRemaining;
        this.isRunning = true;
        this.startTimer();
      }
    } else {
      this.remainingSeconds = snapshot.remainingSeconds;
      this.isRunning = false;
    }

    this.notifyStateChange();
  }

  /**
   * 恢复统计数据
   */
  restoreStats(pomodoros: number, focusSeconds: number): void {
    this.todayPomodoros = pomodoros;
    this.todayFocusSeconds = focusSeconds;
  }

  destroy(): void {
    this.stopTimer();
    this.stateChangeCb = null;
  }

  /**
   * 记录当前完成的会话（用于条形图）
   */
  private recordSession(): void {
    if (this.currentSessionStartTime === 0) {
      return;
    }
    const elapsedMs: number = Date.now() - this.currentSessionStartTime;
    const elapsedMin: number = Math.round(elapsedMs / 60000);
    if (elapsedMin < 1) {
      this.currentSessionStartTime = 0;
      return;
    }

    const date: Date = new Date(this.currentSessionStartTime);
    const hour: string = String(date.getHours()).padStart(2, '0');
    const minute: string = String(date.getMinutes()).padStart(2, '0');

    const record: SessionRecord = {
      type: this.phase === FocusPhase.FOCUS ? 'focus' : 'rest',
      durationMin: elapsedMin,
      startTime: `${hour}:${minute}`,
      timestamp: this.currentSessionStartTime
    };
    this.sessionRecords.push(record);
    this.currentSessionStartTime = 0;
  }

  /**
   * 获取会话记录
   */
  getSessionRecords(): SessionRecord[] {
    return this.sessionRecords;
  }

  /**
   * 设置会话记录（用于恢复）
   */
  setSessionRecords(records: SessionRecord[]): void {
    this.sessionRecords = records;
  }

  private notifyStateChange(): void {
    this.stateChangeCb?.();
  }

  // 只读Getter
  getPhase(): FocusPhase { return this.phase; }
  getIsRunning(): boolean { return this.isRunning; }
  getRemainingSeconds(): number { return this.remainingSeconds; }
  getTodayPomodoros(): number { return this.todayPomodoros; }
  getTodayFocusMinutes(): number { return Math.floor(this.todayFocusSeconds / 60); }
  getTodayFocusSeconds(): number { return this.todayFocusSeconds; }
  getFocusDurationMin(): number { return this.focusDurationMin; }
  getRestDurationMin(): number { return this.restDurationMin; }
}