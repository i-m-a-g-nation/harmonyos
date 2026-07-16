import {
  getMineDetailTitle,
  getMineNavigationDepth,
  MineDetailRoute
} from './model/MinePageModel'
import { MineDetailPage } from './pages/MineDetailPage'
import { MineHomePage } from './pages/MineHomePage'

@Component
export struct MineRoot {
  onNavigationDepthChange?: (depth: number) => void
  onOpenDeviceDetail?: () => void

  private readonly pathStack: NavPathStack = new NavPathStack()

  private openDetail(route: MineDetailRoute): void {
    this.pathStack.pushPath({ name: route })
  }

  private closeDetail(): void {
    this.pathStack.pop()
  }

  @Builder
  MineDestination(name: string, param: object) {
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
