@Component
export struct TimerRing {
  @Link progress: number;
  @Link timeText: string;
  @Link tipText: string;

  build() {
    Stack({ alignContent: Alignment.Center }) {
      // 背景圆环
      Progress({ value: 100, total: 100, type: ProgressType.Ring })
        .width(260).height(260)
        .color("#D4E5DE")
        .style({ strokeWidth: 12 })

      // 进度圆环
      Progress({ value: this.progress, total: 100, type: ProgressType.Ring })
        .width(260).height(260)
        .color("#5B9184")
        .style({ strokeWidth: 12 })

      // 中心文字
      Column({ space: 8 }) {
        Text(this.timeText)
          .fontSize(56)
          .fontWeight(FontWeight.Bold)
          .fontColor("#333333")
        Text(this.tipText)
          .fontSize(14)
          .fontColor("#888888")
      }
    }
    .width("100%")
    .height(280)
  }
}