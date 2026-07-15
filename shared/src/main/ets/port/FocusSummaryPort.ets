/**
 * FocusSummaryPort 接口
 * 专注模块对外暴露的摘要端口，供首页和报告模块使用
 */
import { FocusSummary } from '../model/FocusSummary';

export interface FocusSummaryPort {
  getTodaySummary(): FocusSummary;
}