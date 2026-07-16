@Component
export struct MineDetailPage {
  @Prop title: string = ''
  onBack?: () => void

  build() {
    Column() {
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

      Blank()
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}
