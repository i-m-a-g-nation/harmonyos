@Component
export struct BatteryIcon {
  // 电量数值 0-100
  @Prop batteryLevel: number = 85
  @Prop iconSize: number = 20
  // 低电量阈值
  private readonly LOW_THRESHOLD: number = 20

  // 获取填充色
  private getFillColor(): string {
    return this.batteryLevel <= this.LOW_THRESHOLD ? '#E74C3C' : '#333333'
  }

  build() {
    Stack({ alignContent: Alignment.Start }) {
      // 1. 电池主体外框
      Rect()
        .width(this.iconSize)
        .height(this.iconSize * 0.55)
        .borderRadius(2)
        .stroke('#909399')
        .strokeWidth(1.2)
        .fill(Color.Transparent)

      // 2. 电池正极小帽
      Rect()
        .width(2)
        .height(this.iconSize * 0.25)
        .fill('#909399')
        .borderRadius({ topRight: 1, bottomRight: 1 })
        .position({
          x: this.iconSize,
          y: (this.iconSize * 0.55 - this.iconSize * 0.25) / 2
        })

      // 3. 内部电量填充
      if (this.batteryLevel > 0) {
        Rect()
          .width((this.iconSize - 3) * (this.batteryLevel / 100))
          .height(this.iconSize * 0.55 - 3)
          .fill(this.getFillColor())
          .borderRadius(1)
          .margin({ left: 1.5 })
          .animation({ duration: 300 })
      }
    }
    .width(this.iconSize + 2) // 留出正极宽度
    .height(this.iconSize * 0.55)
  }
}