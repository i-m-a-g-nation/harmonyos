import {
  getMineDetailTitle,
  getMineNavigationDepth,
  MineDetailRoute
} from './model/MinePageModel'
import { MineDetailPage } from './pages/MineDetailPage'
import { MineHomePage } from './pages/MineHomePage'

/**
 * “我的”功能根组件，也是该功能对应用壳层的唯一公开 UI 入口。
 *
 * 它只负责导航编排和跨边界事件转发；具体首页布局、卡片样式和菜单数据
 * 分别由 pages、components 和 model 目录维护。
 */
@Component
export struct MineRoot {
  // 把功能内部状态转换成通用深度通知给 Index，避免向外泄漏 MineDetailRoute。
  onNavigationDepthChange?: (depth: number) => void
  // 请求应用打开独立设备详情页；实际 URL 由 Index 决定。
  onOpenDeviceDetail?: () => void

  // Mine 私有导航栈。Navigation 组件会观察栈的 push/pop，无需把它声明成 @State。
  private readonly pathStack: NavPathStack = new NavPathStack()

  // Mine 首页入口点击后，把对应内部路由压入功能自己的导航栈。
  private openDetail(route: MineDetailRoute): void {
    this.pathStack.pushPath({ name: route })
  }

  // 自定义返回按钮调用 pop；系统返回也由 Navigation 按相同导航栈处理。
  private closeDetail(): void {
    this.pathStack.pop()
  }

  @Builder
  MineDestination(name: string, param: object) {
    // param 为 Navigation 目的地预留参数；当前空二级页暂时不需要使用。
    NavDestination() {
      MineDetailPage({
        title: getMineDetailTitle(name as MineDetailRoute),
        onBack: () => {
          this.closeDetail()
        }
      })
    }
    .hideTitleBar(true)
  }

  build() {
    // 花括号中的 MineHomePage 是导航根页面；pushPath 后由 MineDestination 构建二级页。
    Navigation(this.pathStack) {
      MineHomePage({
        onOpenDetail: (route: MineDetailRoute) => {
          this.openDetail(route)
        },
        onOpenDeviceDetail: () => {
          this.onOpenDeviceDetail?.()
        }
      })
    }
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
    .navDestination(this.MineDestination)
    // 导航根页面可见时深度为 0；二级页可见时上报实际栈深度。
    // Index 据此统一控制底栏和 Tab 横向滑动，不需要知道具体进入了哪个页面。
    .onNavBarStateChange((isVisible: boolean) => {
      this.onNavigationDepthChange?.(
        getMineNavigationDepth(isVisible, this.pathStack.size())
      )
    })
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}
