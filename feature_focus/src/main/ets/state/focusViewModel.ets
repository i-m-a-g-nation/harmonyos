/**
 * 专注模块状态管理ViewModel
 * state层：UI状态同步 + 业务调用 + 对外接口转发 + 生命周期管理
 */
import { FocusService, FocusPhase, FocusRule, SessionRecord } from '../service/focusService';
import { FocusRepository } from '../repository/focusRepository';
import { FocusSummary, FocusSummaryPort } from 'shared';
import { common } from '@kit.AbilityKit';

export class FocusViewModel implements FocusSummaryPort {
  private service: FocusService;
  private repository: FocusRepository;

  // UI可观察状态
  remainingText: string = '25:00';
  isRunning: boolean = false;
  currentPhase: FocusPhase = FocusPhase.IDLE;
  completedPomodoros: number = 0;
  totalFocusMinutes: number = 0;
  totalFocusSeconds: number = 0;
  focusDurationMin: number = FocusRule.DEFAULT_FOCUS_MIN;
  restDurationMin: number = FocusRule.DEFAULT_REST_MIN;

  // 时长配置弹窗状态
  showConfigPanel: boolean = false;

  // 会话记录（条形图数据）
  sessionRecords: SessionRecord[] = [];
  maxRecordDurationMin: number = 25;

  constructor(service: FocusService, repository: FocusRepository) {
    this.service = service;
    this.repository = repository;
    this.service.setStateListener(() => this.syncState());
  }

  /**
   * 初始化：恢复上次会话和统计数据
   */
  async init(context: common.Context): Promise<void> {
    await this.repository.init(context);

    // 恢复时长配置
    const savedConfig = this.repository.getDurationConfig();
    if (savedConfig !== null) {
      this.focusDurationMin = savedConfig.focusMin;
      this.restDurationMin = savedConfig.restMin;
      this.service.setDuration(savedConfig.focusMin, savedConfig.restMin);
    }

    // 恢复上次会话
    const snapshot = this.repository.getSessionSnapshot();
    if (snapshot !== null) {
      this.service.restoreFromSnapshot(snapshot);
    }

    // 恢复会话记录
    const savedRecords: SessionRecord[] = this.repository.getSessionRecords();
    this.service.setSessionRecords(savedRecords);
    this.sessionRecords = savedRecords;
    this.updateMaxDuration();

    this.syncState();
  }

  /**
   * 同步业务状态到UI
   */
  private syncState(): void {
    this.remainingText = this.formatTime(this.service.getRemainingSeconds());
    this.isRunning = this.service.getIsRunning();
    this.currentPhase = this.service.getPhase();
    this.completedPomodoros = this.service.getTodayPomodoros();
    this.totalFocusMinutes = this.service.getTodayFocusMinutes();
    this.totalFocusSeconds = this.service.getTodayFocusSeconds();
    this.focusDurationMin = this.service.getFocusDurationMin();
    this.restDurationMin = this.service.getRestDurationMin();
    this.sessionRecords = this.service.getSessionRecords();
    this.updateMaxDuration();
  }

  // ==================== UI交互方法 ====================

  /**
   * 开始/暂停切换
   */
  toggleStart(): void {
    if (this.isRunning) {
      this.service.pause();
    } else {
      this.service.start();
    }
  }

  /**
   * 重置计时
   */
  reset(): void {
    this.service.reset();
    this.repository.clearSessionSnapshot();
  }

  /**
   * 结束当前会话
   */
  finish(): void {
    this.service.finish();
    this.persistState();
  }

  /**
   * 设置时长配置
   */
  setDuration(focusMin: number, restMin: number): void {
    this.service.setDuration(focusMin, restMin);
    this.repository.saveDurationConfig(focusMin, restMin);
    this.syncState();
  }

  /**
   * 打开/关闭时长配置面板
   */
  toggleConfigPanel(): void {
    this.showConfigPanel = !this.showConfigPanel;
  }

  // ==================== 生命周期管理 ====================

