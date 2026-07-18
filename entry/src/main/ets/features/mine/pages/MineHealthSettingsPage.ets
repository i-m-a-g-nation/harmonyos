import { MineSecondaryTitleBar } from '../components/MineSecondaryTitleBar'
import {
  adjustMineHealthGoal,
  createMineHealthGoals,
  MineHealthGoal,
  MineHealthGoalKey
} from '../model/MineHealthSettingsModel'

/**
 * “健康设置”独立二级页。
 * 目标和提醒只保存在当前页面实例，后续接入设置仓库时应由 MineRoot 上层注入状态和保存动作。
 */
@Component
export struct MineHealthSettingsPage {
  onBack?: () => void

  @State stepsGoal: number = 8000
  @State focusGoal: number = 60
  @State waterGoal: number = 8
  @State sedentaryReminder: boolean = true
  @State waterReminder: boolean = true
  @State eyeReminder: boolean = false
  @State actionHint: string = ''

  private readonly goals: MineHealthGoal[] = createMineHealthGoals()

  private currentGoalValue(key: MineHealthGoalKey): number {
    switch (key) {
      case MineHealthGoalKey.STEPS:
        return this.stepsGoal
      case MineHealthGoalKey.FOCUS:
        return this.focusGoal
      case MineHealthGoalKey.WATER:
        return this.waterGoal
      default:
        return 0
    }
  }

  private updateGoal(goal: MineHealthGoal, delta: number): void {
    const nextValue: number = adjustMineHealthGoal(
      this.currentGoalValue(goal.key),
      delta,
      goal.minimum,
      goal.maximum
    )
    switch (goal.key) {
      case MineHealthGoalKey.STEPS:
        this.stepsGoal = nextValue
        break
      case MineHealthGoalKey.FOCUS:
        this.focusGoal = nextValue
        break
      case MineHealthGoalKey.WATER:
        this.waterGoal = nextValue
        break
    }
    this.actionHint = '健康设置仅在当前页面生效，尚未保存'
  }

  build() {
    Column() {
      MineSecondaryTitleBar({
        title: '健康设置',
        onBack: () => {
          this.onBack?.()
        }
      })

      Scroll() {
        Column({ space: 16 }) {
          Column({ space: 0 }) {
            Text('每日目标')
              .width('100%')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#252729')
              .margin({ bottom: 8 })

            ForEach(this.goals, (goal: MineHealthGoal, index: number) => {
              Row({ space: 12 }) {
                Column({ space: 5 }) {
                  Text(goal.label)
                    .fontSize(15)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#252729')
                  Text(`${goal.minimum}–${goal.maximum} ${goal.unit}`)
                    .fontSize(12)
                    .fontColor('#A0A3A7')
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                Button('−', { type: ButtonType.Circle })
                  .width(34)
                  .height(34)
                  .fontSize(20)
                  .fontColor('#2E7D6F')
                  .backgroundColor('#EAF3F0')
                  .enabled(this.currentGoalValue(goal.key) > goal.minimum)
                  .onClick(() => {
                    this.updateGoal(goal, -goal.step)
                  })

                Text(`${this.currentGoalValue(goal.key)} ${goal.unit}`)
                  .width(82)
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#252729')
                  .textAlign(TextAlign.Center)

                Button('+', { type: ButtonType.Circle })
                  .width(34)
                  .height(34)
                  .fontSize(18)
                  .fontColor('#FFFFFF')
                  .backgroundColor('#2E7D6F')
                  .enabled(this.currentGoalValue(goal.key) < goal.maximum)
                  .onClick(() => {
                    this.updateGoal(goal, goal.step)
                  })
              }
              .width('100%')
              .padding({ top: 13, bottom: 13 })
              .alignItems(VerticalAlign.Center)

              if (index < this.goals.length - 1) {
                Divider().strokeWidth(0.6).color('#E8EAEB')
              }
            }, (goal: MineHealthGoal): string => goal.key)
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(18)
          .shadow({ radius: 16, color: 'rgba(0, 0, 0, 0.035)', offsetY: 3 })

          Column({ space: 0 }) {
            Text('健康提醒')
              .width('100%')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#252729')
              .margin({ bottom: 8 })

            this.ReminderRow('久坐提醒', '连续坐姿过久时提示活动', this.sedentaryReminder, 0)
            Divider().strokeWidth(0.6).color('#E8EAEB')
            this.ReminderRow('饮水提醒', '按日常节奏提醒补充水分', this.waterReminder, 1)
            Divider().strokeWidth(0.6).color('#E8EAEB')
            this.ReminderRow('用眼提醒', '专注工作一段时间后提示休息', this.eyeReminder, 2)
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(18)
          .shadow({ radius: 16, color: 'rgba(0, 0, 0, 0.035)', offsetY: 3 })

          if (this.actionHint.length > 0) {
            Text(this.actionHint)
              .width('100%')
              .fontSize(13)
              .fontColor('#777A7E')
              .textAlign(TextAlign.Center)
          }
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 12, bottom: 24 })
      }
      .layoutWeight(1)
      .width('100%')
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }

  @Builder
  ReminderRow(title: string, description: string, enabled: boolean, index: number) {
    Row({ space: 12 }) {
      Column({ space: 5 }) {
        Text(title).fontSize(15).fontWeight(FontWeight.Medium).fontColor('#252729')
        Text(description).fontSize(13).fontColor('#8A8D91')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Toggle({ type: ToggleType.Switch, isOn: enabled })
        .selectedColor('#2E7D6F')
        .switchPointColor(Color.White)
        .onChange((isOn: boolean) => {
          if (index === 0) {
            this.sedentaryReminder = isOn
          } else if (index === 1) {
            this.waterReminder = isOn
          } else {
            this.eyeReminder = isOn
          }
          this.actionHint = '健康设置仅在当前页面生效，尚未保存'
        })
    }
    .width('100%')
    .padding({ top: 12, bottom: 12 })
    .alignItems(VerticalAlign.Center)
  }
}
