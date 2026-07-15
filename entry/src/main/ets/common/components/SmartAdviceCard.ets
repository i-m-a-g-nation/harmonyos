@Component
export struct SmartAdviceCard {
  // 建议内容，外部可传入
  @Prop adviceText: string = '上午久坐偏多，建议下午每45分钟起身活动'
  // 点击回调
  onViewClick?: () => void

  build() {
    Column({ space: 10 }) {
      // 顶部：图标 + 标题
      Row({ space: 6 }) {
        Image($r('app.media.env1'))
          .width(16)
          .height(16)
          .objectFit(ImageFit.Contain)

        Text('智能建议')
          .fontSize(14)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')

      // 底部：建议文字 + 去查看按钮
      Row() {
        Text(this.adviceText)
          .fontSize(15)
          .fontColor('#333333')
          .layoutWeight(1)
          .maxLines(2)

        // 纯代码实现的胶囊按钮，无需素材
        Text('去查看')
          .fontSize(13)
          .fontColor('#FFFFFF')
          .padding({ left: 16, right: 16, top: 6, bottom: 6 })
          .backgroundColor('#3A8F7E')
          .borderRadius(999) // 大数值实现胶囊圆角
          .onClick(() => {
            this.onViewClick?.()
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }
}