@Component
export struct StatsCard {
  @Prop title: string = '';
  @Prop value: string = '';
  @Prop unit: string = '';

  build() {
    Column({ space: 8 }) {
      Text(this.title)
        .fontSize(14).fontColor("#666666")
        .width("100%")

      Row() {
        Text(this.value)
          .fontSize(32).fontWeight(FontWeight.Bold).fontColor("#333333")
        Text(this.unit)
          .fontSize(14).fontColor("#999999")
          .margin({ left: 4, bottom: 4 })
      }.width("100%")
    }
    .width("48%")
    .padding(16)
    .backgroundColor("#FEFEFE")
    .borderRadius(16)
    .alignItems(HorizontalAlign.Start)
    .shadow({ radius: 8, color: "rgba(0, 0, 0, 0.04)", offsetY: 2 })
  }
}