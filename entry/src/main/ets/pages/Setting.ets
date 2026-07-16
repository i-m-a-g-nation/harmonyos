import { router } from '@kit.ArkUI';
import { TopStatusBar } from '../common/components/TopStatusBar'
import { BluetoothStatus } from '../common/constants/StatusEnum'
import { WifiSignalLevel } from '../common/constants/StatusEnum'

@Entry
@Component
struct DeviceDetail {
  // 必须声明这三个状态，给TopStatusBar传参
  @Prop btStatus: BluetoothStatus = BluetoothStatus.CONNECTED
  @Prop wifiLevel: WifiSignalLevel = WifiSignalLevel.FULL
  @Prop batteryLevel: number = 78

  build() {
    Column() {
      // 1. 系统状态栏（时间+蓝牙+WiFi+电池，和首页顶部完全一致）
      TopStatusBar({
        btStatus: this.btStatus,
        wifiLevel: this.wifiLevel,
        batteryLevel: this.batteryLevel
      })

      // 2. 页面自定义导航栏（返回箭头 + 标题 + 更多）
      Row() {
        Text('<')
          .fontSize(26)
          .onClick(()=>router.back())
        Text('设备详情')
          .fontSize(24)
          .fontWeight(FontWeight.Medium)
        Blank()
        Text('...')
          .fontSize(26)
      }
      .width('100%')
      .padding({left:20, right:20, top:8, bottom:16})

      // 下面放页面卡片、列表内容...
      Blank()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}