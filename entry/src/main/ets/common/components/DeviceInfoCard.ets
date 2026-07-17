@Component
export struct DeviceInfoCard {
  deviceName: string = '办公健康终端 Pro'
  isConnected: boolean = true
  batteryPercent: number = 78
  firmwareVersion: string = '1.2.3'
  syncTime: string = '今天 09:30'

  build() {
    Row({ space: 16 }) {
      // 左侧：设备主图，尺寸压低一些
      Image($r('app.media.device_pro'))
        .width(100)
        .height(100)
        .objectFit(ImageFit.Contain)

      // 右侧：信息列表
      Column({ space: 14 }) {
        // 设备名称 + 连接状态
        Column({ space: 6 }) {
          Text(this.deviceName)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')

          Row({ space: 8 }) {
            Circle({ width: 10, height: 10 })
              .fill(this.isConnected ? '#3A8F7E' : '#B0B3B8')
            Text(this.isConnected ? '已连接' : '未连接')
              .fontSize(15)
              .fontColor(this.isConnected ? '#3A8F7E' : '#999999')
          }
        }
        .alignItems(HorizontalAlign.Start)

        Divider()
          .color('#F0F0F0')

        // 电量行
        Row() {
          // 左侧图标+文字
          Row({ space: 10 }) {
            Image($r('app.media.ic_battery'))
              .width(18)
              .height(18)
              .objectFit(ImageFit.Contain)
            Text('电量')
              .fontSize(15)
              .fontColor('#666666')
          }
          .layoutWeight(1)

          // 右侧电量数值 + 进度条
          Row({ space: 10 }) {
            Text(`${this.batteryPercent}%`)
              .fontSize(15)
              .fontColor('#1A1A1A')

            Row() {
              Row()
                .width(`${this.batteryPercent}%`)
                .height('100%')
                .backgroundColor('#52C41A')
                .borderRadius(6)
            }
            .width(72)
            .height(14)
            .backgroundColor('#F0F0F0')
            .borderRadius(7)
          }
        }
        .width('100%')

        Divider()
          .color('#F0F0F0')

        // 固件版本行
        Row() {
          Row({ space: 10 }) {
            Image($r('app.media.ic_chip'))
              .width(18)
              .height(18)
              .objectFit(ImageFit.Contain)
            Text('固件版本')
              .fontSize(15)
              .fontColor('#666666')
          }
          .layoutWeight(1)

          Text(this.firmwareVersion)
            .fontSize(15)
            .fontColor('#1A1A1A')
        }
        .width('100%')

        Divider()
          .color('#F0F0F0')

        // 同步时间行
        Row() {
          Row({ space: 10 }) {
            Image($r('app.media.ic_sync'))
              .width(18)
              .height(18)
              .objectFit(ImageFit.Contain)
            Text('同步时间')
              .fontSize(15)
              .fontColor('#666666')
          }
          .layoutWeight(1)

          Text(this.syncTime)
            .fontSize(15)
            .fontColor('#1A1A1A')
        }
        .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }
}