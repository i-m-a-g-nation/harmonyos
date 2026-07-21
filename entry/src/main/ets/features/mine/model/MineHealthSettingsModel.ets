/** 健康目标的稳定语义键。 */
export enum MineHealthGoalKey {
  STEPS = 'steps',
  FOCUS = 'focus',
  WATER = 'water'
}

/** 健康目标展示与边界调整所需的纯数据。 */
export interface MineHealthGoal {
  key: MineHealthGoalKey
  label: string
  unit: string
  defaultValue: number
  minimum: number
  maximum: number
  step: number
}

export function createMineHealthGoals(): MineHealthGoal[] {
  return [
    {
      key: MineHealthGoalKey.STEPS,
      label: '每日步数',
      unit: '步',
      defaultValue: 8000,
      minimum: 1000,
      maximum: 30000,
      step: 1000
    },
    {
      key: MineHealthGoalKey.FOCUS,
      label: '专注时长',
      unit: '分钟',
      defaultValue: 60,
      minimum: 15,
      maximum: 240,
      step: 15
    },
    {
      key: MineHealthGoalKey.WATER,
      label: '饮水次数',
      unit: '次',
      defaultValue: 8,
      minimum: 1,
      maximum: 20,
      step: 1
    }
  ]
}

/** 把一次目标调整限制在模型定义的闭区间内。 */
export function adjustMineHealthGoal(
  value: number,
  delta: number,
  minimum: number,
  maximum: number
): number {
  return Math.min(maximum, Math.max(minimum, value + delta))
}
