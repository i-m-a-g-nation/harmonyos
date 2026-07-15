import { TopStatusBar } from '../common/components/TopStatusBar'
import { DeviceStatusBar } from '../common/components/DeviceStatusBar'
import { HealthScoreCard } from '../common/components/HealthScoreCard'
import { MetricCard } from '../common/components/MetricCard'
import { SmartAdviceCard } from '../common/components/SmartAdviceCard'
import { TodayTargetCard } from '../common/components/TodayTargetCard'
import { BottomTabBar } from '../common/components/BottomTabBar'
import { BluetoothStatus } from '../common/constants/StatusEnum'
import { WifiSignalLevel } from '../common/constants/StatusEnum'

@Entry
@Component
struct Index {
  @State btStatus: BluetoothStatus = BluetoothStatus.CONNECTED
  @State wifiLevel: WifiSignalLevel = WifiSignalLevel.FULL
  @State battery: number = 85
  @State healthScore: number = 86
  // 新增：底部导航当前选中索引
  @State currentTab: number = 0

  build() {
    Column() {
      // ========== 上方可滚动内容区 ==========
      Scroll() {
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

          // 4. 三指标卡片行
          Row({ space: 12 }) {
            MetricCard({
              title: '久坐',
              value: '4',
              unit: '小时',
              secondValue: '12',
              secondUnit: '分',
              iconResource: $r('app.media.sit')
            })
              .layoutWeight(1)

            MetricCard({
              title: '环境',
              value: '420',
              unit: 'ppm',
              iconResource: $r('app.media.env')
            })
              .layoutWeight(1)

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

          // 5. 智能建议卡片
          SmartAdviceCard({
            adviceText: '上午久坐偏多，建议下午每45分钟起身活动',
            onViewClick: () => {
              // 后续加跳转逻辑
            }
          })
            .margin({ left: 20, right: 20, top: 12 })

          // 6. 今日目标卡片
          TodayTargetCard({
            finishedCount: 3,
            totalCount: 3
          })
            .margin({ left: 20, right: 20, top: 12 })
        }
        .width('100%')
      }
      .layoutWeight(1) // 核心：占满剩余空间，把底部Tab顶到最下面

      // ========== 底部固定导航栏 ==========
      BottomTabBar({
        currentIndex: $currentTab,
        onTabChange: (index: number) => {
          // 后续可在这里处理页面切换逻辑
          console.info('切换到Tab：' + index)
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}