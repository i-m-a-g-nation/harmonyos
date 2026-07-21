import { MineDeviceCard } from '../components/MineDeviceCard'
import { MineMenuGroupCard } from '../components/MineMenuGroupCard'
import { MineProfileSection } from '../components/MineProfileSection'
import {
  createMineMenuGroups,
  MineDetailRoute,
  MineMenuGroup
} from '../model/MinePageModel'

/**
 * Mine 首页组合层：只决定私有组件的排列和事件转发，不直接执行应用级导航。
 * 数据通过属性向下传递，点击事件通过回调向上交给 MineRoot。
 */
@Component
export struct MineHomePage {
  // MineRoot 持有真实状态；@Prop 保证保存成功后首页摘要随父状态刷新。
  @Prop profileName: string = '张小悦'
  @Prop profileSignature: string = '健康办公，高效生活'
  // 个人资料和菜单入口使用 Mine 内部 Navigation。
  onOpenDetail?: (route: MineDetailRoute) => void
  // 设备卡片打开的是应用级独立页面，因此单独向根组件上报。
  onOpenDeviceDetail?: () => void

  // 菜单定义集中在 model，页面不重复维护标题、图标键和路由字符串。
  private readonly menuGroups: MineMenuGroup[] = createMineMenuGroups()

  build() {
    Column() {
      Scroll() {
        Column({ space: 14 }) {
          // 个人资料区：点击后进入 Mine 内部个人资料目的地。
          MineProfileSection({
            profileName: this.profileName,
            profileSignature: this.profileSignature,
            onOpenProfile: () => {
              this.onOpenDetail?.(MineDetailRoute.PROFILE)
            }
          })

          // 设备卡片：整卡点击，通过回调链请求 Index 打开 pages/Setting。
          MineDeviceCard({
            onOpenDeviceDetail: () => {
              this.onOpenDeviceDetail?.()
            }
          })

          // model 返回两个菜单分组；每一行只把对应 MineDetailRoute 上报给根组件。
          ForEach(this.menuGroups, (group: MineMenuGroup) => {
            MineMenuGroupCard({
              group: group,
              onOpenDetail: (route: MineDetailRoute) => {
                this.onOpenDetail?.(route)
              }
            })
          })

          Blank().height(8)
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 12 })
      }
      .layoutWeight(1)
      .width('100%')
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}
