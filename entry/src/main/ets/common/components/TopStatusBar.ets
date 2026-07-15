import { BluetoothStatus } from '../constants/StatusEnum'
import { WifiSignalLevel } from '../constants/StatusEnum'
import { BluetoothStatusIcon } from './BluetoothStatusIcon'
import { WifiSignalIcon } from './WifiSignalIcon'
import { BatteryIcon } from './BatteryIcon'

@Component
export struct TopStatusBar {
  // 对外状态参数
  @Prop btStatus: BluetoothStatus = BluetoothStatus.CONNECTED
  @Prop wifiLevel: WifiSignalLevel = WifiSignalLevel.FULL
  @Prop batteryLevel: number = 85

  // 内部维护的真实时间
  @State private currentTime: string = ''
  // 定时器ID，用于销毁时清除
  private timerId: number = -1

  /**
   * 获取并格式化当前时间：时:分
   * 分钟自动补零，小时不补零，和系统状态栏样式一致
   */
  private updateTime(): void {
    const now = new Date()
    const hour = now.getHours()
    const minute = now.getMinutes().toString().padStart(2, '0')
    this.currentTime = `${hour}:${minute}`
  }

  aboutToAppear(): void {
    // 进入页面立即刷新一次时间，避免空白
    this.updateTime()
    // 每分钟更新一次，兼顾准确和功耗
    this.timerId = setInterval(() => {
      this.updateTime()
    }, 60 * 1000)
  }

  aboutToDisappear(): void {
    // 页面销毁时清除定时器，防止内存泄漏
    if (this.timerId !== -1) {
      clearInterval(this.timerId)
      this.timerId = -1
    }
  }

  build() {
    Row() {
      // 左侧：真实系统时间
      Text(this.currentTime)
        .fontSize(15)
        .fontColor('#1A1A1A')
        .fontWeight(FontWeight.Medium)

      Blank()

      // 右侧：状态图标组
      Row({ space: 12 }) {
        BluetoothStatusIcon({
          status: this.btStatus,
          iconSize: 15
        })

        WifiSignalIcon({
          level: this.wifiLevel,
          iconSize: 15
        })

        BatteryIcon({
          batteryLevel: this.batteryLevel,
          iconSize: 19
        })
      }
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 12, bottom: 8 })
  }
}