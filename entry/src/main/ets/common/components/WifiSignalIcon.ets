import { WifiSignalLevel } from '../constants/StatusEnum'

@Component
export struct WifiSignalIcon {
  @Prop level: WifiSignalLevel = WifiSignalLevel.FULL
  @Prop iconSize: number = 16
  // 正常状态颜色
  private readonly normalColor: string = '#333333'
  // 无信号颜色
  private readonly disableColor: string = '#D0D0D0'

  build() {
    // 4格信号条，底部对齐，高度递增
    Row({ space: 2 }) {
      ForEach([1, 2, 3, 4], (index: number) => {
        Rect()
          .width(2)
          .height(this.iconSize * (index / 4))
          .borderRadius(1)
          .fill(index <= this.level ? this.normalColor : this.disableColor)
      })
    }
    .width(this.iconSize)
    .height(this.iconSize)
    .alignItems(VerticalAlign.Bottom)
  }
}