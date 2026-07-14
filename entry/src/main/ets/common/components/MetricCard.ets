@Component
export struct MetricCard {
  @Prop title: string = ''
  @Prop value: string = ''
  @Prop unit: string = ''
  @Prop secondValue: string = ''
  @Prop secondUnit: string = ''
  @Prop iconResource: Resource = $r('app.media.sit')

  build() {
    Column({ space: 10 }) {
      // 标题
      Text(this.title)
        .fontSize(14)
        .fontColor('#666666')

      // 数值行
      Row() {
        Text(this.value)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .maxLines(1)
        Text(this.unit)
          .fontSize(13)
          .fontColor('#666666')
          .margin({ left: 2 })
          .maxLines(1)

        if (this.secondValue) {
          Text(this.secondValue)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ left: 4 })
            .maxLines(1)
          Text(this.secondUnit)
            .fontSize(13)
            .fontColor('#666666')
            .margin({ left: 2 })
            .maxLines(1)
        }
      }
      .alignItems(VerticalAlign.Bottom)

      // 底部图标
      Image(this.iconResource)
        .width(32)
        .height(32)
        .objectFit(ImageFit.Contain)
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .justifyContent(FlexAlign.Center)
  }
}