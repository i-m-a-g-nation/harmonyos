import router from '@ohos.router'
import { DataCenter } from './DataCenter'

@Entry
@Component
struct QuietTimeSetting {

  @State startHour: number = 22
  @State startMinute: number = 0

  @State endHour: number = 7
  @State endMinute: number = 0

  private themeColor: string = '#1A6656'
  private bgColor: string = '#F5F6FA'
  private cardColor: string = '#FFFFFF'

  private format(value: number): string {
    return value < 10 ? "0" + value : "" + value
  }

  async aboutToAppear() {
    const config = await DataCenter.getReminderConfig()
    let arr = config.quietStart.split(":")
    if (arr.length == 2) {
      this.startHour = Number(arr[0])
      this.startMinute = Number(arr[1])
    }
    arr = config.quietEnd.split(":")
    if (arr.length == 2) {
      this.endHour = Number(arr[0])
      this.endMinute = Number(arr[1])
    }
  }

  async save() {
    const config = await DataCenter.getReminderConfig()
    config.quietStart = this.format(this.startHour) + ":" + this.format(this.startMinute)
    config.quietEnd = this.format(this.endHour) + ":" + this.format(this.endMinute)

    await DataCenter.saveReminderConfig(config)
    console.info("保存后：" + JSON.stringify(await DataCenter.getReminderConfig()))

    // 【核心修改】：保存成功后，返回上一页
    router.back()
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Text("←").fontSize(24).fontColor('#1A1A1A').onClick(() => { router.back() })
        Text("免打扰时间").fontSize(20).fontWeight(FontWeight.Bold).fontColor('#1A1A1A').margin({ left: 16 })
        Text("").layoutWeight(1)
      }
      .height(56).width("100%").alignItems(VerticalAlign.Center).padding({ left: 20, right: 20 }).backgroundColor(this.bgColor)

      Scroll() {
        Column() {
          // 开始时间卡片
          Column() {
            Text("开始时间").fontSize(16).fontWeight(FontWeight.Medium).fontColor('#1A1A1A').width('100%').textAlign(TextAlign.Center).margin({ bottom: 24, top: 4 })

            Row() {
              Button("+").width(44).height(44).backgroundColor('#F5F6FA').fontColor(this.themeColor).fontSize(20).fontWeight(FontWeight.Lighter).borderRadius(22)
                .onClick(() => { this.startHour++; if (this.startHour > 23) this.startHour = 0 })
              Text("").width(60)
              Button("+").width(44).height(44).backgroundColor('#F5F6FA').fontColor(this.themeColor).fontSize(20).fontWeight(FontWeight.Lighter).borderRadius(22)
                .onClick(() => { this.startMinute += 5; if (this.startMinute > 55) this.startMinute = 0 })
            }.margin({ bottom: 8 })

            Row() {
              Text(this.format(this.startHour)).fontSize(36).fontWeight(FontWeight.Bold).fontColor('#1A1A1A').width(60).textAlign(TextAlign.Center)
              Text(":").fontSize(30).fontWeight(FontWeight.Bold).fontColor('#1A1A1A').width(20).textAlign(TextAlign.Center)
              Text(this.format(this.startMinute)).fontSize(36).fontWeight(FontWeight.Bold).fontColor('#1A1A1A').width(60).textAlign(TextAlign.Center)
            }

            Row() {
              Button("-").width(44).height(44).backgroundColor('#F5F6FA').fontColor(this.themeColor).fontSize(20).fontWeight(FontWeight.Lighter).borderRadius(22)
                .onClick(() => { this.startHour--; if (this.startHour < 0) this.startHour = 23 })
              Text("").width(60)
              Button("-").width(44).height(44).backgroundColor('#F5F6FA').fontColor(this.themeColor).fontSize(20).fontWeight(FontWeight.Lighter).borderRadius(22)
                .onClick(() => { this.startMinute -= 5; if (this.startMinute < 0) this.startMinute = 55 })
            }.margin({ top: 8 })
          }
          .width('100%').backgroundColor(this.cardColor).borderRadius(16).padding(24).margin({ top: 12 })

          // 结束时间卡片
          Column() {
            Text("结束时间").fontSize(16).fontWeight(FontWeight.Medium).fontColor('#1A1A1A').width('100%').textAlign(TextAlign.Center).margin({ bottom: 24, top: 4 })

            Row() {
              Button("+").width(44).height(44).backgroundColor('#F5F6FA').fontColor(this.themeColor).fontSize(20).fontWeight(FontWeight.Lighter).borderRadius(22)
                .onClick(() => { this.endHour++; if (this.endHour > 23) this.endHour = 0 })
              Text("").width(60)
              Button("+").width(44).height(44).backgroundColor('#F5F6FA').fontColor(this.themeColor).fontSize(20).fontWeight(FontWeight.Lighter).borderRadius(22)
                .onClick(() => { this.endMinute += 5; if (this.endMinute > 55) this.endMinute = 0 })
            }.margin({ bottom: 8 })

            Row() {
              Text(this.format(this.endHour)).fontSize(36).fontWeight(FontWeight.Bold).fontColor('#1A1A1A').width(60).textAlign(TextAlign.Center)
              Text(":").fontSize(30).fontWeight(FontWeight.Bold).fontColor('#1A1A1A').width(20).textAlign(TextAlign.Center)
              Text(this.format(this.endMinute)).fontSize(36).fontWeight(FontWeight.Bold).fontColor('#1A1A1A').width(60).textAlign(TextAlign.Center)
            }

            Row() {
              Button("-").width(44).height(44).backgroundColor('#F5F6FA').fontColor(this.themeColor).fontSize(20).fontWeight(FontWeight.Lighter).borderRadius(22)
                .onClick(() => { this.endHour--; if (this.endHour < 0) this.endHour = 23 })
              Text("").width(60)
              Button("-").width(44).height(44).backgroundColor('#F5F6FA').fontColor(this.themeColor).fontSize(20).fontWeight(FontWeight.Lighter).borderRadius(22)
                .onClick(() => { this.endMinute -= 5; if (this.endMinute < 0) this.endMinute = 55 })
            }.margin({ top: 8 })
          }
          .width('100%').backgroundColor(this.cardColor).borderRadius(16).padding(24).margin({ top: 20 })

          // 保存按钮
          Button("保存设置").width("100%").height(50).backgroundColor(this.themeColor).fontColor(Color.White).fontSize(16).fontWeight(FontWeight.Medium).borderRadius(25).margin({ top: 50, bottom: 40 })
            .onClick(async () => { await this.save() })
        }
        .padding({ left: 20, right: 20 }).backgroundColor(this.bgColor).width('100%')
      }
      .width('100%').height('100%').scrollBar(BarState.Auto).align(Alignment.Top)
    }
    .backgroundColor(this.bgColor).height("100%")
  }
}