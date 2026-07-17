/**
 * Help 页面的纯数据契约。该模块不持有 UI、资源、网络或持久化对象，确保内容和校验规则可在主机单元测试中运行。
 * 后续扩展分类或 FAQ 时，应在这里集中维护稳定顺序，并同步更新模型契约测试。
 */
export enum MineFeedbackCategory {
  FEATURE = 'feature',
  USAGE = 'usage',
  DEVICE = 'device',
  OTHER = 'other'
}

export interface MineFeedbackCategoryOption {
  value: MineFeedbackCategory
  label: string
}

export interface MineHelpFaqItem {
  question: string
  answer: string
}

/** 每次返回新数组，避免页面之间共享并意外修改分类顺序。 */
export function createMineFeedbackCategoryOptions(): MineFeedbackCategoryOption[] {
  return [
    { value: MineFeedbackCategory.FEATURE, label: '功能建议' },
    { value: MineFeedbackCategory.USAGE, label: '使用问题' },
    { value: MineFeedbackCategory.DEVICE, label: '设备问题' },
    { value: MineFeedbackCategory.OTHER, label: '其他' }
  ]
}

/** FAQ 文案及顺序属于模型契约；展示层只消费快照，不应复制或重排这些内容。 */
export function createMineHelpFaqItems(): MineHelpFaqItem[] {
  return [
    {
      question: '设备连接异常怎么办？',
      answer: '检查设备电量、蓝牙状态和设备距离，然后重新进入设备详情检查连接状态。'
    },
    {
      question: '数据没有及时更新怎么办？',
      answer: '保持手机与设备连接，等待同步完成；仍未更新时可重新连接设备。'
    },
    {
      question: '如何提交意见反馈？',
      answer: '选择问题类型并填写具体情况；当前版本只提供表单体验，内容不会发送。'
    }
  ]
}

/** 校验用户可见内容；首尾空白不计入 1 至 300 个字符的有效范围。 */
export function isMineFeedbackContentValid(content: string): boolean {
  const trimmedContent: string = content.trim()
  return trimmedContent.length >= 1 && trimmedContent.length <= 300
}
