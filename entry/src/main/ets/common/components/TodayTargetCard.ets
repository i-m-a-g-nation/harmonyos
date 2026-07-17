import { TargetItem } from '../model/TargetTypes'

@Component
export struct TodayTargetCard {
  @Prop targetList: TargetItem[] = []

  // 安全获取数组，不会返回undefined
  private getSafeList(): TargetItem[] {
    if (!this.targetList) {
      return []
    }
    return this.targetList
  }

  build() {
    Column({ space: 12 }) {
      Row() {
        Text('今日目标')
          .fontSize(16)
          .fontColor('#1A1A1A')
          .fontWeight(FontWeight.Medium)

        Blank()

        // 直接在行内调用方法获取总数，不在build顶部定义变量
        Text(`${this.getSafeList().length} 个目标`)
          .fontSize(14)
          .fontColor('#3A8F7E')
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')

      Column({ space: 10 }) {
        // ForEach直接调用安全方法
        ForEach(this.getSafeList(), (item: TargetItem) => {
          this.TargetItem(item.content)
        }, (item: TargetItem) => item.id)
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }

  @Builder
  TargetItem(text: string) {
    Row() {
      Circle({ width: 8, height: 8 })
        .fill('#D0D3D6')

      Text(text)
        .fontSize(15)
        .fontColor('#999999')
        .margin({ left: 10 })
        .layoutWeight(1)
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }
}