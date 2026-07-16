import { MineDeviceCard } from '../components/MineDeviceCard'
import { MineMenuGroupCard } from '../components/MineMenuGroupCard'
import { MineProfileSection } from '../components/MineProfileSection'
import {
  createMineMenuGroups,
  MineDetailRoute,
  MineMenuGroup
} from '../model/MinePageModel'

@Component
export struct MineHomePage {
  onOpenDetail?: (route: MineDetailRoute) => void
  onOpenDeviceDetail?: () => void

  private readonly menuGroups: MineMenuGroup[] = createMineMenuGroups()

  build() {
    Column() {
      Scroll() {
        Column({ space: 14 }) {
          MineProfileSection({
            onOpenProfile: () => {
              this.onOpenDetail?.(MineDetailRoute.PROFILE)
            }
          })

          MineDeviceCard({
            onOpenDeviceDetail: () => {
              this.onOpenDeviceDetail?.()
            }
          })

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
