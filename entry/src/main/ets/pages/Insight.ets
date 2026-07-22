// Insight.ets
// 洞察页面：整合 久坐 / 环境 / 报告 三个 Tab
// 参考设计稿：iOS 风格绿色主题卡片

// Insight 作为子组件嵌入 Index，不再需要 router 和独立 BottomTabBar

// ==================== 类型定义 ====================
interface IndicatorParam {
  glyph: Resource,
  label: string,
  progress: number,
  desc: string,
  color: ResourceColor
}

interface HealthLevel {
  text: string;
  color: string;
  bgColor: string;
}

interface ShadowOpt {
  radius: number,
  color: string,
  offsetX?: number,
  offsetY?: number
}

interface DailyData {
  officeHealthScore: number;
  totalSedentaryMinutes: number;
  maxContinuousSedentaryMinutes: number;
  standUpTimes: number;
  co2Concentration: number;
  temperature: number;
  humidity: number;
  pomodoroCount: number;
  totalFocusMinutes: number;
}

interface Co2Point {
  hour: number,
  ppm: number
}

interface SedentarySegment {
  start: string,   // "09:10"
  end: string,     // "10:42"
  minutes: number  // 92
}

interface SedentaryReminder {
  glyph: Resource,
  title: string,
  desc: string,
  tone: 'good' | 'warn' | 'bad'
}

// ==================== 新增：报告页日历、指标类型（分支新增逻辑） ====================
interface ReportIndicatorItem {
  iconRes: Resource;
  label: string;
  valStr: string;
  progressPercent: number;
}
interface CalendarDay {
  day: number;
  isCurrentMonth: boolean;
  date: Date;
}

const WEEK_TITLES: string[] = ['日', '一', '二', '三', '四', '五', '六'];

// ==================== 颜色常量 ====================
const APPLE_BG = '#F7F8FA';
const APPLE_BLUE = '#3A8F7E';           // 主题绿色（与 BottomTabBar 保持一致）
const APPLE_GREEN = '#34C759';
const APPLE_ORANGE = '#FF9500';
const APPLE_RED = '#FF3B30';
const GRAY_PLACEHOLDER = '#C7C7CC';
const BLACK = '#33000000';
const CARD_SHADOW: ShadowOpt = { radius: 16, color: '#1A000000', offsetY: 4 };

@Component
export struct Insight {
  // ---------- 主题色 ----------
  private readonly COLOR_PAGE_BG: string = APPLE_BG;
  private readonly TEXT_GRAY_MID: string = '#8E8E93';
  private readonly TEXT_GRAY_DARK: string = '#1C1C1E';
  private readonly DIVIDER_COLOR: string = '#E5E5EA';
  private readonly BIG_CARD_BG: string = '#FFFFFF';
  private readonly SMALL_CARD_BG: string = '#F4F6F5';
  private readonly ENV_CARD_BG: string = '#EAF5EF'; // 环境卡浅绿底
  private readonly TAB_UNDERLINE: string = '#3A8F7E';

  // ---------- 顶部 Tab：0=久坐 1=环境 2=报告（主分支：父组件双向绑定） ----------
  @Link currentTopTab: number;
  private readonly TOP_TABS: string[] = ['久坐', '环境', '报告'];

  // ---------- 报告页基础数据 ----------
  @State officeHealthScore: number = 86;
  private readonly FULL_SCORE: number = 100;
  @State totalSedentaryMinutes: number = 252;
  @State maxContinuousSedentaryMinutes: number = 48;
  @State standUpTimes: number = 6;
  @State co2Concentration: number = 420;
  @State temperature: number = 24.6;
  @State humidity: number = 48;
  @State pomodoroCount: number = 6;
  @State totalFocusMinutes: number = 150;
  @State showCalendarPopup: boolean = false;
  @State selectDate: string = '5月20日 周一';
  @State showCo2Tip: boolean = false;
  @State hasData: boolean = true;

  // ========== 分支新增：报告页独立日历/数据状态（前缀report_防重名） ==========
  @State report_selectDateObj: Date = new Date(2024, 4, 20)
  @State report_tempSelectDateObj: Date = new Date(2024, 4, 20)
  @State report_healthTotalScore: number = 86
  @State report_indicatorDataSource: ReportIndicatorItem[] = []
  @State selectDateObj: Date = new Date(2024, 4, 20);

  private dailyDataMap: Map<string, DailyData> = new Map();

  // ---------- 环境 Tab 24h 折线图数据 ----------
  @State co2Series: Co2Point[] = [
    { hour: 0, ppm: 410 }, { hour: 1, ppm: 420 }, { hour: 2, ppm: 430 },
    { hour: 3, ppm: 440 }, { hour: 4, ppm: 430 }, { hour: 5, ppm: 420 },
    { hour: 6, ppm: 410 }, { hour: 7, ppm: 400 }, { hour: 8, ppm: 410 },
    { hour: 9, ppm: 420 }, { hour: 10, ppm: 460 }, { hour: 11, ppm: 520 },
    { hour: 12, ppm: 580 }, { hour: 13, ppm: 620 }, { hour: 14, ppm: 600 },
    { hour: 15, ppm: 540 }, { hour: 16, ppm: 500 }, { hour: 17, ppm: 480 },
    { hour: 18, ppm: 470 }, { hour: 19, ppm: 460 }, { hour: 20, ppm: 450 },
    { hour: 21, ppm: 440 }, { hour: 22, ppm: 430 }, { hour: 23, ppm: 420 }
  ];
  @State co2HighlightHour: number = 9;

