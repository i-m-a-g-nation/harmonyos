import { TopStatusBar } from '../common/components/TopStatusBar'
import { DeviceStatusBar } from '../common/components/DeviceStatusBar'
import { BluetoothStatus } from '../common/constants/StatusEnum'
import { WifiSignalLevel } from '../common/constants/StatusEnum'

@Entry
@Component
struct Index {
  // 全局蓝牙状态，同时传给两个组件，状态完全联动
  @State btStatus: BluetoothStatus = BluetoothStatus.CONNECTED
  @State wifiLevel: WifiSignalLevel = WifiSignalLevel.FULL
  @State battery: number = 85

  build() {
    Column() {
      // 第一行：系统状态栏（时间、蓝牙、WiFi、电量）
      TopStatusBar({
        btStatus: this.btStatus,
        wifiLevel: this.wifiLevel,
        batteryLevel: this.battery
      })

      // 第二行：设备连接状态栏（圆点+文字、通知、设置）
      DeviceStatusBar({
        btStatus: this.btStatus,
        // 后续加页面跳转在这里写逻辑
        onDeviceClick: () => {
          // 跳转设备管理页
        },
        onNotifyClick: () => {
          // 跳转通知页
        },
        onSettingClick: () => {
          // 跳转设置页
        }
      })

      // 下面继续放评分卡片、六入口等其他内容
      // ...
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}