@Component
export struct UnbindButton {
  // 改名：避开系统原生 onClick 方法名，自定义业务回调
  onUnbindClick?: () => void

  build() {
    Row({ space: 12 }) {
      Image($r('app.media.ic_unbind'))
        .width(22)
        .height(22)
        .objectFit(ImageFit.Contain)

      Text('解除绑定')
        .fontSize(18)
        .fontColor('#F5222D')
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .height(56)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('rgba(255, 77, 79, 0.08)')
    .borderRadius(16)
    // 原生 onClick 事件，内部调用我们自定义的业务回调
    .onClick(() => {
      this.onUnbindClick?.()
    })
  }
}