import router from '@ohos.router'
import { ReminderItem } from '../common/components/ReminderItem'
import { DataCenter } from './DataCenter'
import { ReminderManager } from '../common/service/ReminderManager'

@Entry
@Component
struct ReminderSetting {

  @State quietStart: string = "22:00"
  @State quietEnd: string = "07:00"
  @State sedentary: boolean = true
  @State water: boolean = true
  @State eye: boolean = true
  @State ventilation: boolean = true
  @State level: number = 2

  private themeColor: string = '#1A6656'
  private bgColor: string = '#F5F6FA'
  private cardColor: string = '#FFFFFF'

  async aboutToAppear() {
    // 注册全局回调
    DataCenter.registerRefreshReminderUI(() => {
      console.info("接收到全局刷新回调，开始重载设置页数据...")
      this.loadConfigData()
    })
    // 页面初始加载数据
    await this.loadConfigData()
  }

  aboutToDisappear() {
    DataCenter.unregisterRefreshReminderUI()
  }

  async loadConfigData() {
    let config = await DataCenter.getReminderConfig()
    this.sedentary = config.sedentaryEnable
    this.water = config.waterEnable
    this.eye = config.eyeEnable
    this.ventilation = config.ventilationEnable
    this.level = config.level
    this.quietStart = config.quietStart
    this.quietEnd = config.quietEnd
    console.info(`UI刷新成功，当前免打扰时间: ${this.quietStart} - ${this.quietEnd}`)
  }

  async save() {
    let config = await DataCenter.getReminderConfig()

    // 将这些状态写入 config 对象
    config.sedentaryEnable = this.sedentary
    config.waterEnable = this.water
    config.eyeEnable = this.eye
    config.ventilationEnable = this.ventilation

    config.sedentaryInterval = 45
    config.waterInterval = 60
    config.eyeInterval = 90
    config.co2Limit = 1000

    config.quietStart = this.quietStart
    config.quietEnd = this.quietEnd
    config.level = this.level

    // 1. 保存到本地文件（Preferences）
    await DataCenter.saveReminderConfig(config)

    // 2. 【重要】强制将当前数据同步给内存缓存 (DataCenter.reminderConfig)
    // 这样保证了即使下次读取出现异常，catch里也能拿到正确的数据
    DataCenter.reminderConfig = config

    // 3. 重启提醒服务
    await ReminderManager.start()

    console.info("设置已成功保存到文件和内存！");
  }

  build() {
    Scroll() {
      Column() {
        // 顶部导航
        Row() {
          Text("←").fontSize(24).fontColor('#1A1A1A').onClick(() => { router.back() })
          Text("提醒设置").fontSize(20).fontWeight(FontWeight.Bold).fontColor('#1A1A1A').margin({ left: 16 })
          Text("").layoutWeight(1)
        }
        .height(56).width('100%').alignItems(VerticalAlign.Center).padding({ left: 20, right: 20 })

        // 健康提醒卡片
        Column() {
          Text("健康提醒").fontSize(16).fontWeight(FontWeight.Medium).fontColor('#1A1A1A').width('100%').padding({ bottom: 12 })
          ReminderItem({ icon: "🪑", title: "久坐提醒", desc: "连续办公45分钟提醒活动", isChecked: $sedentary })
          Divider().color('#F0F0F0').margin({ left: 16, right: 16 })

          ReminderItem({ icon: "💧", title: "喝水提醒", desc: "每60分钟提醒喝水", isChecked: $water })
          Divider().color('#F0F0F0').margin({ left: 16, right: 16 })

          ReminderItem({ icon: "👁", title: "远眺提醒", desc: "每90分钟保护视力", isChecked: $eye })
          Divider().color('#F0F0F0').margin({ left: 16, right: 16 })

          ReminderItem({ icon: "🌱", title: "通风提醒", desc: "CO₂超过1000ppm提醒", isChecked: $ventilation })
        }
        .width('100%').backgroundColor(this.cardColor).borderRadius(16).padding(16).margin({ top: 12 })

        // 免打扰时间
        Column() {
          Text("免打扰时间").fontSize(16).fontWeight(FontWeight.Medium).fontColor('#1A1A1A').width('100%').padding({ bottom: 12 })

          Row() {
            Text("🌙").fontSize(18).margin({ right: 8 })
            Text(`${this.quietStart} - ${this.quietEnd}`).fontSize(15).fontColor('#333333').layoutWeight(1)
            Text(">").fontSize(16).fontColor('#C0C0C0')
          }
          .width('100%').padding(12).backgroundColor('#F8F9FB').borderRadius(12)
          .onClick(async () => {
            await router.push({ url: "pages/QuietTimeSetting" })
          })
        }
        .width('100%').backgroundColor(this.cardColor).borderRadius(16).padding(16).margin({ top: 16 })

        // 提醒强度
        Column() {
          Text("提醒强度").fontSize(16).fontWeight(FontWeight.Medium).fontColor('#1A1A1A').width('100%').padding({ bottom: 12 })

          Row() {
            this.LevelButton("轻柔", 1)
            this.LevelButton("适中", 2)
            this.LevelButton("强力", 3)
          }
          .width('100%').justifyContent(FlexAlign.SpaceBetween)
        }
        .width('100%').backgroundColor(this.cardColor).borderRadius(16).padding(16).margin({ top: 16 })

        // 保存按钮
        Button("保存设置").width("100%").height(50).backgroundColor(this.themeColor).fontColor(Color.White).fontSize(16).fontWeight(FontWeight.Medium).borderRadius(25).margin({ top: 40, bottom: 40 })
          .onClick(async () => { await this.save() })
      }
      .padding({ left: 20, right: 20 }).backgroundColor(this.bgColor).width('100%')
    }
    .width('100%').height('100%').scrollBar(BarState.Auto).align(Alignment.Top)
  }

  // 【修复点】：删除 `const isActive = ...`，直接把计算逻辑写在 Button 属性里
  @Builder
  LevelButton(text: string, value: number) {
    Button(text)
      .width('31%').height(40)
      .backgroundColor(this.level === value ? this.themeColor : '#F5F6FA')
      .fontColor(this.level === value ? Color.White : '#666666')
      .fontSize(14)
      .fontWeight(this.level === value ? FontWeight.Medium : FontWeight.Normal)
      .borderRadius(20)
      .onClick(() => { this.level = value })
  }
}