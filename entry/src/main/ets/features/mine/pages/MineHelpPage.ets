import {
  createMineFeedbackCategoryOptions,
  createMineHelpFaqItems,
  isMineFeedbackContentValid,
  MineFeedbackCategory,
  MineFeedbackCategoryOption,
  MineHelpFaqItem
} from '../model/MineHelpModel'

/**
 * Mine 内部的“帮助与反馈”页面。
 *
 * 页面通过回调上报返回意图，而不直接调用 router；这样 NavPathStack 仍由 MineRoot 单点管理，
 * 本页面也不会意外跳出 Mine 自己的导航边界。
 */
@Component
export struct MineHelpPage {
  onBack?: () => void

  @State selectedCategory: MineFeedbackCategory = MineFeedbackCategory.FEATURE
  @State feedbackContent: string = ''
  @State submitHint: string = ''

  // FAQ 与分类的内容、顺序来自可单测的纯模型，页面只负责渲染，避免 UI 层复制并漂移业务契约。
  private readonly faqItems: MineHelpFaqItem[] = createMineHelpFaqItems()
  private readonly categoryOptions: MineFeedbackCategoryOption[] =
    createMineFeedbackCategoryOptions()

  private canSubmit(): boolean {
    return isMineFeedbackContentValid(this.feedbackContent)
  }

  private selectCategory(category: MineFeedbackCategory): void {
    this.selectedCategory = category
    this.submitHint = ''
  }

  private updateFeedbackContent(content: string): void {
    this.feedbackContent = content
    this.submitHint = ''
  }

  private submitFeedback(): void {
    if (!this.canSubmit()) {
      return
    }
    // 当前没有发送通道，因此保留分类和原文以免制造“已经提交”的错觉，并明确告知内容未发送。
    this.submitHint = '反馈功能尚未接入，内容未发送'
  }

  build() {
    Column() {
      this.TitleBar()

      // 小屏、横屏或系统大字体下两张卡片可能超出可用高度，Scroll 保证全部内容和提交提示均可访问。
      Scroll() {
        Column({ space: 16 }) {
          Column({ space: 16 }) {
            Text('常见问题')
              .width('100%')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#252729')

            ForEach(this.faqItems, (item: MineHelpFaqItem, index: number) => {
              Column({ space: 8 }) {
                Text(item.question)
                  .width('100%')
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#252729')

                Text(item.answer)
                  .width('100%')
                  .fontSize(14)
                  .fontColor('#777A7E')
                  .lineHeight(22)
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)

              if (index < this.faqItems.length - 1) {
                Divider()
                  .strokeWidth(0.6)
                  .color('#E8EAEB')
              }
            }, (item: MineHelpFaqItem): string => item.question)
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(18)
          .shadow({
            radius: 16,
            color: 'rgba(0, 0, 0, 0.035)',
            offsetY: 3
          })

          Column({ space: 12 }) {
            Text('意见反馈')
              .width('100%')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#252729')

            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.categoryOptions, (option: MineFeedbackCategoryOption) => {
                Button(option.label, { type: ButtonType.Capsule })
                .height(34)
                .fontSize(14)
                .fontColor(this.selectedCategory === option.value ? '#FFFFFF' : '#5F6266')
                .backgroundColor(this.selectedCategory === option.value ? '#2E7D6F' : '#EEF1F0')
                .margin({ right: 8, bottom: 8 })
                .onClick(() => {
                  this.selectCategory(option.value)
                })
              }, (option: MineFeedbackCategoryOption): string => option.value)
            }
            .width('100%')

            TextArea({
              text: this.feedbackContent,
              placeholder: '请描述遇到的问题或建议'
            })
              .width('100%')
              .height(128)
              .fontSize(15)
              .fontColor('#252729')
              .placeholderColor('#A0A3A7')
              .backgroundColor('#F7F8FA')
              .borderRadius(12)
              .padding(12)
              .maxLength(300)
              .onChange((content: string) => {
                this.updateFeedbackContent(content)
              })

            Text(`${this.feedbackContent.length}/300`)
              .width('100%')
              .fontSize(12)
              .fontColor('#A0A3A7')
              .textAlign(TextAlign.End)

            Button('提交反馈', { type: ButtonType.Capsule })
            .width('100%')
            .height(44)
            .fontSize(16)
            .fontColor('#FFFFFF')
            .backgroundColor(this.canSubmit() ? '#2E7D6F' : '#C9CFCD')
            .enabled(this.canSubmit())
            .onClick(() => {
              this.submitFeedback()
            })

            if (this.submitHint.length > 0) {
              Text(this.submitHint)
                .width('100%')
                .fontSize(13)
                .fontColor('#A05A2C')
                .textAlign(TextAlign.Center)
            }
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(18)
          .shadow({
            radius: 16,
            color: 'rgba(0, 0, 0, 0.035)',
            offsetY: 3
          })
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 12, bottom: 20 })
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
  TitleBar() {
    Row() {
      Row() {
        Image($r('app.media.mine_chevron_right'))
          .width(22)
          .height(22)
          .objectFit(ImageFit.Contain)
          .rotate({ angle: 180 })
      }
      .width(48)
      .height(48)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.onBack?.()
      })

      Text('帮助与反馈')
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .textAlign(TextAlign.Center)
        .layoutWeight(1)

      Blank()
        .width(48)
    }
    .width('100%')
    .height(52)
    .padding({ left: 8, right: 8 })
    .alignItems(VerticalAlign.Center)
  }
}
