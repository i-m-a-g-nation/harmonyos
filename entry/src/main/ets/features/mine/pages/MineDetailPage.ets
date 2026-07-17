/**
 * Mine 当前通用的空二级页壳：统一提供返回按钮、标题和内容占位区。
 * 后续实现真实二级页时，应新建独立页面组件，再由 MineRoot 按路由选择渲染。
 */
@Component
export struct MineDetailPage {
  // 标题由 MinePageModel 根据路由统一映射，页面本身不判断业务类型。
  @Prop title: string = ''
  // 返回行为由持有 NavPathStack 的 MineRoot 实现。
  onBack?: () => void

  build() {
    Column() {
      Row() {
        // 左右各保留 48vp 宽度，使中间标题在视觉上保持真正居中。
        Row() {
          Image($r('app.media.mine_chevron_right'))
            .width(22)
            .height(22)
            .objectFit(ImageFit.Contain)
            .rotate({ angle: 180 })
        }
        .width(48)
        .height(48)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.onBack?.()
        })

        Text(this.title)
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
          .textAlign(TextAlign.Center)
          .layoutWeight(1)

        Blank()
          .width(48)
      }
      .width('100%')
      .height(52)
      .padding({ left: 8, right: 8 })
      .alignItems(VerticalAlign.Center)

      // 当前只搭建导航框架，具体二级页内容将在后续任务中填充。
      Blank()
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}
