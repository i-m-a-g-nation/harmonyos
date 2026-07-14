import { TopStatusBar } from '../common/components/TopStatusBar'
import { DeviceStatusBar } from '../common/components/DeviceStatusBar'
import { HealthScoreCard } from '../common/components/HealthScoreCard'
import { MetricCard } from '../common/components/MetricCard'
import { BluetoothStatus } from '../common/constants/StatusEnum'
import { WifiSignalLevel } from '../common/constants/StatusEnum'

@Entry
@Component
struct Index {
  @State btStatus: BluetoothStatus = BluetoothStatus.CONNECTED
  @State wifiLevel: WifiSignalLevel = WifiSignalLevel.FULL
  @State battery: number = 85
  @State healthScore: number = 86

  build() {
    Column() {
      // 1. 系统状态栏
      TopStatusBar({
        btStatus: this.btStatus,
        wifiLevel: this.wifiLevel,
        batteryLevel: this.battery
      })

      // 2. 设备连接状态栏
      DeviceStatusBar({
        btStatus: this.btStatus
      })

      // 3. 健康评分卡片
      HealthScoreCard({
        score: this.healthScore
      })
        .margin({ left: 20, right: 20, top: 8 })

      // ========== 新增：三指标卡片行 ==========
      Row({ space: 12 }) {
        // 久坐卡片：拆分数字和单位
        MetricCard({
          title: '久坐',
          value: '4',
          unit: '小时',
          secondValue: '12',
          secondUnit: '分',
          iconResource: $r('app.media.sit')
        })
          .layoutWeight(1)

        // 环境卡片：保持原样
        MetricCard({
          title: '环境',
          value: '420',
          unit: 'ppm',
          iconResource: $r('app.media.env')
        })
          .layoutWeight(1)

        // 专注卡片：保持原样
        MetricCard({
          title: '专注',
          value: '150',
          unit: '分钟',
          iconResource: $r('app.media.serious')
        })
          .layoutWeight(1)
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 12 })

      // 后续继续放智能建议、今日目标等卡片
      // ...
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}