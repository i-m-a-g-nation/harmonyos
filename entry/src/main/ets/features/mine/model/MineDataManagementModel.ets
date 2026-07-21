/** 数据管理页展示的只读摘要项。 */
export interface MineDataSummaryItem {
  id: string
  label: string
  value: string
}

/** 当前数据均为原型演示值，不代表数据库或云端真实统计。 */
export function createMineDataSummaryItems(): MineDataSummaryItem[] {
  return [
    { id: 'health-records', label: '健康记录', value: '128 条' },
    { id: 'device-records', label: '设备记录', value: '36 条' },
    { id: 'last-sync', label: '最近同步', value: '今天 09:30' }
  ]
}