  // ---------- 久坐 Tab 模拟数据 ----------
  @State sedentarySegments: SedentarySegment[] = [
    { start: '09:10', end: '10:42', minutes: 92 },
    { start: '11:05', end: '12:30', minutes: 85 },
    { start: '14:00', end: '15:25', minutes: 85 },
    { start: '15:40', end: '16:18', minutes: 38 }
  ];
  @State longestStreakMinutes: number = 92;
  @State standUpGoal: number = 8;
  @State standUpDone: number = 6;
  private sedentaryReminders: SedentaryReminder[] = [
    {
      glyph: $r('sys.symbol.figure_arms_open'),
      title: '起身活动',
      desc: '已连续久坐 92 分钟，建议立刻起身活动 2~3 分钟',
      tone: 'bad'
    },
    {
      glyph: $r('sys.symbol.timer'),
      title: '番茄提醒',
      desc: '距离下一个番茄钟还剩 8 分钟',
      tone: 'good'
    },
    {
      glyph: $r('sys.symbol.eye'),
      title: '颈椎放松',
      desc: '每 45 分钟做一组颈部拉伸，缓解久坐疲劳',
      tone: 'warn'
    }
  ];

  // ==================== 工具函数（分支新增日历工具、日期文案） ====================
  getWeekText(date: Date): string {
    const weekList = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    return weekList[date.getDay()]
  }

  getDailyMessageText(): string {
    const msgList = [
      "合理分配工作与休息，健康才是长久的底气。",
      "时常起身放松身体，舒适办公才能保持高效专注。",
      "保持室内通风，给自己一个清爽舒适的办公环境。",
      "劳逸结合，规律作息，每一天都保持良好状态。",
      "少久坐、多活动，温和养护身体，提升办公幸福感。"
    ]
    const day = this.report_selectDateObj.getDate();
    return msgList[day % msgList.length];
  }

  // 获取指定月份的总天数
  private getDaysInMonth(year: number, month: number): number {
    return new Date(year, month + 1, 0).getDate();
  }

  // 生成当月日历网格数据（自动补全上月/下月占位日期）
  private generateCalendarDays(targetDate: Date): CalendarDay[] {
    const year: number = targetDate.getFullYear();
    const month: number = targetDate.getMonth();
    const daysInMonth: number = this.getDaysInMonth(year, month);
    const firstDayWeek: number = new Date(year, month, 1).getDay();
    const days: CalendarDay[] = [];

    // 补上个月末尾日期
    const prevMonthDays: number = this.getDaysInMonth(year, month - 1);
    for (let i = firstDayWeek - 1; i >= 0; i--) {
      const dayNum: number = prevMonthDays - i;
      days.push({
        day: dayNum,
        isCurrentMonth: false,
        date: new Date(year, month - 1, dayNum)
      });
    }

    // 当月日期
    for (let i = 1; i <= daysInMonth; i++) {
      days.push({
        day: i,
        isCurrentMonth: true,
        date: new Date(year, month, i)
      });
    }

    // 补下个月开头日期，凑齐6行完整网格
    const remain: number = 42 - days.length;
    for (let i = 1; i <= remain; i++) {
      days.push({
        day: i,
        isCurrentMonth: false,
        date: new Date(year, month + 1, i)
      });
    }
    return days;
  }

  // 判断两个日期是否为同一天
  private isSameDay(date1: Date, date2: Date): boolean {
    return date1.getFullYear() === date2.getFullYear()
      && date1.getMonth() === date2.getMonth()
      && date1.getDate() === date2.getDate();
  }

  // ==================== 生命周期 ====================
  aboutToAppear() {
    // 原有模拟数据初始化（主分支保留）
    this.dailyDataMap.set('5月20日 周一', {
      officeHealthScore: 86,
      totalSedentaryMinutes: 252,
      maxContinuousSedentaryMinutes: 48,
      standUpTimes: 6,
      co2Concentration: 420,
      temperature: 24.6,
      humidity: 48,
      pomodoroCount: 6,
      totalFocusMinutes: 150
    });
    this.dailyDataMap.set('5月22日 周三', {
      officeHealthScore: 62,
      totalSedentaryMinutes: 300,
      maxContinuousSedentaryMinutes: 180,
      standUpTimes: 3,
      co2Concentration: 850,
      temperature: 25.1,
      humidity: 42,
      pomodoroCount: 3,
      totalFocusMinutes: 75
    });
    this.loadDataForDate(this.selectDate);

    // ========== 分支新增：报告页指标数据源自动绑定主代码数据 ==========
    const sitHour = Math.floor(this.totalSedentaryMinutes / 60);
    const sitMin = this.totalSedentaryMinutes % 60;
    this.report_indicatorDataSource = [
      {
        iconRes: $r("app.media.longsittime"),
        label: "久坐时间",
        valStr: `${sitHour}小时${sitMin}分`,
        progressPercent: this.getProgressVal(this.totalSedentaryMinutes, 360)
      },
      {
        iconRes: $r("app.media.maxlongsittime"),
        label: "最长连续久坐",
        valStr: `${this.maxContinuousSedentaryMinutes}分钟`,
        progressPercent: this.getProgressVal(this.maxContinuousSedentaryMinutes, 120)
      },
      {
        iconRes: $r("app.media.standtime"),
        label: "站立次数",
        valStr: `${this.standUpTimes}次`,
        progressPercent: this.getProgressVal(this.standUpTimes, this.standUpGoal)
      },
      {
        iconRes: $r("app.media.CO2"),
        label: "CO₂",
        valStr: `${this.co2Concentration} ppm`,
        progressPercent: this.getProgressVal(this.co2Concentration, this.MAX_CO2_PPM)
      },
      {
        iconRes: $r("app.media.temperature_humidity"),
        label: "温度 / 湿度",
        valStr: `${this.temperature}℃ / ${this.humidity}%`,
        progressPercent: 50
      },
      {
        iconRes: $r("app.media.tomatonumber"),
        label: "番茄钟数量",
        valStr: `${this.pomodoroCount}个`,
        progressPercent: this.getProgressVal(this.pomodoroCount, this.MAX_POMODORO_NUM)
      },
      {
        iconRes: $r("app.media.alltime"),
        label: "专注总时长",
        valStr: `${this.totalFocusMinutes}分钟`,
        progressPercent: this.getProgressVal(this.totalFocusMinutes, this.MAX_FOCUS_MIN)
      },
    ]
    // 同步健康分数、选中日期对象
    this.report_healthTotalScore = this.officeHealthScore;
    this.report_selectDateObj = this.selectDateObj;
    this.report_tempSelectDateObj = new Date(this.report_selectDateObj);
  }

