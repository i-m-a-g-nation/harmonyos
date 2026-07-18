import { MineSecondaryTitleBar } from '../components/MineSecondaryTitleBar'
import {
  isMineProfileNameValid,
  isMineProfileSignatureValid,
  MineProfile
} from '../model/MineProfileModel'

/**
 * Mine 的个人资料编辑页。
 * 页面只维护编辑草稿；持久化和首页状态更新由 MineRoot 注入的异步回调完成。
 * 未点击保存直接返回时，草稿随页面销毁并丢弃。
 */
@Component
export struct MineProfilePage {
  onBack?: () => void
  onSaveProfile?: (profile: MineProfile) => Promise<MineProfile>

  @Prop initialProfileName: string = '张小悦'
  @Prop initialProfileSignature: string = '健康办公，高效生活'

  @State profileName: string = ''
  @State profileSignature: string = ''
  @State actionHint: string = ''
  @State isSaving: boolean = false

  aboutToAppear(): void {
    // 每次创建目的地都从最后一次成功保存的父状态建立独立草稿。
    this.profileName = this.initialProfileName
    this.profileSignature = this.initialProfileSignature
    this.actionHint = ''
  }

  private canSave(): boolean {
    return isMineProfileNameValid(this.profileName) &&
      isMineProfileSignatureValid(this.profileSignature)
  }

  private markChanged(): void {
    this.actionHint = '更改尚未保存'
  }

  private async saveProfile(): Promise<void> {
    if (!this.canSave() || this.isSaving || this.onSaveProfile === undefined) {
      return
    }

    this.isSaving = true
    this.actionHint = ''
    try {
      const savedProfile: MineProfile = await this.onSaveProfile({
        name: this.profileName,
        signature: this.profileSignature
      })
      // Service 会规范化昵称；用实际写入值刷新草稿，确保页面与首页一致。
      this.profileName = savedProfile.name
      this.profileSignature = savedProfile.signature
      this.actionHint = '已保存到本机'
    } catch {
      // 保留草稿供用户重试，且不显示可能误导用户的成功状态。
      this.actionHint = '保存失败，请稍后重试'
    } finally {
      this.isSaving = false
    }
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
                .enabled(!this.isSaving)
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
                .enabled(!this.isSaving)
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
            this.InfoRow('资料存储', '已保存在本机')
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(18)
          .shadow({ radius: 16, color: 'rgba(0, 0, 0, 0.035)', offsetY: 3 })

          Button(this.isSaving ? '保存中...' : '保存资料', { type: ButtonType.Capsule })
            .width('100%')
            .height(44)
            .fontSize(16)
            .fontColor('#FFFFFF')
            .backgroundColor(this.canSave() && !this.isSaving ? '#2E7D6F' : '#C9CFCD')
            .enabled(this.canSave() && !this.isSaving)
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
