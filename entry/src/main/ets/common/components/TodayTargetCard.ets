@Component
export struct TodayTargetCard {
  // 已完成数量 / 总数量，外部可动态传入
  @Prop finishedCount: number = 3
  @Prop totalCount: number = 3

  build() {
    Column({ space: 12 }) {
      // 顶部：标题 + 进度
      Row() {
        Text('今日目标')
          .fontSize(16)
          .fontColor('#1A1A1A')
          .fontWeight(FontWeight.Medium)

        Blank()

        Text(`${this.finishedCount}/${this.totalCount}`)
          .fontSize(14)
          .fontColor('#3A8F7E')
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')

      // 目标列表
      Column({ space: 10 }) {
        this.TargetItem('完成 4 个番茄钟', true)
        this.TargetItem('达到 8 次站立', true)
        this.TargetItem('保持空气良好', true)
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }

  // 单个目标项：左侧图标 + 文字 + 右侧完成图标
  @Builder
  TargetItem(text: string, isFinished: boolean) {
    Row() {
      // 左侧状态图标
      this.CheckIcon(isFinished)

      Text(text)
        .fontSize(15)
        .fontColor(isFinished ? '#1A1A1A' : '#999999')
        .margin({ left: 10 })
        .layoutWeight(1)

      // 右侧完成图标
      this.CheckIcon(isFinished)
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }

  // 纯代码绘制圆形对勾图标，支持完成/未完成两种状态
  @Builder
  CheckIcon(isFinished: boolean) {
    Stack({ alignContent: Alignment.Center }) {
      // 圆形底
      Circle({ width: 18, height: 18 })
        .strokeWidth(1.5)
        .stroke(isFinished ? '#3A8F7E' : '#D0D3D6')
        .fill(isFinished ? '#3A8F7E' : Color.Transparent)

      // 对勾符号（Unicode字符，无需素材）
      if (isFinished) {
        Text('✓')
          .fontSize(12)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
      }
    }
    .width(18)
    .height(18)
  }
}