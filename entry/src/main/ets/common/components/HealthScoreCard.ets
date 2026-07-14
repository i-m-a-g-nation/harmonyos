@Component
export struct HealthScoreCard {
  @Prop score: number = 86

  private get levelText(): string {
    if (this.score >= 90) return '优秀'
    if (this.score >= 70) return '良好'
    if (this.score >= 60) return '一般'
    return '需改善'
  }

  private get levelColor(): ResourceColor {
    if (this.score >= 90) return '#2E7D6F'
    if (this.score >= 70) return '#3A8F7E'
    if (this.score >= 60) return '#E2A75C'
    return '#E74C3C'
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        // 基础环形进度条：使用原生默认样式，保证全版本兼容
        Progress({
          value: this.score,
          total: 100,
          type: ProgressType.Ring
        })
          .width('85%')
          .aspectRatio(1)
          .color(this.levelColor)
          .backgroundColor('#E8EAEB')
          .animation({
            duration: 1000,
            curve: Curve.EaseOut
          })

        // 中间文字内容
        Column({ space: 8 }) {
          Text(`${this.score}`)
            .fontSize(60)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')

          Text(this.levelText)
            .fontSize(20)
            .fontColor(this.levelColor)
            .fontWeight(FontWeight.Medium)

          Text('今日办公健康总分')
            .fontSize(16)
            .fontColor('#666666')
            .margin({ top: 8 })

          Row({ space: 16 }) {
            Text('较上周 +5')
              .fontSize(14)
              .fontColor('#999999')
            Text('|')
              .fontSize(14)
              .fontColor('#E0E0E0')
            Text('较上月 +9')
              .fontSize(14)
              .fontColor('#999999')
          }
          .margin({ top: 4 })
        }
      }
      .width('100%')
      .aspectRatio(1)
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(24)
    .shadow({
      radius: 20,
      color: 'rgba(0, 0, 0, 0.04)',
      offsetY: 4
    })
  }
}