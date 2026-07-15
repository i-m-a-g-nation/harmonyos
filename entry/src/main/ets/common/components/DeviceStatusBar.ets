import { BluetoothStatus } from '../constants/StatusEnum'

@Component
export struct DeviceStatusBar {
  // 和顶部状态栏共用同一个蓝牙状态，保持联动
  @Prop btStatus: BluetoothStatus = BluetoothStatus.DISCONNECTED

  // 点击事件回调（后续加页面跳转时用）
  onDeviceClick?: () => void
  onNotifyClick?: () => void
  onSettingClick?: () => void

  /**
   * 根据状态返回圆点颜色
   */
  private getDotColor(): ResourceColor {
    switch (this.btStatus) {
      case BluetoothStatus.CONNECTED:
        return '#3A8F7E' // 已连接：主题绿
      case BluetoothStatus.CONNECTING:
        return '#E2A75C' // 连接中：橙色
      default:
        return '#B0B3B8' // 未连接/关闭：灰色
    }
  }

  /**
   * 根据状态返回对应文字
   */
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
      // ========== 左侧：连接状态 ==========
      Row({ space: 10 }) {
        // 状态圆点（纯代码绘制，不用切图）
        Circle({ width: 10, height: 10 })
          .fill(this.getDotColor())
          // 连接中加呼吸动画
          .opacity(this.btStatus === BluetoothStatus.CONNECTING ? 0.4 : 1)
          .animation({
            duration: 1000,
            iterations: -1,
            curve: Curve.EaseInOut
          })

        // 状态文字
        Text(this.getStatusText())
          .fontSize(16)
          .fontColor('#1A1A1A')
          .fontWeight(FontWeight.Medium)
      }
      .onClick(() => {
        this.onDeviceClick?.()
      })

      Blank()

      // ========== 右侧：通知 + 设置图标 ==========
      Row({ space: 20 }) {
        // 通知图标
        Image($r('app.media.message'))
          .width(22)
          .height(22)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.onNotifyClick?.()
          })

        // 设置图标
        Image($r('app.media.setting'))
          .width(22)
          .height(22)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.onSettingClick?.()
          })
      }
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 8, bottom: 12 })
  }
}