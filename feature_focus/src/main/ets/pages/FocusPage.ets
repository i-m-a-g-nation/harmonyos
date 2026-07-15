import { createFocusFeature, FocusViewModel } from "../state/focusViewModel";
import { TimerRing } from "../components/TimerRing";
import { ControlBar } from "../components/ControlBar";
import { StatsCard } from "../components/StatsCard";
import { SessionBarChart } from "../components/SessionBarChart";
import { FocusRule, SessionRecord } from "../service/focusService";

@Component
export struct FocusPage {
  private viewModel: FocusViewModel | null = null;
  private syncTimer: number | null = null;

  @State progress: number = 0;
  @State timeText: string = '25:00';
  @State tipText: string = '';
  @State isRunning: boolean = false;
  @State phaseLabel: string = '准备开始';
  @State buttonText: string = '开始专注';
  @State completedPomodoros: number = 0;
  @State totalFocusMinutes: number = 0;
  @State totalFocusSeconds: number = 0;
  @State showConfigPanel: boolean = false;
  @State configFocusMin: number = FocusRule.DEFAULT_FOCUS_MIN;
  @State configRestMin: number = FocusRule.DEFAULT_REST_MIN;
  @State sessionRecords: SessionRecord[] = [];
  @State maxRecordDurationMin: number = 25;

  aboutToAppear() {
    const ctx = getContext(this);
    this.viewModel = createFocusFeature(ctx).viewModel;
    this.viewModel.init(ctx);
    this.syncUI();
    this.startSyncTimer();
  }

  onPageShow() {
    this.viewModel?.onPageShow();
    this.syncUI();
    this.startSyncTimer();
  }

  onPageHide() {
    this.stopSyncTimer();
    this.viewModel?.onPageHide();
  }

  aboutToDisappear() {
    this.stopSyncTimer();
    this.viewModel?.destroy();
  }

  private startSyncTimer(): void {
    this.stopSyncTimer();
    this.syncTimer = setInterval(() => {
      this.syncUI();
    }, 500);
  }

  private stopSyncTimer(): void {
    if (this.syncTimer !== null) {
      clearInterval(this.syncTimer);
      this.syncTimer = null;
    }
  }

  private syncUI() {
    if (this.viewModel === null) return;
    this.progress = this.viewModel.getProgress();
    this.timeText = this.viewModel.remainingText;
    this.tipText = this.viewModel.getTipText();
    this.isRunning = this.viewModel.isRunning;
    this.phaseLabel = this.viewModel.getPhaseLabel();
    this.buttonText = this.viewModel.getButtonText();
    this.completedPomodoros = this.viewModel.completedPomodoros;
    this.totalFocusMinutes = this.viewModel.totalFocusMinutes;
    this.totalFocusSeconds = this.viewModel.totalFocusSeconds;
    if (!this.showConfigPanel) {
      this.configFocusMin = this.viewModel.focusDurationMin;
      this.configRestMin = this.viewModel.restDurationMin;
    }
    this.sessionRecords = this.viewModel.sessionRecords;
    this.maxRecordDurationMin = this.viewModel.maxRecordDurationMin;
  }

  build() {
    Scroll() {
      Column({ space: 20 }) {
        Text("专注")
          .fontSize(24).fontWeight(FontWeight.Bold)
          .width("100%").textAlign(TextAlign.Start)

        // 圆环计时器
        TimerRing({
          progress: $progress,
          timeText: $timeText,
          tipText: $tipText
        })

        // 控制按钮
        ControlBar({
          isRunning: $isRunning,
          phaseLabel: $phaseLabel,
          buttonText: $buttonText,
          onStartClick: () => {
            this.viewModel?.toggleStart();
            this.syncUI();
          },
          onResetClick: () => {
            this.viewModel?.reset();
            this.syncUI();
          },
          onConfigClick: () => {
            this.showConfigPanel = !this.showConfigPanel;
          }
        })

        // 时长配置面板
        if (this.showConfigPanel) {
          this.buildConfigPanel()
        }

        // 统计卡片
        Row({ space: 12 }) {
          StatsCard({
            title: "完成番茄钟",
            value: this.completedPomodoros.toString(),
            unit: "个"
          })
          StatsCard({
          title: "专注总时长",
          value: (this.totalFocusSeconds / 60).toFixed(1),
          unit: "分钟"
        })
        }.width("100%")

        // 会话记录条形图
        SessionBarChart({
          records: this.sessionRecords,
          maxMinutes: this.maxRecordDurationMin
        })
      }
      .width("100%")
      .padding({ left: 20, right: 20, top: 20, bottom: 80 })
    }
    .width("100%").height("100%")
    .backgroundColor("#F8FAF9")
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Auto)
    .edgeEffect(EdgeEffect.Spring)
  }

  @Builder
  buildConfigPanel() {
    Column({ space: 16 }) {
      // 专注时长
      Row() {
        Text("专注时长")
          .fontSize(16).fontColor("#333333")
        Blank()
        Row({ space: 8 }) {
          Button("-")
            .width(36).height(36)
            .fontSize(18)
            .backgroundColor("#E8F0EC")
            .fontColor("#4CAF7D")
            .borderRadius(18)
            .onClick(() => {
              if (this.configFocusMin > FocusRule.MIN_FOCUS_MIN) {
                this.configFocusMin -= 5;
              }
            })
          Text(`${this.configFocusMin}分钟`)
            .fontSize(18).fontWeight(FontWeight.Medium)
            .fontColor("#333333")
            .width(80).textAlign(TextAlign.Center)
          Button("+")
            .width(36).height(36)
            .fontSize(18)
            .backgroundColor("#E8F0EC")
            .fontColor("#4CAF7D")
            .borderRadius(18)
            .onClick(() => {
              if (this.configFocusMin < FocusRule.MAX_FOCUS_MIN) {
                this.configFocusMin += 5;
              }
            })
        }
      }.width("100%")

      // 休息时长
      Row() {
        Text("休息时长")
          .fontSize(16).fontColor("#333333")
        Blank()
        Row({ space: 8 }) {
          Button("-")
            .width(36).height(36)
            .fontSize(18)
            .backgroundColor("#E8F0EC")
            .fontColor("#4CAF7D")
            .borderRadius(18)
            .onClick(() => {
              if (this.configRestMin > FocusRule.MIN_REST_MIN) {
                this.configRestMin -= 1;
              }
            })
          Text(`${this.configRestMin}分钟`)
            .fontSize(18).fontWeight(FontWeight.Medium)
            .fontColor("#333333")
            .width(80).textAlign(TextAlign.Center)
          Button("+")
            .width(36).height(36)
            .fontSize(18)
            .backgroundColor("#E8F0EC")
            .fontColor("#4CAF7D")
            .borderRadius(18)
            .onClick(() => {
              if (this.configRestMin < FocusRule.MAX_REST_MIN) {
                this.configRestMin += 1;
              }
            })
        }
      }.width("100%")

      // 确认按钮
      Button("应用设置")
        .width("100%").height(44)
        .fontSize(16).fontWeight(FontWeight.Medium)
        .backgroundColor("#4CAF7D")
        .borderRadius(22)
        .onClick(() => {
          this.viewModel?.setDuration(this.configFocusMin, this.configRestMin);
          this.showConfigPanel = false;
          this.syncUI();
        })
    }
    .width("100%")
    .padding(20)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .shadow({ radius: 8, color: "#1A000000", offsetX: 0, offsetY: 2 })
  }
}