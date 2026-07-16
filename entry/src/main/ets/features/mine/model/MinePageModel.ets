/** Mine 菜单使用的图标语义键；UI 组件负责把键映射成具体 Resource。 */
export enum MineMenuIconKey {
  HEALTH_SETTINGS = 'healthSettings',
  DATA_MANAGEMENT = 'dataManagement',
  DEVICE_MANAGEMENT = 'deviceManagement',
  PRIVACY = 'privacy',
  HELP = 'help',
  ABOUT = 'about'
}

/**
 * Mine 功能内部路由。枚举值用于 NavPathStack 的 name，不是应用级页面 URL。
 * 新增 Mine 二级页时，应先在这里声明稳定路由，再补菜单、标题和测试。
 */
export enum MineDetailRoute {
  NONE = 'none',
  PROFILE = 'profile',
  HEALTH_SETTINGS = 'healthSettings',
  DATA_MANAGEMENT = 'dataManagement',
  DEVICE_MANAGEMENT = 'deviceManagement',
  PRIVACY = 'privacy',
  HELP = 'help',
  ABOUT = 'about'
}

/** 单个菜单项的完整数据契约。 */
export interface MineMenuItem {
  label: string
  iconKey: MineMenuIconKey
  route: MineDetailRoute
}

/** 一个白色菜单卡片中包含的一组菜单项。 */
export interface MineMenuGroup {
  items: MineMenuItem[]
}

/**
 * 创建 Mine 首页菜单快照。
 * 返回新数组可以避免页面之间意外共享并修改同一个可变数组。
 */
export function createMineMenuGroups(): MineMenuGroup[] {
  return [
    {
      items: [
        {
          label: '健康设置',
          iconKey: MineMenuIconKey.HEALTH_SETTINGS,
          route: MineDetailRoute.HEALTH_SETTINGS
        },
        {
          label: '数据管理',
          iconKey: MineMenuIconKey.DATA_MANAGEMENT,
          route: MineDetailRoute.DATA_MANAGEMENT
        },
        {
          label: '设备管理',
          iconKey: MineMenuIconKey.DEVICE_MANAGEMENT,
          route: MineDetailRoute.DEVICE_MANAGEMENT
        },
        {
          label: '系统与隐私',
          iconKey: MineMenuIconKey.PRIVACY,
          route: MineDetailRoute.PRIVACY
        }
      ]
    },
    {
      items: [
        { label: '帮助与反馈', iconKey: MineMenuIconKey.HELP, route: MineDetailRoute.HELP },
        { label: '关于我们', iconKey: MineMenuIconKey.ABOUT, route: MineDetailRoute.ABOUT }
      ]
    }
  ]
}

/** Mine 内部路由到页面标题的唯一映射，避免页面中散落重复 switch。 */
export function getMineDetailTitle(route: MineDetailRoute): string {
  switch (route) {
    case MineDetailRoute.PROFILE:
      return '个人资料'
    case MineDetailRoute.HEALTH_SETTINGS:
      return '健康设置'
    case MineDetailRoute.DATA_MANAGEMENT:
      return '数据管理'
    case MineDetailRoute.DEVICE_MANAGEMENT:
      return '设备管理'
    case MineDetailRoute.PRIVACY:
      return '系统与隐私'
    case MineDetailRoute.HELP:
      return '帮助与反馈'
    case MineDetailRoute.ABOUT:
      return '关于我们'
    case MineDetailRoute.NONE:
    default:
      return ''
  }
}

/**
 * 把 Navigation 的根页面可见状态转换成应用壳层理解的通用深度。
 * 导航栏不可见但栈尺寸回调尚未更新时至少返回 1，防止底栏短暂错误显示。
 */
export function getMineNavigationDepth(isNavBarVisible: boolean, stackSize: number): number {
  return isNavBarVisible ? 0 : Math.max(1, stackSize)
}
