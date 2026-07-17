import { MineSecondaryTitleBar } from '../components/MineSecondaryTitleBar'
import {
  createMinePrivacyControls,
  MinePrivacyControl,
  MinePrivacyControlKey
} from '../model/MinePrivacyModel'

/**
 * “系统与隐私”独立二级页。
 * 当前工程没有权限服务和持久化仓库，因此开关只改变页面实例状态，并始终给出准确提示。
 */
@Component
export struct MinePrivacyPage {
  onBack?: () => void

  @State healthPersonalization: boolean = true
  @State deviceSync: boolean = true
  @State experienceProgram: boolean = false
  @State actionHint: string = ''

  private readonly controls: MinePrivacyControl[] = createMinePrivacyControls()

  private isControlEnabled(key: MinePrivacyControlKey): boolean {
    switch (key) {
      case MinePrivacyControlKey.HEALTH_PERSONALIZATION:
        return this.healthPersonalization
      case MinePrivacyControlKey.DEVICE_SYNC:
        return this.deviceSync
      case MinePrivacyControlKey.EXPERIENCE_PROGRAM:
        return this.experienceProgram
      default:
        return false
    }
  }

  private updateControl(key: MinePrivacyControlKey, enabled: boolean): void {
    switch (key) {
      case MinePrivacyControlKey.HEALTH_PERSONALIZATION:
        this.healthPersonalization = enabled
        break
      case MinePrivacyControlKey.DEVICE_SYNC:
        this.deviceSync = enabled
        break
      case MinePrivacyControlKey.EXPERIENCE_PROGRAM:
        this.experienceProgram = enabled
        break
    }
    this.actionHint = '设置仅在当前页面生效，尚未保存'
  }

  build() {
    Column() {
      MineSecondaryTitleBar({
        title: '系统与隐私',
        onBack: () => {
          this.onBack?.()
        }
      })

      Scroll() {
        Column({ space: 16 }) {
          Column({ space: 0 }) {
            Text('隐私控制')
              .width('100%')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#252729')
              .margin({ bottom: 8 })

            ForEach(this.controls, (control: MinePrivacyControl, index: number) => {
              Row({ space: 12 }) {
                Column({ space: 5 }) {
                  Text(control.label)
                    .fontSize(15)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#252729')

                  Text(control.description)
                    .fontSize(13)
                    .fontColor('#8A8D91')
                    .lineHeight(19)
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                Toggle({ type: ToggleType.Switch, isOn: this.isControlEnabled(control.key) })
                  .selectedColor('#2E7D6F')
                  .switchPointColor(Color.White)
                  .onChange((enabled: boolean) => {
                    this.updateControl(control.key, enabled)
                  })
              }
              .width('100%')
              .padding({ top: 12, bottom: 12 })
              .alignItems(VerticalAlign.Center)

              if (index < this.controls.length - 1) {
                Divider().strokeWidth(0.6).color('#E8EAEB')
              }
            }, (control: MinePrivacyControl): string => control.key)
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(18)
          .shadow({ radius: 16, color: 'rgba(0, 0, 0, 0.035)', offsetY: 3 })

          Column({ space: 14 }) {
            Text('数据说明')
              .width('100%')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#252729')

            this.InfoRow('数据范围', '本地演示数据')
            Divider().strokeWidth(0.6).color('#E8EAEB')
            this.InfoRow('存储状态', '未接入持久化')
            Divider().strokeWidth(0.6).color('#E8EAEB')
            this.InfoRow('系统权限', '未请求')
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(18)
          .shadow({ radius: 16, color: 'rgba(0, 0, 0, 0.035)', offsetY: 3 })

          Button('清除本地演示数据', { type: ButtonType.Capsule })
            .width('100%')
            .height(44)
            .fontSize(16)
            .fontColor('#A05A2C')
            .backgroundColor('#FFF4EC')
            .onClick(() => {
              this.actionHint = '演示数据未接入存储，无需清除'
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
  InfoRow(label: string, value: string) {
    Row() {
      Text(label).fontSize(15).fontColor('#5F6266')
      Blank()
      Text(value).fontSize(14).fontColor('#252729')
    }
    .width('100%')
  }
}
