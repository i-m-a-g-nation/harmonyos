import { TopStatusBar } from '../common/components/TopStatusBar'
import { DeviceStatusBar } from '../common/components/DeviceStatusBar'
import { HealthScoreCard } from '../common/components/HealthScoreCard'
import { MetricCard } from '../common/components/MetricCard'
import { SmartAdviceCard } from '../common/components/SmartAdviceCard'
import { TodayTargetCard } from '../common/components/TodayTargetCard'
import { BottomTabBar } from '../common/components/BottomTabBar'
import { BluetoothStatus } from '../common/constants/StatusEnum'
import { WifiSignalLevel } from '../common/constants/StatusEnum'
import { router } from '@kit.ArkUI';
import { MineRoot } from '../features/mine/MineRoot'

/**
 * 应用主壳层：负责四个 Tab、底部导航和跨功能的应用级跳转。
 *
 * 维护边界：Index 只接入各功能的根组件，不应该了解 MineDetailRoute 等功能内部路由。
 * Mine 后续新增普通二级页时，优先只修改 features/mine，不要继续扩大本文件职责。
 */
@Entry
@Component
struct Index {
  // 首页演示状态；当前仍是静态数据，未来接入真实数据源时再抽到 ViewModel/Repository。
  @State btStatus: BluetoothStatus = BluetoothStatus.CONNECTED
  @State wifiLevel: WifiSignalLevel = WifiSignalLevel.FULL
  @State battery: number = 85
  @State healthScore: number = 86
  // 当前选中的Tab索引，和底部导航、Tabs双向绑定
  @State currentTab: number = 0
  // 当前功能内部导航深度：0 表示功能首页；大于 0 表示二级页。
  // 壳层只依赖“深度”，不依赖 Mine 的具体路由，从而保持功能解耦。
  @State activeFeatureDepth: number = 0

  /**
   * 应用级设备详情入口。
   * 首页设置按钮和 Mine 设备卡片都复用这个方法，避免子组件直接依赖页面 URL。
   */
  private openDeviceDetail(): void {
    console.info('===== 开始执行设备详情跳转 =====')
    try {
      router.pushUrl({
        url: 'pages/Setting'
      })
      console.info('设备详情跳转指令已发出')
    } catch (err) {
      console.error('设备详情跳转失败：', JSON.stringify(err))
    }
  }

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
                btStatus: this.btStatus,
                onDeviceClick: () => {
                  console.info('点击设备连接栏')
                },
                onNotifyClick: () => {
                  console.info('点击消息铃铛')
                },
                // 设置按钮跳转逻辑
                onSettingClick: () => {
                  this.openDeviceDetail()
                }
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
          // MineRoot 是“我的”功能唯一对外入口。
          // 第一个回调同步壳层显示状态；第二个回调请求应用打开独立设备详情页。
          MineRoot({
            onNavigationDepthChange: (depth: number) => {
              this.activeFeatureDepth = depth
            },
            onOpenDeviceDetail: () => {
              this.openDeviceDetail()
            }
          })
        }
      }
      .barHeight(0) // 隐藏系统默认Tab栏，完全用自定义的底部导航
      .onChange((index: number) => {
        // 左右滑动页面时，同步更新底部导航的选中状态
        this.currentTab = index
      })
      // 二级页中禁止横向滑动切换 Tab，防止手势与返回导航冲突。
      .scrollable(this.activeFeatureDepth === 0)
      .layoutWeight(1)

      // 底部固定导航栏
      // Mine 内部二级页出现时隐藏底栏；回到功能根页面后自动恢复。
      if (this.activeFeatureDepth === 0) {
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
