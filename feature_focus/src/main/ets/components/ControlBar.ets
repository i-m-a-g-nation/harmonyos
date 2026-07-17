@Component
export struct ControlBar {
  @Link isRunning: boolean;
  @Link phaseLabel: string;
  @Link buttonText: string;
  onStartClick: () => void = () => {};
  onResetClick: () => void = () => {};
  onConfigClick: () => void = () => {};

  build() {
    Column({ space: 12 }) {
      // 阶段标签
      Text(this.phaseLabel)
        .fontSize(16)
        .fontColor("#5B9184")
        .fontWeight(FontWeight.Medium)

      // 主按钮行
      Row({ space: 16 }) {
        Button(this.buttonText)
          .width("70%").height(52)
          .fontSize(18).fontWeight(FontWeight.Medium)
          .backgroundColor("#5B9184")
          .borderRadius(26)
          .onClick(() => this.onStartClick())

        // 重置按钮
        Button() {
          Text('↻')
            .fontSize(22).fontColor("#5B9184")
        }
        .width(52).height(52)
        .backgroundColor(Color.White)
        .borderRadius(26)
        .shadow({ radius: 4, color: "#1A000000", offsetX: 0, offsetY: 2 })
        .onClick(() => this.onResetClick())
      }
      .width("100%")
      .justifyContent(FlexAlign.Center)

      // 时长配置入口
      Row() {
        Text('⏱')
          .fontSize(16).fontColor("#999999")
        Text("时长设置")
          .fontSize(14).fontColor("#999999")
          .margin({ left: 4 })
      }
      .onClick(() => this.onConfigClick())
      .padding({ top: 8, bottom: 8, left: 12, right: 12 })
    }
    .width("100%")
    .alignItems(HorizontalAlign.Center)
  }
}