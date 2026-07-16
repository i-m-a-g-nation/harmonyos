import {
  MineDetailRoute,
  MineMenuGroup,
  MineMenuIconKey,
  MineMenuItem
} from '../model/MinePageModel'

@Component
export struct MineMenuGroupCard {
  @Prop group: MineMenuGroup = { items: [] }
  onOpenDetail?: (route: MineDetailRoute) => void

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
      ForEach(this.group.items, (item: MineMenuItem, index: number) => {
        this.MenuRow(item)

        if (index < this.group.items.length - 1) {
          Divider()
            .strokeWidth(0.6)
            .color('#E8EAEB')
            .margin({ left: 50 })
        }
      }, (item: MineMenuItem) => item.route)
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
      this.onOpenDetail?.(item.route)
    })
  }
}
