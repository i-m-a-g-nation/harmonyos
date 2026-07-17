import type { FocusSummary } from '../model/FocusSummary';
export interface FocusSummaryPort {
    getTodaySummary(): FocusSummary;
}
