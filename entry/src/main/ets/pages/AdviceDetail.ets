import { router } from '@kit.ArkUI';

@Entry
@Component
struct AdviceDetail {
  build() {
    Column() {
      // 顶部导航栏（与设备详情页风格统一）
      Stack({ alignContent: Alignment.Center }) {
        Text('健康建议详情')
          .fontSize(22)
          .fontWeight(FontWeight.Medium)

        Row() {
          Image($r('app.media.ic_back'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              router.back()
            })
          Blank()
        }
        .width('100%')
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 8, bottom: 0 })

      // 内容滚动区
      Scroll() {
        Column({ space: 16 }) {
          // 建议概览卡片
          Column() {
            Row() {
              Text('💡')
                .fontSize(32)
              Column({ space: 6 }) {
                Text('久坐提醒')
                  .fontSize(20)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#1C1C1E')
                Text('上午久坐偏多，建议调整作息')
                  .fontSize(14)
                  .fontColor('#8E8E93')
              }
              .margin({ left: 12 })
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#EAF5EF')
          .borderRadius(16)
          .margin({ top: 12 })

          // 原因分析
          Column({ space: 12 }) {
            Text('原因分析')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1C1C1E')
              .width('100%')

            Text('今日上午累计久坐 3 小时 12 分钟，最长连续久坐 92 分钟未起身，超过了健康办公的推荐阈值。长期保持该状态会增加颈椎、腰椎负担，同时室内二氧化碳浓度逐步升高，容易引发疲劳、注意力下降。')
              .fontSize(15)
              .fontColor('#3C3C43')
              .lineHeight(22)
              .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)

          // 改善建议列表
          Column({ space: 12 }) {
            Text('改善建议')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1C1C1E')
              .width('100%')

            this.buildAdviceItem('01', '定时起身', '每 45 分钟起身活动 2~3 分钟，做简单的颈部、腰部拉伸。')
            this.buildAdviceItem('02', '开窗通风', '建议立刻开窗通风 5 分钟，降低室内二氧化碳浓度。')
            this.buildAdviceItem('03', '调整节奏', '下午采用番茄工作法，25 分钟专注 + 5 分钟休息交替。')
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 30 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }

  @Builder
  buildAdviceItem(index: string, title: string, desc: string) {
    Row({ space: 12 }) {
      Text(index)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#3A8F7E')
        .width(28)

      Column({ space: 4 }) {
        Text(title)
          .fontSize(16)
          .fontColor('#1C1C1E')
          .fontWeight(FontWeight.Medium)
        Text(desc)
          .fontSize(14)
          .fontColor('#8E8E93')
          .lineHeight(20)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
  }
}