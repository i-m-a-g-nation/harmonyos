import { router } from '@kit.ArkUI';
import { DeviceInfoCard } from '../common/components/DeviceInfoCard'
import { DeviceMenuCard } from '../common/components/DeviceMenuCard'
import { UnbindButton } from '../common/components/UnbindButton'


@Entry
@Component
struct DeviceDetail {
  @Prop batteryLevel: number = 78

  build() {
    Column() {
      // 1. 页面导航栏
      Stack({ alignContent: Alignment.Center }) {
        Text('设备详情')
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
          Image($r('app.media.ic_more'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
        }
        .width('100%')
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 8, bottom: 0 })

      // 2. 可滚动内容区
      Scroll() {
        Column({ space: 16 }) {
          // 设备信息卡片
          DeviceInfoCard()
            .margin({ left: 20, right: 20, top: -2 })

          // 功能菜单卡片
          DeviceMenuCard()
            .margin({ left: 20, right: 20 })

          UnbindButton()
            .margin({ left: 20, right: 20 })
        }
        .width('100%')
        // 核心修复：删掉 height('100%')，高度由内容自适应
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