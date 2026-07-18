import { MineSecondaryTitleBar } from '../components/MineSecondaryTitleBar'
import {
  createMineDataSummaryItems,
  MineDataSummaryItem
} from '../model/MineDataManagementModel'

/**
 * “数据管理”独立二级页。
 * 当前没有 Repository 或云端接口，所有摘要和操作都明确标识为本地演示行为。
 */
@Component
export struct MineDataManagementPage {
  onBack?: () => void

  @State wifiOnly: boolean = true
  @State autoBackup: boolean = false
  @State actionHint: string = ''

  private readonly summaryItems: MineDataSummaryItem[] = createMineDataSummaryItems()

  build() {
    Column() {
      MineSecondaryTitleBar({
        title: '数据管理',
        onBack: () => {
          this.onBack?.()
        }
      })

      Scroll() {
        Column({ space: 16 }) {
          Column({ space: 0 }) {
            Text('数据概览')
              .width('100%')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#252729')
              .margin({ bottom: 8 })

            ForEach(this.summaryItems, (item: MineDataSummaryItem, index: number) => {
              Row() {
                Text(item.label).fontSize(15).fontColor('#5F6266')
                Blank()
                Text(item.value)
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#252729')
              }
              .width('100%')
              .padding({ top: 14, bottom: 14 })

              if (index < this.summaryItems.length - 1) {
                Divider().strokeWidth(0.6).color('#E8EAEB')
              }
            }, (item: MineDataSummaryItem): string => item.id)

            Text('以上为静态演示数据，当前未连接数据库或云端账户。')
              .width('100%')
              .fontSize(12)
              .fontColor('#A0A3A7')
              .lineHeight(18)
              .margin({ top: 8 })
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(18)
          .shadow({ radius: 16, color: 'rgba(0, 0, 0, 0.035)', offsetY: 3 })

          Column({ space: 0 }) {
            Text('同步设置')
              .width('100%')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#252729')
              .margin({ bottom: 8 })

            this.SyncSettingRow('仅 Wi-Fi 同步', '避免使用移动网络上传数据', this.wifiOnly, true)
            Divider().strokeWidth(0.6).color('#E8EAEB')
            this.SyncSettingRow('自动备份', '定期备份健康与设备记录', this.autoBackup, false)
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(18)
          .shadow({ radius: 16, color: 'rgba(0, 0, 0, 0.035)', offsetY: 3 })

          Row({ space: 12 }) {
            Button('立即同步', { type: ButtonType.Capsule })
              .layoutWeight(1)
              .height(44)
              .fontSize(15)
              .fontColor('#FFFFFF')
              .backgroundColor('#2E7D6F')
              .onClick(() => {
                this.actionHint = '同步服务尚未接入，数据未上传'
              })

            Button('导出数据', { type: ButtonType.Capsule })
              .layoutWeight(1)
              .height(44)
              .fontSize(15)
              .fontColor('#2E7D6F')
              .backgroundColor('#EAF3F0')
              .onClick(() => {
                this.actionHint = '导出功能尚未接入'
              })
          }
          .width('100%')

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
  SyncSettingRow(title: string, description: string, enabled: boolean, isWifiOnly: boolean) {
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
          if (isWifiOnly) {
            this.wifiOnly = isOn
          } else {
            this.autoBackup = isOn
          }
          this.actionHint = '设置仅在当前页面生效，尚未保存'
        })
    }
    .width('100%')
    .padding({ top: 12, bottom: 12 })
    .alignItems(VerticalAlign.Center)
  }
}
