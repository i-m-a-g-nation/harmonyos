/**
 * “关于我们”独立二级页。
 *
 * 页面只负责展示本地静态信息和上报返回事件，不访问应用级 router、网络或账户状态，
 * 因而能够完全保留在 Mine 功能边界内。
 */
@Component
export struct MineAboutPage {
  // 返回动作由持有 NavPathStack 的 MineRoot 注入。本页面不直接调用 router，避免形成应用级路由依赖。
  onBack?: () => void

  build() {
    Column() {
      this.TitleBar()

      // 小屏幕、横屏或系统大字体下内容可能超过可用高度，因此主体始终放入 Scroll。
      Scroll() {
        Column({ space: 20 }) {
          // 图标和名称读取已有资源，而不是在 Mine 内复制品牌信息。
          // 当前 app_name 的实际值由 AppScope/resources/base/element/string.json 维护。
          Column({ space: 12 }) {
            Image($r('app.media.startIcon'))
              .width(78)
              .height(78)
              .borderRadius(20)
              .objectFit(ImageFit.Cover)

            Text($r('app.string.app_name'))
              .fontSize(22)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1A1A1A')

            // 当前 ArkUI 页面没有引入包信息读取服务，因此版本号暂以静态文本展示。
            // 发布新版本时，需要与 AppScope/app.json5 中的 versionName 一并更新。
            Text('版本 1.0.0')
              .fontSize(14)
              .fontColor('#777A7E')
          }
          .width('100%')
          .padding({ top: 22, bottom: 8 })

          // 信息卡片沿用 Mine 首页的白色圆角、轻阴影视觉语言，保持二级页与 Mine 首页一致。
          Column({ space: 18 }) {
            Column({ space: 10 }) {
              Text('产品介绍')
                .width('100%')
                .fontSize(17)
                .fontWeight(FontWeight.Medium)
                .fontColor('#252729')

              // 当前为本地展示文案；未来接入运营配置时，应由上层传入，不在页面内发起网络请求。
              Text('关注健康办公与高效生活，为用户提供设备管理、健康洞察与专注辅助体验。')
                .width('100%')
                .fontSize(15)
                .fontColor('#5F6266')
                .lineHeight(24)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)

            Divider()
              .strokeWidth(0.6)
              .color('#E8EAEB')

            Row() {
              Text('当前版本')
                .fontSize(15)
                .fontColor('#5F6266')

              Blank()

              // 与页面顶部保持一致；两处版本号应在同一个小任务中同步修改。
              Text('1.0.0')
                .fontSize(15)
                .fontColor('#252729')
            }
            .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(18)
          .shadow({
            radius: 16,
            color: 'rgba(0, 0, 0, 0.035)',
            offsetY: 3
          })

          // 页尾信息不参与交互，使用弱化颜色，避免抢占产品介绍的视觉层级。
          Text('© 2026')
            .fontSize(13)
            .fontColor('#A0A3A7')
            .margin({ top: 8, bottom: 24 })
        }
        .width('100%')
        .padding({ left: 20, right: 20 })
      }
      .layoutWeight(1)
      .width('100%')
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }

  /**
   * Mine 二级页统一的居中标题栏。
   * 左侧返回区与右侧空白区都固定为 48vp，使标题不受返回图标宽度影响并保持真正居中。
   * 抽成 Builder 是为了让主体 build() 只表达“标题栏 + 可滚动内容”的页面结构。
   */
  @Builder
  TitleBar() {
    Row() {
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
        // 可选调用允许 Preview 或独立组件测试在未注入回调时仍安全渲染。
        this.onBack?.()
      })

      Text('关于我们')
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
  }
}
