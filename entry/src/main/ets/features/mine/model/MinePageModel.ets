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

/**
 * MineRoot 用于选择目的地组件的稳定类型。
 *
 * 这里没有直接保存组件或 Resource，因为 model 需要保持为可在主机单元测试中运行的
 * 纯 ArkTS 模块。该类型也只在 Mine 内部使用，不应传递给 Index 等应用壳层代码。
 */
export enum MineDestinationKind {
  // 尚未开发真实内容的路由继续显示统一空壳，保证所有既有入口仍然可点击、可返回。
  PLACEHOLDER = 'placeholder',
  // “数据管理”使用独立页面，当前只展示本地演示摘要和操作提示。
  DATA_MANAGEMENT = 'dataManagement',
  // “设备管理”使用独立页面，并通过回调复用既有设备详情入口。
  DEVICE_MANAGEMENT = 'deviceManagement',
  // “系统与隐私”拥有独立页面；开关当前只保存于页面实例。
  PRIVACY = 'privacy',
  // “帮助与反馈”拥有独立页面，由 MineRoot 渲染 Help 目的地。
  HELP = 'help',
  // “关于我们”已经拥有独立页面，由 MineRoot 渲染 MineAboutPage。
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
 * 把内部路由映射到页面实现。
 * 尚未开发的路由继续复用空壳；已完成的页面逐个增加独立类型。
 *
 * 后续实现新的二级页时，应在 MineDestinationKind 增加类型，并在这里补充映射；
 * 不要让 MineRoot 到处比较菜单文字，也不要为此修改 Index.ets。
 */
export function getMineDestinationKind(route: MineDetailRoute): MineDestinationKind {
  if (route === MineDetailRoute.ABOUT) {
    return MineDestinationKind.ABOUT
  }
  if (route === MineDetailRoute.HELP) {
    return MineDestinationKind.HELP
  }
  if (route === MineDetailRoute.PRIVACY) {
    return MineDestinationKind.PRIVACY
  }
  if (route === MineDetailRoute.DEVICE_MANAGEMENT) {
    return MineDestinationKind.DEVICE_MANAGEMENT
  }
  if (route === MineDetailRoute.DATA_MANAGEMENT) {
    return MineDestinationKind.DATA_MANAGEMENT
  }
  return MineDestinationKind.PLACEHOLDER
}

/**
 * 把 Navigation 的根页面可见状态转换成应用壳层理解的通用深度。
 * 导航栏不可见但栈尺寸回调尚未更新时至少返回 1，防止底栏短暂错误显示。
 */
export function getMineNavigationDepth(isNavBarVisible: boolean, stackSize: number): number {
  return isNavBarVisible ? 0 : Math.max(1, stackSize)
}