  loadDataForDate(dateStr: string) {
    const data = this.dailyDataMap.get(dateStr);
    if (data) {
      this.officeHealthScore = data.officeHealthScore;
      this.totalSedentaryMinutes = data.totalSedentaryMinutes;
      this.maxContinuousSedentaryMinutes = data.maxContinuousSedentaryMinutes;
      this.standUpTimes = data.standUpTimes;
      this.co2Concentration = data.co2Concentration;
      this.temperature = data.temperature;
      this.humidity = data.humidity;
      this.pomodoroCount = data.pomodoroCount;
      this.totalFocusMinutes = data.totalFocusMinutes;
      this.hasData = true;
    } else {
      this.hasData = false;
      this.officeHealthScore = 0;
      this.totalSedentaryMinutes = 0;
      this.maxContinuousSedentaryMinutes = 0;
      this.standUpTimes = 0;
      this.co2Concentration = 0;
      this.temperature = 0;
      this.humidity = 0;
      this.pomodoroCount = 0;
      this.totalFocusMinutes = 0;
    }
  }

  getProgressVal(value: number, max: number): number {
    if (!this.hasData) return -1;
    return Math.min(Math.floor(value / max * 100), 100);
  }

  getHealthLevel(score: number): HealthLevel {
    if (!this.hasData) {
      return { text: '无数据', color: GRAY_PLACEHOLDER, bgColor: '#F9F9F9' };
    }
    if (score >= 90) return { text: '优秀', color: APPLE_BLUE, bgColor: '#E5F0FF' }; else if (score >= 80) return {
      text: '良好',
      color: APPLE_GREEN,
      bgColor: '#E9F7EC'
    }; else if (score >= 60) return { text: '一般', color: APPLE_ORANGE, bgColor: '#FFF1E6' }; else return {
      text: '较差',
      color: APPLE_RED,
      bgColor: '#FFEBEB'
    };
  }

  getCo2Level(ppm: number): HealthLevel {
    if (ppm <= 600) return { text: '优', color: '#FFFFFF', bgColor: '#3A8F7E' };
    if (ppm <= 1000) return { text: '良', color: '#FFFFFF', bgColor: '#7BC47F' };
    if (ppm <= 1500) return { text: '差', color: '#FFFFFF', bgColor: '#FF9500' };
    return { text: '差', color: '#FFFFFF', bgColor: '#FF3B30' };
  }

  getCo2Comment(ppm: number): string {
    if (ppm <= 600) return '空气质量优';
    if (ppm <= 1000) return '空气质量良';
    if (ppm <= 1500) return '建议通风';
    return '空气污浊';
  }

  private readonly MAX_CO2_PPM: number = 1200;
  private readonly MAX_POMODORO_NUM: number = 10;
  private readonly MAX_FOCUS_MIN: number = 240;

  // ==================== 页面构建 ====================
  build() {
    Column() {
      this.buildTopHeader();
      this.buildTopTabs();

      Stack() {
        // 内容滚动区
        if (this.currentTopTab === 0) {
          Scroll() {
            Column() {
              this.buildSedentaryTab();
            }
            .width('100%')
            .padding({ bottom: 20 });
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Auto)
          .width('100%')
          .height('100%');
        } else if (this.currentTopTab === 1) {
          Stack() {
            Scroll() {
              Column() {
                this.buildEnvironmentTab();
              }
              .width('100%')
              .padding({ bottom: 20 });
            }
            .scrollable(ScrollDirection.Vertical)
            .scrollBar(BarState.Auto)
            .width('100%')
            .height('100%');

            if (this.showCo2Tip) {
              Column()
                .width('100%')
                .height('100%')
                .backgroundColor(BLACK)
                .onClick(() => {
                  this.showCo2Tip = false;
                });
              this.buildCo2TipCard();
            }
          }
          .layoutWeight(1)
          .width('100%');
        } else {
          Stack() {
            Scroll() {
              Column() {
                this.buildDateSelector();
                this.buildReportTab();
              }
              .width('100%')
              .padding({ bottom: 20 });
            }
            .scrollable(ScrollDirection.Vertical)
            .scrollBar(BarState.Auto)
            .width('100%')
            .height('100%');

            if (this.showCalendarPopup) {
              Column() {
                Blank()
                  .layoutWeight(1)
                  .width("100%")
                  .onClick(() => {
                    this.showCalendarPopup = false
                  })
                this.report_calendarPopupContent()
              }
              .width('100%')
              .height('100%')
              .backgroundColor('rgba(0,0,0,0.3)')
              .zIndex(9999)
            }
          }
          .layoutWeight(1)
          .width('100%');
        }
      }
      .layoutWeight(1)
      .width('100%');
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.COLOR_PAGE_BG);
  }

