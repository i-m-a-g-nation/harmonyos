import { TopStatusBar } from '../common/components/TopStatusBar'
import { DeviceStatusBar } from '../common/components/DeviceStatusBar'
import { HealthScoreCard } from '../common/components/HealthScoreCard'
import { BluetoothStatus } from '../common/constants/StatusEnum'
import { WifiSignalLevel } from '../common/constants/StatusEnum'

@Entry
@Component
struct Index {
  @State btStatus: BluetoothStatus = BluetoothStatus.CONNECTED
  @State wifiLevel: WifiSignalLevel = WifiSignalLevel.FULL
  @State battery: number = 85
  // 健康评分，后续对接真实数据直接改这个变量
  @State healthScore: number = 86

  build() {
    Column() {
      // 第一行：系统状态栏
      TopStatusBar({
        btStatus: this.btStatus,
        wifiLevel: this.wifiLevel,
        batteryLevel: this.battery
      })

      // 第二行：设备连接状态+通知设置
      DeviceStatusBar({
        btStatus: this.btStatus
      })

      // 第三行：健康评分卡片
      HealthScoreCard({
        score: this.healthScore
      })
        .margin({ left: 20, right: 20, top: 8 })

      // 后续继续放三指标卡片、六入口等
      // ...
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}