import { MineSecondaryTitleBar } from '../components/MineSecondaryTitleBar'
import {
  createMineManagedDevices,
  MineManagedDevice
} from '../model/MineDeviceManagementModel'

/**
 * Mine 内部的设备管理页。
 * 页面通过回调请求打开既有设备详情，因而不知道 `pages/Setting` 或应用级 router。
 */
@Component
export struct MineDeviceManagementPage {
  onBack?: () => void
  onOpenDeviceDetail?: () => void

  @State autoSync: boolean = true
  @State connectionAlerts: boolean = true
  @State actionHint: string = ''

  private readonly devices: MineManagedDevice[] = createMineManagedDevices()

  build() {
    Column() {
      MineSecondaryTitleBar({
        title: '设备管理',
        onBack: () => {
          this.onBack?.()
        }
      })

      Scroll() {
        Column({ space: 16 }) {
          ForEach(this.devices, (device: MineManagedDevice) => {
            Column({ space: 16 }) {
              Row({ space: 16 }) {
                Image($r('app.media.mine_terminal'))
                  .width(62)
                  .height(102)
                  .objectFit(ImageFit.Contain)

                Column({ space: 9 }) {
                  Row({ space: 8 }) {
                    Text(device.name)
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#252729')
                      .layoutWeight(1)
                      .maxLines(1)

                    Text(device.connected ? '已连接' : '未连接')
                      .fontSize(12)
                      .fontColor(device.connected ? '#2E7D6F' : '#8A8D91')
                      .padding({ left: 9, right: 9, top: 4, bottom: 4 })
                      .backgroundColor(device.connected ? '#EEF6F2' : '#F0F1F2')
                      .borderRadius(12)
                  }
                  .width('100%')

                  this.DeviceInfoRow('电量', `${device.batteryLevel}%`)
                  this.DeviceInfoRow('固件', device.firmwareVersion)
                  this.DeviceInfoRow('同步', device.lastSync)
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')

              Button('查看设备详情', { type: ButtonType.Capsule })
                .width('100%')
                .height(42)
                .fontSize(15)
                .fontColor('#FFFFFF')
                .backgroundColor('#2E7D6F')
                .onClick(() => {
                  this.onOpenDeviceDetail?.()
                })
            }
            .width('100%')
            .padding(20)
            .backgroundColor('#FFFFFF')
            .borderRadius(18)
            .shadow({ radius: 16, color: 'rgba(0, 0, 0, 0.035)', offsetY: 3 })
          }, (device: MineManagedDevice): string => device.id)

          Column({ space: 0 }) {
            Text('连接设置')
              .width('100%')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#252729')
              .margin({ bottom: 8 })

            this.SettingRow('自动同步', '连接设备后自动更新演示数据', this.autoSync, true)
            Divider().strokeWidth(0.6).color('#E8EAEB')
            this.SettingRow('连接提醒', '设备连接状态变化时显示提醒', this.connectionAlerts, false)
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(18)
          .shadow({ radius: 16, color: 'rgba(0, 0, 0, 0.035)', offsetY: 3 })

          Button('添加设备', { type: ButtonType.Capsule })
            .width('100%')
            .height(44)
            .fontSize(16)
            .fontColor('#2E7D6F')
            .backgroundColor('#EAF3F0')
            .onClick(() => {
              this.actionHint = '设备配对功能尚未接入'
            })

          if (this.actionHint.length > 0) {
            Text(this.actionHint)
              .width('100%')
              .fontSize(13)
              .fontColor('#777A7E')
              .textAlign(TextAlign.Center)
          }
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 12, bottom: 24 })
      }
      .layoutWeight(1)
      .width('100%')
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }

  @Builder
  DeviceInfoRow(label: string, value: string) {
    Row() {
      Text(label).width(46).fontSize(13).fontColor('#8A8D91')
      Text(value).fontSize(13).fontColor('#5F6266')
    }
  }

  @Builder
  SettingRow(title: string, description: string, enabled: boolean, isAutoSync: boolean) {
    Row({ space: 12 }) {
      Column({ space: 5 }) {
        Text(title).fontSize(15).fontWeight(FontWeight.Medium).fontColor('#252729')
        Text(description).fontSize(13).fontColor('#8A8D91')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Toggle({ type: ToggleType.Switch, isOn: enabled })
        .selectedColor('#2E7D6F')
        .switchPointColor(Color.White)
        .onChange((isOn: boolean) => {
          if (isAutoSync) {
            this.autoSync = isOn
          } else {
            this.connectionAlerts = isOn
          }
          this.actionHint = '设置仅在当前页面生效，尚未保存'
        })
    }
    .width('100%')
    .padding({ top: 12, bottom: 12 })
    .alignItems(VerticalAlign.Center)
  }
}
