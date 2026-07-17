import { MineSecondaryTitleBar } from '../components/MineSecondaryTitleBar'
import {
  isMineProfileNameValid,
  isMineProfileSignatureValid
} from '../model/MineProfileModel'

/**
 * Mine 的个人资料编辑页。
 * 当前没有用户资料仓库，编辑结果只保留在页面实例，返回后不会覆盖 Mine 首页摘要。
 */
@Component
export struct MineProfilePage {
  onBack?: () => void

  @State profileName: string = '张小悦'
  @State profileSignature: string = '健康办公，高效生活'
  @State actionHint: string = ''

  private canSave(): boolean {
    return isMineProfileNameValid(this.profileName) &&
      isMineProfileSignatureValid(this.profileSignature)
  }

  private markChanged(): void {
    this.actionHint = '更改尚未保存'
  }

  private saveProfile(): void {
    if (!this.canSave()) {
      return
    }
    // 没有持久化能力时保留用户输入并如实说明状态，避免制造已写入账号的错觉。
    this.actionHint = '个人资料仅在当前页面更新，尚未保存'
  }

  build() {
    Column() {
      MineSecondaryTitleBar({
        title: '个人资料',
        onBack: () => {
          this.onBack?.()
        }
      })

      Scroll() {
        Column({ space: 16 }) {
          Column({ space: 12 }) {
            Image($r('app.media.mine_avatar'))
              .width(84)
              .height(84)
              .borderRadius(42)
              .objectFit(ImageFit.Cover)

            Text('当前头像')
              .fontSize(13)
              .fontColor('#8A8D91')

            Text('头像选择功能尚未接入')
              .fontSize(12)
              .fontColor('#A0A3A7')
          }
          .width('100%')
          .padding({ top: 18, bottom: 10 })

          Column({ space: 16 }) {
            Text('基本信息')
              .width('100%')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#252729')

            Column({ space: 8 }) {
              Text('昵称')
                .width('100%')
                .fontSize(14)
                .fontColor('#5F6266')

              TextInput({ text: this.profileName, placeholder: '请输入昵称' })
                .width('100%')
                .height(46)
                .fontSize(15)
                .fontColor('#252729')
                .placeholderColor('#A0A3A7')
                .backgroundColor('#F7F8FA')
                .borderRadius(12)
                .padding({ left: 13, right: 13 })
                .maxLength(20)
                .onChange((value: string) => {
                  this.profileName = value
                  this.markChanged()
                })

              Text(`${this.profileName.length}/20`)
                .width('100%')
                .fontSize(12)
                .fontColor(isMineProfileNameValid(this.profileName) ? '#A0A3A7' : '#B95C5C')
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)

            Column({ space: 8 }) {
              Text('个性签名')
                .width('100%')
                .fontSize(14)
                .fontColor('#5F6266')

              TextInput({ text: this.profileSignature, placeholder: '写一句介绍自己' })
                .width('100%')
                .height(46)
                .fontSize(15)
                .fontColor('#252729')
                .placeholderColor('#A0A3A7')
                .backgroundColor('#F7F8FA')
                .borderRadius(12)
                .padding({ left: 13, right: 13 })
                .maxLength(40)
                .onChange((value: string) => {
                  this.profileSignature = value
                  this.markChanged()
                })

              Text(`${this.profileSignature.length}/40`)
                .width('100%')
                .fontSize(12)
                .fontColor('#A0A3A7')
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(18)
          .shadow({ radius: 16, color: 'rgba(0, 0, 0, 0.035)', offsetY: 3 })

          Column({ space: 14 }) {
            Text('账号信息')
              .width('100%')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#252729')

            this.InfoRow('账号状态', '本地演示账号')
            Divider().strokeWidth(0.6).color('#E8EAEB')
            this.InfoRow('资料同步', '未接入')
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(18)
          .shadow({ radius: 16, color: 'rgba(0, 0, 0, 0.035)', offsetY: 3 })

          Button('保存资料', { type: ButtonType.Capsule })
            .width('100%')
            .height(44)
            .fontSize(16)
            .fontColor('#FFFFFF')
            .backgroundColor(this.canSave() ? '#2E7D6F' : '#C9CFCD')
            .enabled(this.canSave())
            .onClick(() => {
              this.saveProfile()
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
        .padding({ left: 20, right: 20, top: 8, bottom: 24 })
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
