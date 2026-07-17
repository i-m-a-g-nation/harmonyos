import { router } from '@kit.ArkUI';
import { TargetItem } from '../common/model/TargetTypes'

@Entry
@Component
struct TargetSetting {
  @StorageLink('targetList') targetList: TargetItem[] = []
  @State newTargetText: string = ''

  // 添加新目标
  private addNewTarget() {
    if (this.newTargetText.trim().length === 0) return
    const newItem: TargetItem = {
      id: Date.now().toString(),
      content: this.newTargetText.trim(),
      isFinished: false
    }
    // 用 concat 生成新数组，符合 ArkTS 语法
    this.targetList = this.targetList.concat([newItem])
    this.newTargetText = ''
  }

  // 删除目标
  private deleteTarget(id: string) {
    this.targetList = this.targetList.filter(item => item.id !== id)
  }

  build() {
    Column() {
      // 顶部导航栏
      Stack({ alignContent: Alignment.Center }) {
        Text('今日目标管理')
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

      // 目标列表
      Scroll() {
        Column({ space: 12 }) {
          Column({ space: 0 }) {
            ForEach(this.targetList || [], (item: TargetItem, index: number) => {
              Row() {
                Text(item.content)
                  .fontSize(16)
                  .fontColor('#1A1A1A')
                  .layoutWeight(1)

                Text('删除')
                  .fontSize(14)
                  .fontColor('#FF3B30')
                  .onClick(() => {
                    this.deleteTarget(item.id)
                  })
              }
              .width('100%')
              .padding({ top: 14, bottom: 14, left: 16, right: 16 })

              if (index < this.targetList.length - 1) {
                Divider().color('#F0F0F0').margin({ left: 16 })
              }
            }, (item: TargetItem) => item.id)
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .margin({ top: 12 })
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 20 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      // 底部新增输入区
      Row({ space: 12 }) {
        TextInput({ placeholder: '添加新的今日目标', text: this.newTargetText })
          .layoutWeight(1)
          .height(44)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .padding({ left: 14, right: 14 })
          .onChange((value: string) => {
            this.newTargetText = value
          })

        Button('添加')
          .height(44)
          .backgroundColor('#3A8F7E')
          .borderRadius(12)
          .fontSize(15)
          .onClick(() => {
            this.addNewTarget()
          })
      }
      .width('100%')
      .padding({ left: 20, right: 20, bottom: 20, top: 8 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}