  /**
   * 页面即将离开前台 - 保存快照
   */
  async onPageHide(): Promise<void> {
    await this.persistState();
  }

  /**
   * 页面即将进入前台 - 恢复快照
   */
  async onPageShow(): Promise<void> {
    const snapshot = this.repository.getSessionSnapshot();
    if (snapshot !== null) {
      this.service.restoreFromSnapshot(snapshot);
    }
    this.syncState();
  }

  /**
   * 页面销毁 - 释放资源
   */
  destroy(): void {
    this.persistState();
    this.service.destroy();
  }

  /**
   * 持久化当前状态
   */
  private async persistState(): Promise<void> {
    const snapshot = this.service.createSnapshot();
    await this.repository.saveSessionSnapshot(snapshot);
    await this.repository.saveDailyStats(
      this.service.getTodayPomodoros(),
      this.service.getTodayFocusSeconds()
    );
    await this.repository.saveSessionRecords(this.service.getSessionRecords());
  }

  // ==================== 对外接口实现 ====================

  /**
   * 实现 FocusSummaryPort - 获取今日摘要
   */
  getTodaySummary(): FocusSummary {
    return this.repository.getTodaySummary();
  }

  // ==================== UI辅助方法 ====================

  /**
   * 获取圆环进度（0-100）
   */
  getProgress(): number {
    const total = this.currentPhase === FocusPhase.FOCUS
      ? this.service.getFocusDurationMin() * 60
      : this.service.getRestDurationMin() * 60;
    if (total === 0) return 0;
    const pass = total - this.service.getRemainingSeconds();
    return Math.round((pass / total) * 100);
  }

  /**
   * 获取提示文字
   */
  getTipText(): string {
    switch (this.currentPhase) {
      case FocusPhase.IDLE:
        return '建议专注25分钟 休息5分钟';
      case FocusPhase.FOCUS:
        return '专注中，保持注意力集中';
      case FocusPhase.REST:
        return '休息一下，放松眼睛';
      default:
        return '';
    }
  }

  /**
   * 获取阶段标签
   */
  getPhaseLabel(): string {
    switch (this.currentPhase) {
      case FocusPhase.IDLE:
        return '准备开始';
      case FocusPhase.FOCUS:
        return '专注中';
      case FocusPhase.REST:
        return '休息中';
      default:
        return '';
    }
  }

  /**
   * 获取按钮文字
   */
  getButtonText(): string {
    if (this.isRunning) {
      return this.currentPhase === FocusPhase.FOCUS ? '暂停专注' : '暂停休息';
    }
    if (this.currentPhase === FocusPhase.IDLE) {
      return '开始专注';
    }
    return '继续';
  }

  /**
   * 更新最大记录时长（用于条形图比例计算）
   */
  private updateMaxDuration(): void {
    let maxVal: number = this.focusDurationMin;
    const records: SessionRecord[] = this.sessionRecords;
    for (let i = 0; i < records.length; i++) {
      if (records[i].durationMin > maxVal) {
        maxVal = records[i].durationMin;
      }
    }
    this.maxRecordDurationMin = maxVal;
  }

  /**
   * 时间格式化
   */
  private formatTime(seconds: number): string {
    const min = Math.floor(seconds / 60);
    const sec = seconds % 60;
    return `${String(min).padStart(2, '0')}:${String(sec).padStart(2, '0')}`;
  }
}

// ============================================================
// 模块工厂方法
// 供entry层AppContainer统一初始化，实现依赖注入
// ============================================================

/**
 * 模块对外能力定义
 */
export interface FocusFeature {
  viewModel: FocusViewModel;
}

/**
 * 模块工厂方法
 * entry层调用此方法创建专注模块实例
 * @param context 应用上下文（从entry层传入，HAR模块无法直接获取globalThis）
 */
export function createFocusFeature(context: common.Context): FocusFeature {
  const service = new FocusService();
  const repository = new FocusRepository();
  const viewModel = new FocusViewModel(service, repository);
  return { viewModel };
}