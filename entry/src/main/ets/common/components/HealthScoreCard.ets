@Component
export struct HealthScoreCard {
  @Prop score: number = 86

  // 缩小圆环尺寸，降低卡片高度
  private readonly CIRCLE_DIAMETER: number = 150
  private readonly STROKE_WIDTH: number = 10
  private readonly CIRCUMFERENCE: number = this.CIRCLE_DIAMETER * Math.PI
  private readonly TOTAL_ARC_LENGTH: number = this.CIRCUMFERENCE * 0.75 // 270°总弧长

  // 计算进度弧长
  private get progressArcLength(): number {
    return this.TOTAL_ARC_LENGTH * Math.min(Math.max(this.score, 0), 100) / 100
  }

  private get levelText(): string {
    if (this.score >= 90) return '优秀'
    if (this.score >= 70) return '良好'
    if (this.score >= 60) return '一般'
    return '需改善'
  }

  // 改用 0x 开头的 ARGB 颜色值，全版本兼容
  private get levelColor(): number {
    if (this.score >= 90) return 0xFF2E7D6F
    if (this.score >= 70) return 0xFF3A8F7E
    if (this.score >= 60) return 0xFFE2A75C
    return 0xFFE74C3C
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        // 底层灰色轨道
        Circle()
          .width(this.CIRCLE_DIAMETER)
          .height(this.CIRCLE_DIAMETER)
          .fill(Color.Transparent)
          .strokeWidth(this.STROKE_WIDTH)
          .stroke(0xFFE8EAEB)
          .strokeDashArray([this.TOTAL_ARC_LENGTH, this.CIRCUMFERENCE - this.TOTAL_ARC_LENGTH])
          .strokeLineCap(LineCapStyle.Round)
          .rotate({ angle: 135 })

        // 上层绿色进度
        Circle()
          .width(this.CIRCLE_DIAMETER)
          .height(this.CIRCLE_DIAMETER)
          .fill(Color.Transparent)
          .strokeWidth(this.STROKE_WIDTH)
          .stroke(this.levelColor)
          .strokeDashArray([this.progressArcLength, this.CIRCUMFERENCE])
          .strokeLineCap(LineCapStyle.Round)
          .rotate({ angle: 135 })
          .animation({
            duration: 1000,
            curve: Curve.EaseOut
          })

        // 中间文字
        Column({ space: 4 }) {
          Text(`${this.score}`)
            .fontSize(38)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')

          Text(this.levelText)
            .fontSize(15)
            .fontColor(this.levelColor)
            .fontWeight(FontWeight.Medium)

          Text('今日办公健康总分')
            .fontSize(12)
            .fontColor('#666666')
            .margin({ top: 2 })

          Row({ space: 12 }) {
            Text('较上周 +5')
              .fontSize(11)
              .fontColor('#999999')
            Text('|')
              .fontSize(11)
              .fontColor('#E0E0E0')
            Text('较上月 +9')
              .fontSize(11)
              .fontColor('#999999')
          }
          .margin({ top: 2 })
        }
      }
      .width('100%')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 8, bottom: 10 })
    .backgroundColor('#FFFFFF')
    .borderRadius(24)
    .shadow({
      radius: 20,
      color: 'rgba(0, 0, 0, 0.04)',
      offsetY: 4
    })
  }
}