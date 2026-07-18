import {
  getMineDestinationKind,
  getMineDetailTitle,
  getMineNavigationDepth,
  MineDestinationKind,
  MineDetailRoute
} from './model/MinePageModel'
import { MineAboutPage } from './pages/MineAboutPage'
import { MineDataManagementPage } from './pages/MineDataManagementPage'
import { MineDetailPage } from './pages/MineDetailPage'
import { MineDeviceManagementPage } from './pages/MineDeviceManagementPage'
import { MineHelpPage } from './pages/MineHelpPage'
import { MineHealthSettingsPage } from './pages/MineHealthSettingsPage'
import { MineHomePage } from './pages/MineHomePage'
import { MinePrivacyPage } from './pages/MinePrivacyPage'
import { MineProfilePage } from './pages/MineProfilePage'
import {
  createDefaultMineProfile,
  MineProfile
} from './model/MineProfileModel'
import { PreferencesMineProfileRepository } from
  './repository/PreferencesMineProfileRepository'
import { MineProfileService } from './service/MineProfileService'

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

  // MineRoot 是个人资料的唯一响应式状态所有者；首页和资料页只消费属性与回调。
  @State profileName: string = createDefaultMineProfile().name
  @State profileSignature: string = createDefaultMineProfile().signature

  private profileService: MineProfileService | null = null
  private profileLoadStarted: boolean = false
  // 保存成功后递增；异步加载只能在期间没有保存时覆盖当前状态，避免旧读取结果回写。
  private profileRevision: number = 0

  // Mine 私有导航栈。Navigation 组件会观察栈的 push/pop，无需把它声明成 @State。
  private readonly pathStack: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    if (!this.profileLoadStarted) {
      this.profileLoadStarted = true
      this.loadProfile()
    }
  }

  /** 延迟创建 Mine 私有依赖，Context 和 Preferences 不会泄漏到页面或 Index。 */
  private getProfileService(): MineProfileService {
    if (this.profileService !== null) {
      return this.profileService
    }

    const context = this.getUIContext().getHostContext()
    if (context === undefined) {
      throw new Error('Mine profile host context is unavailable')
    }

    const service = new MineProfileService(
      new PreferencesMineProfileRepository(context)
    )
    this.profileService = service
    return service
  }

  /** 初始化失败时保留界面默认资料；日志不记录昵称或签名。 */
  private async loadProfile(): Promise<void> {
    const revisionAtStart: number = this.profileRevision
    try {
      const profile: MineProfile = await this.getProfileService().loadProfile()
      if (revisionAtStart === this.profileRevision) {
        this.applyProfile(profile)
      }
    } catch {
      console.error('Mine profile load failed')
    }
  }

  /** 只有 Repository 完成写入后才更新响应式状态，失败时首页继续显示旧资料。 */
  private async saveProfile(profile: MineProfile): Promise<MineProfile> {
    const savedProfile: MineProfile = await this.getProfileService().saveProfile(profile)
    this.profileRevision += 1
    this.applyProfile(savedProfile)
    return savedProfile
  }

  private applyProfile(profile: MineProfile): void {
    this.profileName = profile.name
    this.profileSignature = profile.signature
  }

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
    // Navigation 统一以 string 传入目的地名称；路由只由 Mine 自己压栈，因此可转换为内部枚举。
    // param 为未来二级页传递业务参数预留，当前页面全部使用本地静态数据，暂时不读取它。
    NavDestination() {
      // 页面选择规则集中在纯模型中，便于单元测试保护，也避免在这里逐渐堆积路由字符串判断。
      // 七个正常入口均渲染独立页面；最后的分支只处理 NONE 或未知路由。
      if (getMineDestinationKind(name as MineDetailRoute) === MineDestinationKind.ABOUT) {
        MineAboutPage({
          // 具体页面只上报“返回”意图，真正的导航栈仍由 MineRoot 单点管理。
          onBack: () => {
            this.closeDetail()
          }
        })
      } else if (getMineDestinationKind(name as MineDetailRoute) === MineDestinationKind.HELP) {
        MineHelpPage({
          onBack: () => {
            this.closeDetail()
          }
        })
      } else if (getMineDestinationKind(name as MineDetailRoute) === MineDestinationKind.PRIVACY) {
        MinePrivacyPage({
          onBack: () => {
            this.closeDetail()
          }
        })
      } else if (getMineDestinationKind(name as MineDetailRoute) ===
        MineDestinationKind.DEVICE_MANAGEMENT) {
        MineDeviceManagementPage({
          onBack: () => {
            this.closeDetail()
          },
          // 设备管理页和首页设备卡片复用同一跨边界回调，不复制应用级 URL。
          onOpenDeviceDetail: () => {
            this.onOpenDeviceDetail?.()
          }
        })
      } else if (getMineDestinationKind(name as MineDetailRoute) ===
        MineDestinationKind.DATA_MANAGEMENT) {
        MineDataManagementPage({
          onBack: () => {
            this.closeDetail()
          }
        })
      } else if (getMineDestinationKind(name as MineDetailRoute) ===
        MineDestinationKind.HEALTH_SETTINGS) {
        MineHealthSettingsPage({
          onBack: () => {
            this.closeDetail()
          }
        })
      } else if (getMineDestinationKind(name as MineDetailRoute) === MineDestinationKind.PROFILE) {
        MineProfilePage({
          initialProfileName: this.profileName,
          initialProfileSignature: this.profileSignature,
          onSaveProfile: async (profile: MineProfile): Promise<MineProfile> => {
            return this.saveProfile(profile)
          },
          onBack: () => {
            this.closeDetail()
          }
        })
      } else {
        MineDetailPage({
          title: getMineDetailTitle(name as MineDetailRoute),
          onBack: () => {
            this.closeDetail()
          }
        })
      }
    }
    .hideTitleBar(true)
  }

  build() {
    // 花括号中的 MineHomePage 是导航根页面；pushPath 后由 MineDestination 构建二级页。
    Navigation(this.pathStack) {
      MineHomePage({
        profileName: this.profileName,
        profileSignature: this.profileSignature,
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
