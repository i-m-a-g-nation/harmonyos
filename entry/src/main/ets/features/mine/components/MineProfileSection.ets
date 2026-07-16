@Component
export struct MineProfileSection {
  onOpenProfile?: () => void

  build() {
    Row({ space: 18 }) {
      Image($r('app.media.mine_avatar'))
        .width(64)
        .height(64)
        .borderRadius(32)
        .objectFit(ImageFit.Cover)

      Column({ space: 7 }) {
        Text('张小悦')
          .fontSize(23)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')

        Text('健康办公，高效生活')
          .fontSize(14)
          .fontColor('#5F6266')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Image($r('app.media.mine_chevron_right'))
        .width(22)
        .height(22)
        .objectFit(ImageFit.Contain)
    }
    .width('100%')
    .padding({ top: 8, bottom: 6 })
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.onOpenProfile?.()
    })
  }
}
