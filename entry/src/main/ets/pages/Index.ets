import { TopStatusBar } from '../common/components/TopStatusBar'
import { DeviceStatusBar } from '../common/components/DeviceStatusBar'
import { HealthScoreCard } from '../common/components/HealthScoreCard'
import { MetricCard } from '../common/components/MetricCard'
import { SmartAdviceCard } from '../common/components/SmartAdviceCard'
import { TodayTargetCard } from '../common/components/TodayTargetCard'
import { BottomTabBar } from '../common/components/BottomTabBar'
import { BluetoothStatus } from '../common/constants/StatusEnum'
import { WifiSignalLevel } from '../common/constants/StatusEnum'
import { Mine } from './Mine'
import { MineDetailRoute } from './mine/MinePageModel'

@Entry
@Component
struct Index {
  @State btStatus: BluetoothStatus = BluetoothStatus.CONNECTED
  @State wifiLevel: WifiSignalLevel = WifiSignalLevel.FULL
  @State battery: number = 85
  @State healthScore: number = 86
  // 当前选中的Tab索引，和底部导航、Tabs双向绑定
  @State currentTab: number = 0
  @State isMineDetailVisible: boolean = false

  build() {
    Column() {
      // 页面容器：占满剩余空间，支持左右滑动切换
      Tabs({ index: this.currentTab }) {
        // ========== Tab 0：首页 ==========
        TabContent() {
          Scroll() {
            Column() {
              // 1. 系统状态栏
              /* TopStatusBar({
                btStatus: this.btStatus,
                wifiLevel: this.wifiLevel,
                batteryLevel: this.battery
              })
              */

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
                  console.info('点击去查看')
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
          .width('100%')
          .height('100%')
        }

        // ========== Tab 1：洞察 ==========
        TabContent() {
          Column() {
            Text('洞察页面')
              .fontSize(20)
              .fontColor('#999999')
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#F7F8FA')
        }

        // ========== Tab 2：专注 ==========
        TabContent() {
          Column() {
            Text('专注页面')
              .fontSize(20)
              .fontColor('#999999')
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#F7F8FA')
        }

        // ========== Tab 3：我的 ==========
        TabContent() {
          Mine({
            btStatus: this.btStatus,
            wifiLevel: this.wifiLevel,
            batteryLevel: this.battery,
            onDetailRouteChange: (route: MineDetailRoute) => {
              this.isMineDetailVisible = route !== MineDetailRoute.NONE
            }
          })
        }
      }
      .barHeight(0) // 隐藏系统默认Tab栏，完全用自定义的底部导航
      .onChange((index: number) => {
        // 左右滑动页面时，同步更新底部导航的选中状态
        this.currentTab = index
      })
      .scrollable(!this.isMineDetailVisible)
      .layoutWeight(1)

      // 底部固定导航栏
      if (!this.isMineDetailVisible) {
        BottomTabBar({
          currentIndex: $currentTab,
          onTabChange: (index: number) => {
            // 点击底部Tab时，切换到对应页面
            this.currentTab = index
          }
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}
