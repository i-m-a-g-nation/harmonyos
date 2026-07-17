import { BluetoothStatus } from '../constants/StatusEnum'

@Component
export struct DeviceStatusBar {
  @Prop btStatus: BluetoothStatus = BluetoothStatus.DISCONNECTED

  // 点击回调
  onDeviceClick?: () => void
  onNotifyClick?: () => void
  onSettingClick?: () => void

  // 按压状态，分别控制两个图标动效
  @State notifyPressed: boolean = false
  @State settingPressed: boolean = false

  private getDotColor(): ResourceColor {
    switch (this.btStatus) {
      case BluetoothStatus.CONNECTED:
        return '#3A8F7E'
      case BluetoothStatus.CONNECTING:
        return '#E2A75C'
      default:
        return '#B0B3B8'
    }
  }

  private getStatusText(): string {
    switch (this.btStatus) {
      case BluetoothStatus.CONNECTED:
        return '工位终端已连接'
      case BluetoothStatus.CONNECTING:
        return '连接中...'
      case BluetoothStatus.OFF:
        return '蓝牙未开启'
      default:
        return '设备未连接'
    }
  }

  build() {
    Row() {
      // 左侧设备状态区域
      Row({ space: 10 }) {
        Circle({ width: 10, height: 10 })
          .fill(this.getDotColor())
          .opacity(this.btStatus === BluetoothStatus.CONNECTING ? 0.4 : 1)
          .animation({
            duration: 1000,
            iterations: -1,
            curve: Curve.EaseInOut
          })

        Text(this.getStatusText())
          .fontSize(16)
          .fontColor('#1A1A1A')
          .fontWeight(FontWeight.Medium)
      }
      .onClick(() => {
        this.onDeviceClick?.()
      })

      Blank()

      // 右侧通知、设置图标
      Row({ space: 20 }) {
        // 通知铃铛
        Image($r('app.media.message'))
          .width(22)
          .height(22)
          .objectFit(ImageFit.Contain)
          .scale({
            x: this.notifyPressed ? 0.9 : 1,
            y: this.notifyPressed ? 0.9 : 1
          })
          .animation({ duration: 120, curve: Curve.EaseInOut })
          .onTouch((e: TouchEvent) => {
            if (e.type === TouchType.Down) this.notifyPressed = true
            else this.notifyPressed = false
          })
          .onClick(() => {
            this.onNotifyClick?.()
          })

        // 设置图标
        Image($r('app.media.setting'))
          .width(22)
          .height(22)
          .objectFit(ImageFit.Contain)
          .scale({
            x: this.settingPressed ? 0.9 : 1,
            y: this.settingPressed ? 0.9 : 1
          })
          .animation({ duration: 120, curve: Curve.EaseInOut })
          .onTouch((e: TouchEvent) => {
            if (e.type === TouchType.Down) this.settingPressed = true
            else this.settingPressed = false
          })
          .onClick(() => {
            this.onSettingClick?.()
          })
      }
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 8, bottom: 12 })
  }
}