  // ==================== 顶部标题栏 ====================
  @Builder
  buildTopHeader() {
    Row() {
      Text('洞察')
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.TEXT_GRAY_DARK);
      Blank();
      if (this.currentTopTab === 2) {
        SymbolGlyph($r('sys.symbol.calendar'))
          .fontSize(22)
          .fontColor([APPLE_BLUE])
          .onClick(() => {
            this.showCalendarPopup = true;
          });
      }
    }
    .width('100%')
    .padding({
      left: 20,
      right: 20,
      top: 12,
      bottom: 8
    })
    .alignItems(VerticalAlign.Center);
  }

  // ==================== 顶部 Tab 切换栏 ====================
  @Builder
  buildTopTabs() {
    Row() {
      ForEach(this.TOP_TABS, (tab: string, index: number) => {
        Column() {
          Text(tab)
            .fontSize(18)
            .fontWeight(this.currentTopTab === index ? FontWeight.Medium : FontWeight.Normal)
            .fontColor(this.currentTopTab === index ? this.TEXT_GRAY_DARK : this.TEXT_GRAY_MID);
          // 选中时显示绿色下划线
          Row()
            .width(this.currentTopTab === index ? 24 : 0)
            .height(3)
            .backgroundColor(this.TAB_UNDERLINE)
            .borderRadius(1.5)
            .margin({ top: 6 });
        }
        .layoutWeight(1)
        .padding({ top: 8, bottom: 8 })
        .alignItems(HorizontalAlign.Center)
        .onClick(() => {
          this.currentTopTab = index;
        });
      });
    }
    .width('100%')
    .padding({ left: 20, right: 20, bottom: 8 });
  }

  // ===========================================================
  // ==================== Tab 1：环境 =============================
  // ===========================================================
  @Builder
  buildEnvironmentTab() {
    Column() {
      // ----- 当前 CO₂ 大卡 -----
      this.buildEnvCo2Card();
      // ----- 温湿度并排双卡 -----
      Row({ space: 12 }) {
        this.buildEnvMetricCard('温度', this.temperature.toFixed(1) + '℃', $r('sys.symbol.thermometer'));
        this.buildEnvMetricCard('湿度', this.humidity + '%', $r('sys.symbol.drop'));
      }
      .width('92%')
      .margin({ top: 12 });

      // ----- 24h CO₂ 趋势 -----
      this.buildEnvTrendCard();
      // ----- 环境建议 -----
      this.buildEnvAdviceCard();
    }
    .width('100%')
    .padding({ top: 8 });
  }

  // 当前 CO2 大卡
  @Builder
  buildEnvCo2Card() {
    Column() {
      Row() {
        Column() {
          Text('当前 CO₂')
            .fontSize(14)
            .fontColor(this.TEXT_GRAY_MID)
            .margin({ bottom: 8 });

          Row({ space: 8 }) {
            Text(this.co2Concentration.toString())
              .fontSize(56)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.TEXT_GRAY_DARK);
            Text('ppm')
              .fontSize(20)
              .fontColor(this.TEXT_GRAY_MID)
              .margin({ bottom: 12 });
          }
          .alignItems(VerticalAlign.Bottom);

          Row({ space: 8 }) {
            Text(this.getCo2Level(this.co2Concentration).text)
              .fontSize(13)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.getCo2Level(this.co2Concentration).color)
              .backgroundColor(this.getCo2Level(this.co2Concentration).bgColor)
              .padding({
                left: 10,
                right: 10,
                top: 4,
                bottom: 4
              })
              .borderRadius(12);
            Text(this.getCo2Comment(this.co2Concentration))
              .fontSize(15)
              .fontColor(this.TEXT_GRAY_DARK);
          }
          .margin({ top: 8 });
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1);

        // 右侧装饰：用大号 emoji 植物代替图（无插画资源时优雅降级）
        Text('🌿')
          .fontSize(64)
          .opacity(0.85);
      }
      .width('100%')
      .alignItems(VerticalAlign.Center);
    }
    .width('92%')
    .padding(20)
    .backgroundColor(this.ENV_CARD_BG)
    .borderRadius(20)
    .shadow(CARD_SHADOW)
    .margin({ top: 4 });
  }

  // 温湿度小卡
  @Builder
  buildEnvMetricCard(label: string, value: string, glyph: Resource) {
    Row() {
      Column() {
        Text(label)
          .fontSize(14)
          .fontColor(this.TEXT_GRAY_MID);
        Text(value)
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.TEXT_GRAY_DARK)
          .margin({ top: 8 });
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1);

      // 圆角小图标
      Stack() {
        SymbolGlyph(glyph)
          .fontSize(24)
          .fontColor([APPLE_BLUE]);
      }
      .width(48)
      .height(48)
      .borderRadius(24)
      .backgroundColor('#D8ECE2')
      .alignContent(Alignment.Center);
    }
    .layoutWeight(1)
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .shadow(CARD_SHADOW)
    .alignItems(VerticalAlign.Center);
  }

  // 24h CO2 趋势卡
  @Builder
  buildEnvTrendCard() {
    Column() {
      Text('24 小时 CO₂ 趋势')
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.TEXT_GRAY_DARK)
        .width('100%')
        .margin({ bottom: 12 });

      this.buildEnvLineChart();

      // 横轴时间
      Row() {
        ForEach([0, 6, 12, 18, 24], (h: number) => {
          Text(h.toString().padStart(2, '0'))
            .fontSize(12)
            .fontColor(this.TEXT_GRAY_MID)
            .layoutWeight(1)
            .textAlign(TextAlign.Center);
        });
      }
      .width('100%')
      .margin({ top: 4 });

      // 点击气泡提示切换
      Row() {
        Text('• 当前选中')
          .fontSize(12)
          .fontColor(this.TEXT_GRAY_MID);
        Text(
          `${this.co2HighlightHour.toString().padStart(2, '0')}:00  ${this.co2Series[this.co2HighlightHour].ppm} ppm`)
          .fontSize(12)
          .fontColor(APPLE_BLUE)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 6 });
        Blank();
        Text('点击图表切换')
          .fontSize(12)
          .fontColor(this.TEXT_GRAY_MID);
      }
      .width('100%')
      .margin({ top: 10 });
    }
    .width('92%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(20)
    .shadow(CARD_SHADOW)
    .margin({ top: 12 });
  }

  // 折线图（Path 实现）
  @Builder
  buildEnvLineChart() {
    Stack() {
      // 网格横线
      Column() {
        ForEach([0, 1, 2, 3, 4], () => {
          Row()
            .width('100%')
            .height(1)
            .backgroundColor('#F0F0F2');
        });
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween);

      // 折线（Path 折线命令）
      this.buildCo2Polyline();

      // 数据点 + 选中气泡
      ForEach(this.co2Series, (pt: Co2Point) => {
        if (pt.hour === this.co2HighlightHour) {
          // 气泡提示框
          Column() {
            Text(`${pt.hour.toString().padStart(2, '0')}:00`)
              .fontSize(11)
              .fontColor(this.TEXT_GRAY_MID);
            Row({ space: 4 }) {
              Text(pt.ppm.toString())
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.TEXT_GRAY_DARK);
              Text('ppm')
                .fontSize(10)
                .fontColor(this.TEXT_GRAY_MID);
            }
            .alignItems(VerticalAlign.Bottom);
          }
          .padding(8)
          .backgroundColor('#F4F8F6')
          .borderRadius(8)
          .borderWidth(1)
          .borderColor('#D8ECE2')
          .shadow({ radius: 8, color: '#1A000000', offsetY: 2 })
          .position({ x: this.getX(pt.hour) - 36, y: this.getY(pt.ppm) - 56 });
        }

        // 选中点的圆环
        if (pt.hour === this.co2HighlightHour) {
          Stack() {
            Row()
              .width(14)
              .height(14)
              .borderRadius(7)
              .backgroundColor('#FFFFFF')
              .borderWidth(3)
              .borderColor(APPLE_BLUE);
          }
          .width(14)
          .height(14)
          .position({ x: this.getX(pt.hour) - 7, y: this.getY(pt.ppm) - 7 });
        } else {
          // 普通数据点
          Row()
            .width(4)
            .height(4)
            .borderRadius(2)
            .backgroundColor(APPLE_BLUE)
            .opacity(0.5)
            .position({ x: this.getX(pt.hour) - 2, y: this.getY(pt.ppm) - 2 });
        }
      });

      // 触摸层：点击切换高亮点
      Row()
        .width('100%')
        .height('100%')
        .onClick((event: ClickEvent) => {
          const x = event.x;
          const w = 320;
          const ratio = Math.max(0, Math.min(1, x / w));
          this.co2HighlightHour = Math.round(ratio * 23);
        });
    }
    .width('100%')
    .height(160);
  }

  // 把 CO2 序列转为 Path 命令
  @Builder
  buildCo2Polyline() {
    Path()
      .width('100%')
      .height(160)
      .commands(this.buildCo2PathCmd())
      .stroke(APPLE_BLUE)
      .strokeWidth(2)
      .fillOpacity(0);
  }

  // 生成 Path 命令字符串
  buildCo2PathCmd(): string {
    const max = this.MAX_CO2_PPM;
    let cmds: string[] = [];
    for (let i = 0; i < this.co2Series.length; i++) {
      const pt = this.co2Series[i];
      const x = this.getX(pt.hour);
      const y = this.getY(pt.ppm);
      cmds.push(`${i === 0 ? 'M' : 'L'} ${x.toFixed(1)} ${y.toFixed(1)}`);
    }
    return cmds.join(' ');
  }

  // 折线图坐标计算
  getX(hour: number): number {
    const W = 320;
    return (hour / 24) * W;
  }

  getY(ppm: number): number {
    const H = 160;
    const max = this.MAX_CO2_PPM;
    const min = 0;
    const ratio = (ppm - min) / (max - min);
    return H - ratio * (H - 20) - 10;
  }

  // 环境建议卡
  @Builder
  buildEnvAdviceCard() {
    Row() {
      Stack() {
        SymbolGlyph($r('sys.symbol.leaf'))
          .fontSize(20)
          .fontColor([APPLE_BLUE]);
      }
      .width(36)
      .height(36)
      .borderRadius(18)
      .backgroundColor('#D8ECE2')
      .alignContent(Alignment.Center);

      Column() {
        Text('环境建议')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.TEXT_GRAY_DARK)
          .margin({ bottom: 4 });
        Text('空气质量良好，维持良好通风换气，建议每 2 小时开窗通风 5~10 分钟。')
          .fontSize(14)
          .fontColor(this.TEXT_GRAY_MID)
          .lineHeight(20);
      }
      .layoutWeight(1)
      .margin({ left: 12 })
      .alignItems(HorizontalAlign.Start);

      Text('🪟')
        .fontSize(40)
        .opacity(0.85);
    }
    .width('92%')
    .padding(16)
    .backgroundColor('#F4F8F6')
    .borderRadius(16)
    .alignItems(VerticalAlign.Center)
    .margin({ top: 12 });
  }

  // CO2 提示卡
  @Builder
  buildCo2TipCard() {
    Column() {
      Text('二氧化碳（CO₂）浓度参考')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.TEXT_GRAY_DARK)
        .margin({ bottom: 16 })
        .width('100%');

      Text('400 ~ 600 ppm：空气质量良好，适合办公\n600 ~ 1000 ppm：轻度污染，建议通风\n1000 ppm 以上：空气污浊，易疲劳头痛')
        .fontSize(16)
        .fontColor(this.TEXT_GRAY_MID)
        .lineHeight(24)
        .width('100%');
    }
    .width('85%')
    .padding(20)
    .backgroundColor(Color.White)
    .borderRadius(20)
    .shadow(CARD_SHADOW);
  }

  // ===========================================================
  // ==================== Tab 0：久坐 =============================
  // ===========================================================
  @Builder
  buildSedentaryTab() {
    Column() {
      // 久坐总览大卡
      this.buildSedentaryOverviewCard();
      // 久坐时段分布
      this.buildSedentarySegmentsCard();
      // 久坐健康提醒
      this.buildSedentaryRemindersCard();
    }
    .width('100%')
    .padding({ top: 8 });
  }

  // 久坐总览卡
  @Builder
  buildSedentaryOverviewCard() {
    Column() {
      Row() {
        Column() {
          Text('累计久坐')
            .fontSize(14)
            .fontColor(this.TEXT_GRAY_MID);
          Row({ space: 6 }) {
            Text(Math.floor(this.totalSedentaryMinutes / 60).toString())
              .fontSize(48)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.TEXT_GRAY_DARK);
            Text('小时')
              .fontSize(16)
              .fontColor(this.TEXT_GRAY_MID)
              .margin({ bottom: 8 });
            Text((this.totalSedentaryMinutes % 60).toString())
              .fontSize(48)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.TEXT_GRAY_DARK);
            Text('分')
              .fontSize(16)
              .fontColor(this.TEXT_GRAY_MID)
              .margin({ bottom: 8 });
          }
          .alignItems(VerticalAlign.Bottom)
          .margin({ top: 8 });
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1);

        // 进度环
        Stack({ alignContent: Alignment.Center }) {
          Row()
            .width(96)
            .height(96)
            .borderRadius(48)
            .borderWidth(8)
            .borderColor('#D8ECE2');
          Column() {
            Text(Math.round((this.standUpDone / this.standUpGoal) * 100) + '%')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(APPLE_BLUE);
            Text('完成度')
              .fontSize(11)
              .fontColor(this.TEXT_GRAY_MID);
          }
        }
        .width(96)
        .height(96);
      }
      .width('100%')
      .alignItems(VerticalAlign.Center);

      // 站立次数进度条
      Column() {
        Row() {
          Text('站立次数')
            .fontSize(14)
            .fontColor(this.TEXT_GRAY_MID);
          Blank();
          Text(`${this.standUpDone} / ${this.standUpGoal} 次`)
            .fontSize(14)
            .fontColor(this.TEXT_GRAY_DARK)
            .fontWeight(FontWeight.Medium);
        }
        .width('100%')
        .margin({ top: 16 });

        Stack({ alignContent: Alignment.Start }) {
          Row()
            .width('100%')
            .height(8)
            .backgroundColor('#D8ECE2')
            .borderRadius(4);
          Row()
            .width(`${(this.standUpDone / this.standUpGoal) * 100}%`)
            .height(8)
            .backgroundColor(APPLE_BLUE)
            .borderRadius(4);
        }
        .width('100%')
        .margin({ top: 8 });
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start);
    }
    .width('92%')
    .padding(20)
    .backgroundColor(this.ENV_CARD_BG)
    .borderRadius(20)
    .shadow(CARD_SHADOW)
    .margin({ top: 4 });
  }

  // 久坐时段分布卡
  @Builder
  buildSedentarySegmentsCard() {
    Column() {
      Row() {
        Text('久坐时段')
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.TEXT_GRAY_DARK);
        Blank();
        Text(`最长 ${this.longestStreakMinutes} 分钟`)
          .fontSize(13)
          .fontColor(this.TEXT_GRAY_MID);
      }
      .width('100%')
      .margin({ bottom: 12 });

      ForEach(this.sedentarySegments, (seg: SedentarySegment) => {
        Row() {
          SymbolGlyph($r('sys.symbol.clock'))
            .fontSize(18)
            .fontColor([seg.minutes >= 60 ? APPLE_RED : (seg.minutes >= 45 ? APPLE_ORANGE : APPLE_BLUE)]);
          Text(`${seg.start} - ${seg.end}`)
            .fontSize(15)
            .fontColor(this.TEXT_GRAY_DARK)
            .margin({ left: 10 });
          Blank();
          Text(`${seg.minutes} 分钟`)
            .fontSize(15)
            .fontColor(seg.minutes >= 60 ? APPLE_RED : (seg.minutes >= 45 ? APPLE_ORANGE : APPLE_BLUE))
            .fontWeight(FontWeight.Medium);
        }
        .width('100%')
        .padding({ top: 10, bottom: 10 })
        .alignItems(VerticalAlign.Center);
      });
    }
    .width('92%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(20)
    .shadow(CARD_SHADOW)
    .margin({ top: 12 });
  }

  // 久坐健康提醒
  @Builder
  buildSedentaryRemindersCard() {
    Column() {
      Text('健康提醒')
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.TEXT_GRAY_DARK)
        .width('100%')
        .margin({ bottom: 12 });

      ForEach(this.sedentaryReminders, (item: SedentaryReminder) => {
        Row() {
          Stack() {
            SymbolGlyph(item.glyph)
              .fontSize(20)
              .fontColor([item.tone === 'bad' ? APPLE_RED : (item.tone === 'warn' ? APPLE_ORANGE : APPLE_BLUE)]);
          }
          .width(40)
          .height(40)
          .borderRadius(20)
          .backgroundColor(item.tone === 'bad' ? '#FFEBEB' : (item.tone === 'warn' ? '#FFF1E6' : '#D8ECE2'))
          .alignContent(Alignment.Center);

          Column() {
            Text(item.title)
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.TEXT_GRAY_DARK);
            Text(item.desc)
              .fontSize(13)
              .fontColor(this.TEXT_GRAY_MID)
              .margin({ top: 4 })
              .lineHeight(18);
          }
          .layoutWeight(1)
          .margin({ left: 12 })
          .alignItems(HorizontalAlign.Start);
        }
        .width('100%')
        .padding({ top: 8, bottom: 8 })
        .alignItems(VerticalAlign.Center);
      });
    }
    .width('92%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(20)
    .shadow(CARD_SHADOW)
    .margin({ top: 12 });
  }

  // ===========================================================
  // ==================== Tab 2：报告 分支新增完整日历卡片逻辑 =============================
  // ===========================================================
  @Builder
  report_calendarPopupContent(): void {
    Column() {
      // 顶部：左右切换月份 + 年月标题
      Row() {
        Image($r("sys.media.ohos_ic_public_arrow_left"))
          .width(24)
          .height(24)
          .fillColor('#333')
          .onClick(() => {
            const prev: Date = new Date(this.report_tempSelectDateObj);
            prev.setMonth(prev.getMonth() - 1);
            this.report_tempSelectDateObj = prev;
          })
        Blank()
        Text(`${this.report_tempSelectDateObj.getFullYear()}年${this.report_tempSelectDateObj.getMonth() + 1}月`)
          .fontSize(20)
          .fontColor('#333333')
        Blank()
        Image($r("sys.media.ohos_ic_public_arrow_right"))
          .width(24)
          .height(24)
          .fillColor('#333')
          .onClick(() => {
            const next: Date = new Date(this.report_tempSelectDateObj);
            next.setMonth(next.getMonth() + 1);
            this.report_tempSelectDateObj = next;
          })
      }
      .width('100%')
      .padding({
        left: 12,
        right: 12,
        top: 8,
        bottom: 8
      })

      // 星期表头
      Row() {
        ForEach(WEEK_TITLES, (title: string) => {
          Text(title)
            .fontSize(14)
            .fontColor('#999999')
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
        }, (title: string) => title)
      }
      .width('100%')
      .margin({ bottom: 4 })

      // 日期网格
      Grid() {
        ForEach(this.generateCalendarDays(this.report_tempSelectDateObj), (item: CalendarDay) => {
          GridItem() {
            Column() {
              Text(`${item.day}`)
                .fontSize(16)
                .fontColor(item.isCurrentMonth ? '#333333' : '#cccccc')
              if (this.isSameDay(item.date, new Date()) && item.isCurrentMonth) {
                Circle()
                  .width(4)
                  .height(4)
                  .fill('#239b76')
                  .margin({ top: 2 })
              }
            }
            .width('100%')
            .height(36)
            .justifyContent(FlexAlign.Center)
            .borderRadius(18)
            .backgroundColor(
              this.isSameDay(item.date, this.report_tempSelectDateObj) && item.isCurrentMonth
                ? '#239b76'
                : Color.Transparent
            )
            .onClick(() => {
              if (item.isCurrentMonth) {
                this.report_tempSelectDateObj = new Date(item.date);
              }
            })
          }
        }, (item: CalendarDay) => `${item.date.getTime()}`)
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
      .width('100%')
      .height(216)
      .padding({ left: 4, right: 4 })

      // 底部操作按钮
      Row() {
        Text("今天")
          .fontSize(18)
          .fontColor('#239b76')
          .onClick(() => {
            this.report_tempSelectDateObj = new Date()
          })
        Blank()
        Button("确定", { stateEffect: true })
          .width(120)
          .height(44)
          .fontSize(18)
          .backgroundColor('#239b76')
          .fontColor(Color.White)
          .onClick(() => {
            this.report_selectDateObj = new Date(this.report_tempSelectDateObj)
            // 同步更新主代码全局选中日期，加载对应日数据
            const m = this.report_selectDateObj.getMonth() + 1;
            const d = this.report_selectDateObj.getDate();
            const weekTxt = this.getWeekText(this.report_selectDateObj);
            this.selectDate = `${m}月${d}日 ${weekTxt}`;
            this.selectDateObj = new Date(this.report_selectDateObj);
            this.loadDataForDate(this.selectDate);
            this.showCalendarPopup = false
          })
      }
      .width('100%')
      .padding({
        top: 12,
        left: 8,
        right: 8,
        bottom: 12
      })
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius({ topLeft: 16, topRight: 16 })
  }

  @Builder
  report_HealthScoreCard() {
    Stack() {
      // 底层背景装饰
      Column() {
        Blank()
          .width('100%')
          .height(120)
        Row() {
          Image($r("app.media.publish"))
            .objectFit(ImageFit.Auto)
        }
        .height("100%")
        .width('100%')
        .justifyContent(FlexAlign.End)
        .position({ x: 0, y: -280 })
      }
      .width("100%")
      .padding({ left: 10, right: 10 })
      .borderRadius(16)
      .backgroundColor("#ffffff")
      .margin({
        top: 0,
        bottom: 12
      })
      .hitTestBehavior(HitTestMode.Transparent)

      // 文字内容层
      Column() {
        Row() {
          Column() {
            Row() {
              Text(`${this.report_healthTotalScore}`)
                .fontSize(50)
                .fontWeight(FontWeight.Bold)
                .fontColor("#28a777")
              Text("/100")
                .fontSize(18)
                .fontColor("#999999")
                .margin({ top: 12, left: 4 })
            }
            .width("100%")
            .justifyContent(FlexAlign.Start)
            .margin({ bottom: 5 })

            Text(this.getHealthLevel(this.report_healthTotalScore).text)
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .fontColor("#28a777")
              .margin({ bottom: 5 })
              .width("100%")
              .textAlign(TextAlign.Start)

            Text("今日办公健康总分")
              .fontSize(12)
              .fontColor("#666666")
              .margin({ top: 0 })
              .width("100%")
              .textAlign(TextAlign.Start)
          }
        }
        .width("100%")
        .padding({ left: 20, right: 20 })
        .position({ x: 0, y: -125})
        .zIndex(1)
        .hitTestBehavior(HitTestMode.Transparent)
      }
    }
    .width("100%")
    .margin({ left: '4%', right: '4%' })
    .margin({ top: 100 })
  }

  @Builder
  report_IndicatorItemBuilder(item: ReportIndicatorItem) {
    Row() {
      Image(item.iconRes)
        .width(15)
        .height(20)
        .fillColor("#38a169")
        .margin({ right: 20 })
        .hitTestBehavior(HitTestMode.Block)


      Column() {
        Row() {
          Text(item.label)
            .fontSize(10)
            .fontColor("#222")
          Blank()
          Text(item.valStr)
            .fontSize(10)
            .fontWeight(FontWeight.Medium)
            .fontColor("#333")
        }
        .width("100%")
        .margin({ bottom: 0 })

        Stack() {
          Rect()
            .width("100%")
            .height(6)
            .radius(3)
            .fill("#e8f5ee")
          Row() {
            Rect()
              .width(`${item.progressPercent}%`)
              .height(6)
              .radius(3)
              .fill("#38a169")
          }
          .width("100%")
          .justifyContent(FlexAlign.Start)
        }
        .width("100%")
      }
      .layoutWeight(1)
    }
    .width("100%")
    .margin({ bottom: 24 })
  }

  @Builder
  report_TodaySugest() {
    Stack() {
      // 底层装饰
      Column() {
        Blank()
          .width('100%')
          .height(120)
        Row() {
          Image($r("app.media.background3_1"))
            .objectFit(ImageFit.Auto)
        }
        .height("100%")
        .width('100%')
        .justifyContent(FlexAlign.End)
        .position({ x: 0, y: -325 })
      }
      .width("100%")
      .padding({ left: 10, right: 10 })
      .borderRadius(16)
      .backgroundColor("#ffffff")
      .margin({
        top: 0,
        bottom: 0
      })
      .hitTestBehavior(HitTestMode.Transparent)

      // 内容层
      Column() {
        Row() {
          Text("今日建议")
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 0 })
            .width("100%")
            .textAlign(TextAlign.Start)
        }
        .width("100%")
        .margin({ bottom: 0 })

        Row() {
          Row() {
            Image($r("app.media.report_sugest_1"))
              .width(20)
              .height(20)
              .margin({ right: 6 })
              .hitTestBehavior(HitTestMode.Block)
            Column() {
              Text("适时起身")
                .fontSize(11)
                .fontWeight(FontWeight.Medium)
                .fontColor("#111")
                .width("100%")
                .textAlign(TextAlign.Start)
              Text("每45分钟起身")
                .fontSize(9)
                .fontColor("#666")
                .margin({ top: 2 })
                .width("100%")
                .textAlign(TextAlign.Start)
            }
            .layoutWeight(1)
          }
          .layoutWeight(1)
          .width(0)
          .height(50)
          .padding({
            left: 8,
            right: 8,
            top: 10,
            bottom: 10
          })
          .borderRadius(8)
          .backgroundColor("#f7fbf9")

          Row() {
            Image($r("app.media.report_sugest_2"))
              .width(20)
              .height(20)
              .margin({ right: 6 })
              .hitTestBehavior(HitTestMode.Block)
            Column() {
              Text("开窗通风")
                .fontSize(11)
                .fontWeight(FontWeight.Medium)
                .fontColor("#111")
                .width("100%")
                .textAlign(TextAlign.Start)
              Text("空气湿度适宜")
                .fontSize(9)
                .fontColor("#666")
                .margin({ top: 2 })
                .width("100%")
                .textAlign(TextAlign.Start)
            }
            .layoutWeight(1)
          }
          .layoutWeight(1)
          .width(0)
          .height(50)
          .margin({ left: 6, right: 6 })
          .padding({
            left: 8,
            right: 8,
            top: 10,
            bottom: 10
          })
          .borderRadius(8)
          .backgroundColor("#f7fbf9")

          Row() {
            Image($r("app.media.report_sugest_3"))
              .width(20)
              .height(20)
              .margin({ right: 6 })
              .hitTestBehavior(HitTestMode.Block)
            Column() {
              Text("番茄钟专注")
                .fontSize(11)
                .fontWeight(FontWeight.Medium)
                .fontColor("#111")
                .width("100%")
                .textAlign(TextAlign.Start)
              Text("劳逸结合")
                .fontSize(9)
                .fontColor("#666")
                .margin({ top: 2 })
                .width("100%")
                .textAlign(TextAlign.Start)
            }
            .layoutWeight(1)
          }
          .layoutWeight(1)
          .width(0)
          .height(50)
          .padding({
            left: 8,
            right: 8,
            top: 10,
            bottom: 10
          })
          .borderRadius(8)
          .backgroundColor("#f7fbf9")
        }
        .width("100%")
        .margin({ top: 0 })
      }
      .width("100%")
      .padding({ left: 10, right: 10, top: 0 })
      .position({ x: 0, y: -95 })
      .zIndex(1)
      .hitTestBehavior(HitTestMode.Transparent)
    }
    .width("100%")
    .margin({ left: '4%', right: '4%' })
  }

  @Builder
  report_buildIndicatorCard() {
    Stack() {
      // 底层背景
      Column() {
        Blank()
          .width('100%')
          .height(100)
        Row() {
          Image($r("app.media.background2"))
            .width(600)
            .height(300)
        }
        .height("100%")
        .width('100%')
        .justifyContent(FlexAlign.End)
        .position({ x: 0, y: -310 })
      }
      .width("100%")
      .borderRadius(16)
      .hitTestBehavior(HitTestMode.Transparent)

      // 指标内容
      Column() {
        ForEach(this.report_indicatorDataSource, (item: ReportIndicatorItem) => {
          this.report_IndicatorItemBuilder(item)
        })
      }
      .position({ x: 0, y: -100 })
      .padding({
        left: 20,
        right: 20,
        top: 16,
        bottom: 16
      })
      .zIndex(1)
      .hitTestBehavior(HitTestMode.Transparent)
    }
    .width("100%")
    .padding({
      left: 20,
      right: 20,
      top: 1,
      bottom: 1
    })
    .borderRadius(16)
    .margin({ left: '4%', right: '4%' })
  }

  @Builder
  buildDateSelector() {
    Row() {
      Text(`${this.report_selectDateObj.getMonth() + 1}月${this.report_selectDateObj.getDate()}日`)
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.TEXT_GRAY_DARK)
      Text(this.getWeekText(this.report_selectDateObj))
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.TEXT_GRAY_DARK)
        .margin({ left: 8, right: 6 })
      SymbolGlyph($r('sys.symbol.chevron_down'))
        .fontSize(20)
        .fontColor([this.TEXT_GRAY_MID])
      Blank();
    }
    .width('100%')
    .padding({
      left: '4%',
      right: '4%',
      top:0,
      bottom: 0
    })
    .margin({ bottom: 12 })
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.showCalendarPopup = true;
    })
  }

  @Builder
  report_DailyMessage() {
    Stack() {
      // 底层纯白卡片底板，无装饰图
      Column()
        .width("100%")
        .borderRadius(16)
        .backgroundColor("#ffffff")
        .hitTestBehavior(HitTestMode.Transparent)

      Column() {
        Text("每日寄语")
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor("#333")
          .margin({ bottom: 10 })
          .width("100%")
          .textAlign(TextAlign.Start)

        Text(this.getDailyMessageText())
          .fontSize(15)
          .fontColor("#666666")
          .lineHeight(20)
          .width("100%")
          .textAlign(TextAlign.Start)
      }
      .padding({ left: 20, right: 20, top: 16, bottom: 16 })
      .zIndex(1)
      .hitTestBehavior(HitTestMode.Transparent)
    }
    .width("100%")
    .borderRadius(16)
    .margin({ left: '4%', right: '4%', top: 12 })
    .position({ x: 0, y:600 })
  }

  @Builder
  buildReportTab() {
    Column() {
      this.buildDateSelector();
      this.report_HealthScoreCard()
      this.report_buildIndicatorCard()
      this.report_TodaySugest()
      this.report_DailyMessage()
    }
    .width('100%');
  }
}