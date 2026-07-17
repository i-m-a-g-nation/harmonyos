import { TopStatusBar } from '../common/components/TopStatusBar'
import { BluetoothStatus, WifiSignalLevel } from '../common/constants/StatusEnum'
import {
  createMineMenuGroups,
  getMineDetailTitle,
  MineDetailRoute,
  MineMenuGroup,
  MineMenuIconKey,
  MineMenuItem
} from './mine/MinePageModel'

@Component
export struct Mine {
  @Prop btStatus: BluetoothStatus = BluetoothStatus.CONNECTED
  @Prop wifiLevel: WifiSignalLevel = WifiSignalLevel.FULL
  @Prop batteryLevel: number = 85
  onDetailRouteChange?: (route: MineDetailRoute) => void

  @State activeRoute: MineDetailRoute = MineDetailRoute.NONE

  private readonly menuGroups: MineMenuGroup[] = createMineMenuGroups()

  private openDetail(route: MineDetailRoute): void {
    this.activeRoute = route
    this.onDetailRouteChange?.(route)
  }

  private closeDetail(): void {
    this.activeRoute = MineDetailRoute.NONE
    this.onDetailRouteChange?.(MineDetailRoute.NONE)
  }

  private getMenuIcon(iconKey: MineMenuIconKey): Resource {
    switch (iconKey) {
      case MineMenuIconKey.HEALTH_SETTINGS:
        return $r('app.media.mine_health_settings')
      case MineMenuIconKey.DATA_MANAGEMENT:
        return $r('app.media.mine_data_management')
      case MineMenuIconKey.DEVICE_MANAGEMENT:
        return $r('app.media.mine_device_management')
      case MineMenuIconKey.PRIVACY:
        return $r('app.media.mine_privacy')
      case MineMenuIconKey.HELP:
        return $r('app.media.mine_help')
      case MineMenuIconKey.ABOUT:
        return $r('app.media.mine_about')
      default:
        return $r('app.media.mine_about')
    }
  }

  build() {
    Column() {
      if (this.activeRoute === MineDetailRoute.NONE) {
        this.MineHome()
      } else {
        this.DetailPage()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }

  @Builder
  MineHome() {
    Column() {
      /*
      TopStatusBar({
        btStatus: this.btStatus,
        wifiLevel: this.wifiLevel,
        batteryLevel: this.batteryLevel
      })
      */

      Scroll() {
        Column({ space: 14 }) {
          this.ProfileSection()
          this.DeviceCard()

          ForEach(this.menuGroups, (group: MineMenuGroup) => {
            this.MenuGroupCard(group)
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

  @Builder
  DetailPage() {
    Column() {
      /*
      TopStatusBar({
        btStatus: this.btStatus,
        wifiLevel: this.wifiLevel,
        batteryLevel: this.batteryLevel
      })
      */

      Row() {
        Row() {
          Image($r('app.media.mine_chevron_right'))
            .width(22)
            .height(22)
            .objectFit(ImageFit.Contain)
            .rotate({ angle: 180 })
        }
        .width(48)
        .height(48)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.closeDetail()
        })

        Text(getMineDetailTitle(this.activeRoute))
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
          .textAlign(TextAlign.Center)
          .layoutWeight(1)

        Blank()
          .width(48)
      }
      .width('100%')
      .height(52)
      .padding({ left: 8, right: 8 })
      .alignItems(VerticalAlign.Center)

      Blank()
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }

  @Builder
  ProfileSection() {
    Row({ space: 18 }) {
      Image($r('app.media.mine_avatar'))
        .width(64)
        .height(64)
        .borderRadius(32)
        .objectFit(ImageFit.Cover)

      Column({ space: 7 }) {
        Text('张小悦')
          .fontSize(23)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')

        Text('健康办公，高效生活')
          .fontSize(14)
          .fontColor('#5F6266')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Image($r('app.media.mine_chevron_right'))
        .width(22)
        .height(22)
        .objectFit(ImageFit.Contain)
    }
    .width('100%')
    .padding({ top: 8, bottom: 6 })
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.openDetail(MineDetailRoute.PROFILE)
    })
  }

  @Builder
  DeviceCard() {
    Row({ space: 16 }) {
      Image($r('app.media.mine_terminal'))
        .width(68)
        .height(112)
        .objectFit(ImageFit.Contain)

      Column({ space: 12 }) {
        Row({ space: 8 }) {
          Text('办公健康终端 Pro')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1A1A1A')
            .layoutWeight(1)
            .maxLines(1)

          Text('已连接')
            .fontSize(12)
            .fontColor('#2E7D6F')
            .padding({ left: 10, right: 10, top: 5, bottom: 5 })
            .backgroundColor('#EEF6F2')
            .borderRadius(12)
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        Row({ space: 10 }) {
          Text('电量')
            .width(62)
            .fontSize(14)
            .fontColor('#777A7E')

          Text('78%')
            .fontSize(14)
            .fontColor('#777A7E')

          Image($r('app.media.mine_device_battery'))
            .width(24)
            .height(18)
            .objectFit(ImageFit.Contain)
        }
        .alignItems(VerticalAlign.Center)

        this.DeviceInfoRow('固件版本', '1.2.3')
        this.DeviceInfoRow('同步时间', '今天 09:30')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding({ left: 18, right: 18, top: 14, bottom: 14 })
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .shadow({
      radius: 18,
      color: 'rgba(0, 0, 0, 0.045)',
      offsetY: 4
    })
  }

  @Builder
  DeviceInfoRow(label: string, value: string) {
    Row({ space: 10 }) {
      Text(label)
        .width(62)
        .fontSize(14)
        .fontColor('#777A7E')

      Text(value)
        .fontSize(14)
        .fontColor('#777A7E')
    }
  }

  @Builder
  MenuGroupCard(group: MineMenuGroup) {
    Column() {
      ForEach(group.items, (item: MineMenuItem, index: number) => {
        this.MenuRow(item)

        if (index < group.items.length - 1) {
          Divider()
            .strokeWidth(0.6)
            .color('#E8EAEB')
            .margin({ left: 50 })
        }
      })
    }
    .width('100%')
    .padding({ left: 18, right: 14 })
    .backgroundColor('#FFFFFF')
    .borderRadius(18)
    .shadow({
      radius: 16,
      color: 'rgba(0, 0, 0, 0.035)',
      offsetY: 3
    })
  }

  @Builder
  MenuRow(item: MineMenuItem) {
    Row({ space: 16 }) {
      Image(this.getMenuIcon(item.iconKey))
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)

      Text(item.label)
        .fontSize(17)
        .fontColor('#252729')
        .layoutWeight(1)

      Image($r('app.media.mine_chevron_right'))
        .width(20)
        .height(20)
        .objectFit(ImageFit.Contain)
    }
    .width('100%')
    .height(53)
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.openDetail(item.route)
    })
  }
}
