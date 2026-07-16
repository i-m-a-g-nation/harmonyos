import { router } from '@kit.ArkUI';
import { DeviceInfoCard } from '../common/components/DeviceInfoCard'

@Entry
@Component
struct DeviceDetail {
  @Prop batteryLevel: number = 78

  build() {
    Column() {
      // 1. 页面导航栏（标题居中 + 左右按钮点击正常）
      Stack({ alignContent: Alignment.Center }) {
        // 底层：居中标题
        Text('设备详情')
          .fontSize(22)
          .fontWeight(FontWeight.Medium)

        // 顶层：左右按钮（同一层，不会互相覆盖）
        Row() {
          Image($r('app.media.ic_back'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              router.back()
            })

          Blank()

          Image($r('app.media.ic_more'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
        }
        .width('100%')
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 8, bottom: 12 })

      // 2. 可滚动内容区
      Scroll() {
        Column({ space: 16 }) {
          DeviceInfoCard()
            .margin({ left: 20, right: 20, top: -2 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Start)
        .padding({ bottom: 30 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}