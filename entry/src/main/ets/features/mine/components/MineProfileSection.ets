/** Mine 首页顶部个人资料摘要；只负责展示和报告点击。 */
@Component
export struct MineProfileSection {
  // 展示数据由 MineRoot 经 MineHomePage 传入，组件不读取本机存储。
  @Prop profileName: string = '张小悦'
  @Prop profileSignature: string = '健康办公，高效生活'
  // 具体进入哪个目的地由 MineHomePage/MineRoot 决定，组件保持可复用。
  onOpenProfile?: () => void

  build() {
    Row({ space: 18 }) {
      Image($r('app.media.mine_avatar'))
        .width(64)
        .height(64)
        .borderRadius(32)
        .objectFit(ImageFit.Cover)

      Column({ space: 7 }) {
        Text(this.profileName)
          .fontSize(23)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')

        Text(this.profileSignature)
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
