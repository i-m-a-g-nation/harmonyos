/**
 * 新 Mine 二级页共用的标题栏。
 *
 * 组件只负责视觉和返回事件，不持有 NavPathStack，也不调用应用级 router。
 * 左右各保留 48vp，使标题在有返回图标时仍保持真正居中。
 */
@Component
export struct MineSecondaryTitleBar {
  @Prop title: string = ''
  onBack?: () => void

  build() {
    Row() {
      Button({ type: ButtonType.Normal }) {
        Image($r('app.media.mine_chevron_right'))
          .width(22)
          .height(22)
          .objectFit(ImageFit.Contain)
          .rotate({ angle: 180 })
      }
      .width(48)
      .height(48)
      .padding(0)
      .backgroundColor(Color.Transparent)
      .onClick(() => {
        this.onBack?.()
      })

      Text(this.title)
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
