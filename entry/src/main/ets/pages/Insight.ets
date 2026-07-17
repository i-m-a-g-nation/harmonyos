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
  private readonly ENV_CARD_BG: string = '#EAF5EF';  // 环境卡浅绿底
  private readonly TAB_UNDERLINE: string = '#3A8F7E';

  // ---------- 顶部 Tab：0=久坐 1=环境 2=报告 ----------
  // 核心修改：从内部私有状态改为父组件双向绑定
  @Link currentTopTab: number;
  private readonly TOP_TABS: string[] = ['久坐', '环境', '报告'];

  // ---------- 报告页数据 ----------
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

  // ==================== 生命周期 ====================
  aboutToAppear() {
    // 初始化模拟数据
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
    if (score >= 90) return { text: '优秀', color: APPLE_BLUE, bgColor: '#E5F0FF' };
    else if (score >= 80) return { text: '良好', color: APPLE_GREEN, bgColor: '#E9F7EC' };
    else if (score >= 60) return { text: '一般', color: APPLE_ORANGE, bgColor: '#FFF1E6' };
    else return { text: '较差', color: APPLE_RED, bgColor: '#FFEBEB' };
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
                .onClick(() => { this.showCo2Tip = false; });
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
              Column()
                .width('100%')
                .height('100%')
                .backgroundColor(BLACK)
                .onClick(() => { this.showCalendarPopup = false; });
              this.buildCalendarDropdown();
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
          .onClick(() => { this.showCalendarPopup = true; });
      }
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 12, bottom: 8 })
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
        .onClick(() => { this.currentTopTab = index; });
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
              .padding({ left: 10, right: 10, top: 4, bottom: 4 })
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
        Text(`${this.co2HighlightHour.toString().padStart(2, '0')}:00  ${this.co2Series[this.co2HighlightHour].ppm} ppm`)
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
      // 坐标：x = hour/24*100, y = 1 - ppm/max
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
          // 简单估算：x 坐标位置决定 hour
          const x = event.x;
          const w = 320; // 估计图表宽
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

  // 折线图坐标计算（基于百分比转 vp）
  // 图表区高度 160，宽度铺满父容器，按比例映射
  getX(hour: number): number {
    // 使用百分比定位时，position 的 x 是 vp
    // 父容器大约 320vp 宽（92% 卡片减去 padding），这里按经验给个近似值
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

        // 进度环（用 Stack 模拟：外圈浅色 + 内圈实色）
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
  // ==================== Tab 2：报告 =============================
  // ===========================================================
  @Builder
  buildDateSelector() {
    Row() {
      Text(this.selectDate)
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.TEXT_GRAY_DARK);
      SymbolGlyph($r('sys.symbol.chevron_down'))
        .fontSize(16)
        .fontColor([this.TEXT_GRAY_MID])
        .margin({ left: 6 });
      Blank();
    }
    .width('92%')
    .padding({ left: 4, right: 4, top: 4, bottom: 8 })
    .alignItems(VerticalAlign.Center)
    .onClick(() => { this.showCalendarPopup = true; });
  }

  @Builder
  buildReportTab() {
    Column() {
      this.buildScoreCard(this.getHealthLevel(this.officeHealthScore));
      this.buildIndicatorContent();
    }
    .width('100%');
  }

  @Builder
  buildCalendarDropdown() {
    Column() {
      Text('选择日期')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.TEXT_GRAY_DARK)
        .margin({ bottom: 16 });

      Column() {
        ForEach(['5月19日 周日', '5月20日 周一', '5月21日 周二', '5月22日 周三'], (date: string) => {
          Row() {
            Text(date)
              .fontSize(18)
              .fontColor(date === this.selectDate ? APPLE_BLUE : this.TEXT_GRAY_DARK)
              .layoutWeight(1);
            if (date === this.selectDate) {
              SymbolGlyph($r('sys.symbol.checkmark'))
                .fontSize(20)
                .fontColor([APPLE_BLUE]);
            }
          }
          .width('100%')
          .padding(14)
          .onClick(() => {
            this.selectDate = date;
            this.loadDataForDate(date);
            this.showCalendarPopup = false;
          });
        });
      }
    }
    .width('90%')
    .padding(20)
    .backgroundColor(Color.White)
    .borderRadius(20)
    .shadow(CARD_SHADOW)
    .margin({ top: 8 });
  }

  @Builder
  buildScoreCard(level: HealthLevel) {
    Column() {
      if (this.hasData) {
        Row() {
          Text(this.officeHealthScore.toString())
            .fontSize(96)
            .fontWeight(FontWeight.Bold)
            .fontColor(APPLE_BLUE);
          Text(`/${this.FULL_SCORE}`)
            .fontSize(32)
            .fontColor(this.TEXT_GRAY_MID);
        }
        .alignItems(VerticalAlign.Bottom);

        Text(level.text)
          .fontSize(28)
          .fontWeight(FontWeight.Medium)
          .fontColor(level.color)
          .margin({ top: 8 });

        Text('今日办公健康总分')
          .fontSize(17)
          .fontColor(this.TEXT_GRAY_MID)
          .margin({ top: 6 });
      } else {
        Text('--')
          .fontSize(96)
          .fontWeight(FontWeight.Bold)
          .fontColor(GRAY_PLACEHOLDER);
        Text('无数据')
          .fontSize(28)
          .fontWeight(FontWeight.Medium)
          .fontColor(GRAY_PLACEHOLDER)
          .margin({ top: 8 });
      }
    }
    .width('92%')
    .padding(24)
    .backgroundColor(this.hasData ? level.bgColor : '#F9F9F9')
    .borderRadius(24)
    .shadow(CARD_SHADOW)
    .margin({ top: 8, bottom: 12 })
    .alignItems(HorizontalAlign.Start);
  }

  @Builder
  buildIndicatorContent() {
    if (this.hasData) {
      Column() {
        Text('健康指标')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.TEXT_GRAY_DARK)
          .width('100%')
          .margin({ bottom: 16 });

        this.buildIndicatorGroup('久坐', APPLE_ORANGE, [
          {
            glyph: $r('sys.symbol.person'),
            label: '久坐时间',
            progress: -1,
            desc: `${Math.floor(this.totalSedentaryMinutes / 60)}小时${this.totalSedentaryMinutes % 60}分`,
            color: APPLE_ORANGE
          },
          {
            glyph: $r('sys.symbol.timer'),
            label: '最长连续久坐',
            progress: -1,
            desc: `${this.maxContinuousSedentaryMinutes} 分钟`,
            color: APPLE_ORANGE
          },
          {
            glyph: $r('sys.symbol.figure_arms_open'),
            label: '站立次数',
            progress: -1,
            desc: `${this.standUpTimes}次`,
            color: APPLE_ORANGE
          }
        ]);

        this.buildEnvironmentCard();

        this.buildIndicatorGroup('专注', APPLE_GREEN, [
          {
            glyph: $r('sys.symbol.leaf'),
            label: '番茄钟数量',
            progress: this.getProgressVal(this.pomodoroCount, this.MAX_POMODORO_NUM),
            desc: `${this.pomodoroCount}个`,
            color: APPLE_GREEN
          },
          {
            glyph: $r('sys.symbol.clock'),
            label: '专注总时长',
            progress: this.getProgressVal(this.totalFocusMinutes, this.MAX_FOCUS_MIN),
            desc: `${this.totalFocusMinutes} 分钟`,
            color: APPLE_GREEN
          }
        ]);

        // 今日建议
        this.buildTodayAdviceCard();
      }
      .width('92%')
      .padding(20)
      .backgroundColor(this.BIG_CARD_BG)
      .borderRadius(20)
      .shadow(CARD_SHADOW);
    } else {
      Column() {
        SymbolGlyph($r('sys.symbol.square_slash'))
          .fontSize(48)
          .fontColor([GRAY_PLACEHOLDER]);
        Text('暂无健康数据')
          .fontSize(18)
          .fontColor(GRAY_PLACEHOLDER)
          .margin({ top: 12 });
      }
      .width('92%')
      .padding(40)
      .backgroundColor(this.BIG_CARD_BG)
      .borderRadius(20)
      .shadow(CARD_SHADOW)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center);
    }
  }

  // 指标分组
  @Builder
  buildIndicatorGroup(title: string, categoryColor: ResourceColor, items: IndicatorParam[]) {
    Column() {
      Text(title)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor(categoryColor)
        .width('100%')
        .margin({ bottom: 12 });
      ForEach(items, (item: IndicatorParam) => {
        this.buildSingleIndicator(item);
      });
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.SMALL_CARD_BG)
    .borderRadius(16)
    .margin({ bottom: 12 });
  }

  // 环境指标卡（报告中复用）
  @Builder
  buildEnvironmentCard() {
    Column() {
      Text('环境')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor(APPLE_BLUE)
        .width('100%')
        .margin({ bottom: 12 });

      Column() {
        Row() {
          SymbolGlyph($r('sys.symbol.cloud'))
            .fontSize(24)
            .fontColor([APPLE_BLUE]);
          Text('CO₂')
            .fontSize(16)
            .fontColor(this.TEXT_GRAY_DARK)
            .margin({ left: 10 });
          Blank();
          Text(`${this.co2Concentration} ppm`)
            .fontSize(16)
            .fontColor(this.TEXT_GRAY_MID);
          SymbolGlyph($r('sys.symbol.questionmark_circle'))
            .fontSize(18)
            .fontColor([APPLE_BLUE])
            .margin({ left: 6 })
            .onClick(() => { this.showCo2Tip = true; });
        }
        .alignItems(VerticalAlign.Center)
        .width('100%');

        Stack({ alignContent: Alignment.Start }) {
          Row()
            .width('100%')
            .height(6)
            .backgroundColor(this.DIVIDER_COLOR)
            .borderRadius(3);
          Row()
            .width(`${this.getProgressVal(this.co2Concentration, this.MAX_CO2_PPM)}%`)
            .height(6)
            .backgroundColor(APPLE_BLUE)
            .borderRadius(3);
        }
        .width('100%')
        .margin({ top: 10 });
      }
      .width('100%')
      .padding({ top: 8, bottom: 12 });

      this.buildSingleIndicator({
        glyph: $r('sys.symbol.thermometer'),
        label: '温度 / 湿度',
        progress: -1,
        desc: `${this.temperature}℃ / ${this.humidity}%`,
        color: APPLE_BLUE
      });
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.SMALL_CARD_BG)
    .borderRadius(16)
    .margin({ bottom: 12 });
  }

  // 单条指标
  @Builder
  buildSingleIndicator(params: IndicatorParam) {
    Column() {
      Row() {
        SymbolGlyph(params.glyph)
          .fontSize(24)
          .fontColor([params.color]);
        Text(params.label)
          .fontSize(16)
          .fontColor(this.TEXT_GRAY_DARK)
          .margin({ left: 10 });
        Blank();
        Text(params.desc)
          .fontSize(16)
          .fontColor(this.TEXT_GRAY_MID);
      }
      .alignItems(VerticalAlign.Center);

      if (params.progress >= 0) {
        Stack({ alignContent: Alignment.Start }) {
          Row()
            .width('100%')
            .height(6)
            .backgroundColor(this.DIVIDER_COLOR)
            .borderRadius(3);
          Row()
            .width(`${params.progress}%`)
            .height(6)
            .backgroundColor(params.color)
            .borderRadius(3);
        }
        .width('100%')
        .margin({ top: 10 });
      }
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 });
  }

  // 今日建议（三张并排小卡）
  @Builder
  buildTodayAdviceCard() {
    Column() {
      Text('今日建议')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.TEXT_GRAY_DARK)
        .width('100%')
        .margin({ bottom: 12 });

      Row({ space: 10 }) {
        this.buildAdviceMiniCard($r('sys.symbol.figure_arms_open'), '适时起身', '每 45 分钟起身');
        this.buildAdviceMiniCard($r('sys.symbol.leaf'), '保持通风', '空气湿度适宜');
        this.buildAdviceMiniCard($r('sys.symbol.circle'), '专注节奏', '劳逸结合');
      }
      .width('100%');
    }
    .width('100%')
    .margin({ top: 4 });
  }

  @Builder
  buildAdviceMiniCard(glyph: Resource, title: string, desc: string) {
    Column() {
      SymbolGlyph(glyph)
        .fontSize(22)
        .fontColor([APPLE_BLUE]);
      Text(title)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.TEXT_GRAY_DARK)
        .margin({ top: 8 });
      Text(desc)
        .fontSize(11)
        .fontColor(this.TEXT_GRAY_MID)
        .margin({ top: 2 })
        .textAlign(TextAlign.Center);
    }
    .layoutWeight(1)
    .padding({ top: 14, bottom: 14 })
    .backgroundColor(this.SMALL_CARD_BG)
    .borderRadius(14)
    .alignItems(HorizontalAlign.Center);
  }
}