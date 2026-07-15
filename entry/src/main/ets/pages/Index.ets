import router from '@ohos.router';
import { TopStatusBar } from '../common/components/TopStatusBar'
import { DeviceStatusBar } from '../common/components/DeviceStatusBar'
import { BluetoothStatus, WifiSignalLevel } from '../common/constants/StatusEnum'

@Entry
@Component
struct Index {
  @State btStatus: BluetoothStatus = BluetoothStatus.CONNECTED
  @State wifiLevel: WifiSignalLevel = WifiSignalLevel.FULL
  @State battery: number = 85

  build() {
    Column() {
      // 顶部状态栏
      TopStatusBar({
        btStatus: this.btStatus,
        wifiLevel: this.wifiLevel,
        batteryLevel: this.battery
      })

      Divider().color('#E8EAED').height(1)

      // 设备连接状态
      DeviceStatusBar({
        btStatus: this.btStatus
      })

      Divider().color('#E8EAED').height(1)

      // 健康管理标题
      Text('健康管理')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .width('100%')
        .padding({ left: 20, top: 24, bottom: 8 })

      // 功能入口区
      Column({ space: 14 }) {
        // 专注模式（主推入口）
        Button('专注模式')
          .width('100%').height(56)
          .fontSize(18).fontWeight(FontWeight.Medium)
          .backgroundColor('#4CAF7D')
          .borderRadius(14)
          .fontColor(Color.White)
          .onClick(() => {
            try {
              router.pushUrl({ url: 'pages/FocusPage' });
            } catch (_e) {
              // ignore
            }
          })

        // 占位：其他功能入口（后续模块开发）
        Button('久坐提醒')
          .width('100%').height(52)
          .fontSize(16)
          .backgroundColor('#F5F7F6')
          .borderRadius(14)
          .fontColor('#999999')
          .onClick(() => {})

        Button('环境监测')
          .width('100%').height(52)
          .fontSize(16)
          .backgroundColor('#F5F7F6')
          .borderRadius(14)
          .fontColor('#999999')
          .onClick(() => {})

        Button('健康报告')
          .width('100%').height(52)
          .fontSize(16)
          .backgroundColor('#F5F7F6')
          .borderRadius(14)
          .fontColor('#999999')
          .onClick(() => {})
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 16 })

      Blank()
    }
    .width('100%').height('100%')
    .backgroundColor('#F8FAF9')
  }
}