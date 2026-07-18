/** 系统与隐私页面中可切换设置的稳定语义键。 */
export enum MinePrivacyControlKey {
  HEALTH_PERSONALIZATION = 'healthPersonalization',
  DEVICE_SYNC = 'deviceSync',
  EXPERIENCE_PROGRAM = 'experienceProgram'
}

/** 页面展示隐私控制所需的纯数据，不包含 ArkUI 状态或系统权限对象。 */
export interface MinePrivacyControl {
  key: MinePrivacyControlKey
  label: string
  description: string
  defaultEnabled: boolean
}

/**
 * 每次返回新的隐私控制快照，避免多个页面实例共享并修改同一数组。
 * 默认值只是原型展示状态，不代表设备或账号中的真实隐私授权。
 */
export function createMinePrivacyControls(): MinePrivacyControl[] {
  return [
    {
      key: MinePrivacyControlKey.HEALTH_PERSONALIZATION,
      label: '健康数据个性化',
      description: '用于展示更贴合个人习惯的健康建议',
      defaultEnabled: true
    },
    {
      key: MinePrivacyControlKey.DEVICE_SYNC,
      label: '设备数据同步',
      description: '允许当前原型展示设备数据同步状态',
      defaultEnabled: true
    },
    {
      key: MinePrivacyControlKey.EXPERIENCE_PROGRAM,
      label: '体验改进计划',
      description: '当前版本不会收集或上传使用数据',
      defaultEnabled: false
    }
  ]
}
