@Component
export struct MineDeviceCard {
  onOpenDeviceDetail?: () => void

  build() {
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
    .onClick(() => {
      this.onOpenDeviceDetail?.()
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
}
