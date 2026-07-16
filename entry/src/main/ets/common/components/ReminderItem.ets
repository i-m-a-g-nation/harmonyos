@Component
export struct ReminderItem {
  icon: string = ''
  title: string = ''
  desc: string = ''

  // 【核心修复】：将 @Prop 改为 @Link，实现双向同步！
  @Link isChecked: boolean

  build() {
    Row() {
      // 图标
      Text(this.icon)
        .fontSize(28)
        .width(44)
        .height(44)
        .textAlign(TextAlign.Center)
        .backgroundColor('#F5F6FA') // 图标浅灰底色
        .borderRadius(12)
        .margin({ right: 16 })

      // 文字
      Column() {
        Text(this.title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')

        Text(this.desc)
          .fontSize(13)
          .fontColor('#999999')
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      // 开关
      Toggle({ type: ToggleType.Switch, isOn: this.isChecked })
        .selectedColor('#1A6656') // 墨绿色
        .switchPointColor(Color.White)
        .width(50)
        .height(30)
        .onChange((isOn: boolean) => {
          // 当用户拨动开关时，直接修改 @Link 变量，父组件会立刻感知到变化
          this.isChecked = isOn
        })
    }
    .width('100%')
    .padding({ top: 12, bottom: 12 })
  }
}