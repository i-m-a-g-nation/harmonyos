if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Insight_Params {
    COLOR_PAGE_BG?: string;
    TEXT_GRAY_MID?: string;
    TEXT_GRAY_DARK?: string;
    DIVIDER_COLOR?: string;
    BIG_CARD_BG?: string;
    SMALL_CARD_BG?: string;
    ENV_CARD_BG?: string;
    TAB_UNDERLINE?: string;
    currentTopTab?: number;
    TOP_TABS?: string[];
    officeHealthScore?: number;
    FULL_SCORE?: number;
    totalSedentaryMinutes?: number;
    maxContinuousSedentaryMinutes?: number;
    standUpTimes?: number;
    co2Concentration?: number;
    temperature?: number;
    humidity?: number;
    pomodoroCount?: number;
    totalFocusMinutes?: number;
    showCalendarPopup?: boolean;
    selectDate?: string;
    showCo2Tip?: boolean;
    hasData?: boolean;
    dailyDataMap?: Map<string, DailyData>;
    co2Series?: Co2Point[];
    co2HighlightHour?: number;
    sedentarySegments?: SedentarySegment[];
    longestStreakMinutes?: number;
    standUpGoal?: number;
    standUpDone?: number;
    sedentaryReminders?: SedentaryReminder[];
    MAX_CO2_PPM?: number;
    MAX_POMODORO_NUM?: number;
    MAX_FOCUS_MIN?: number;
}
// Insight.ets
// 洞察页面：整合 久坐 / 环境 / 报告 三个 Tab
// 参考设计稿：iOS 风格绿色主题卡片
// Insight 作为子组件嵌入 Index，不再需要 router 和独立 BottomTabBar
// ==================== 类型定义 ====================
interface IndicatorParam {
    glyph: Resource;
    label: string;
    progress: number;
    desc: string;
    color: ResourceColor;
}
interface HealthLevel {
    text: string;
    color: string;
    bgColor: string;
}
interface ShadowOpt {
    radius: number;
    color: string;
    offsetX?: number;
    offsetY?: number;
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
    hour: number;
    ppm: number;
}
interface SedentarySegment {
    start: string; // "09:10"
    end: string; // "10:42"
    minutes: number; // 92
}
interface SedentaryReminder {
    glyph: Resource;
    title: string;
    desc: string;
    tone: 'good' | 'warn' | 'bad';
}
// ==================== 颜色常量 ====================
const APPLE_BG = '#F7F8FA';
const APPLE_BLUE = '#3A8F7E'; // 主题绿色（与 BottomTabBar 保持一致）
const APPLE_GREEN = '#34C759';
const APPLE_ORANGE = '#FF9500';
const APPLE_RED = '#FF3B30';
const GRAY_PLACEHOLDER = '#C7C7CC';
const BLACK = '#33000000';
const CARD_SHADOW: ShadowOpt = { radius: 16, color: '#1A000000', offsetY: 4 };
export class Insight extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.COLOR_PAGE_BG = APPLE_BG;
        this.TEXT_GRAY_MID = '#8E8E93';
        this.TEXT_GRAY_DARK = '#1C1C1E';
        this.DIVIDER_COLOR = '#E5E5EA';
        this.BIG_CARD_BG = '#FFFFFF';
        this.SMALL_CARD_BG = '#F4F6F5';
        this.ENV_CARD_BG = '#EAF5EF';
        this.TAB_UNDERLINE = '#3A8F7E';
        this.__currentTopTab = new SynchedPropertySimpleTwoWayPU(params.currentTopTab, this, "currentTopTab");
        this.TOP_TABS = ['久坐', '环境', '报告'];
        this.__officeHealthScore = new ObservedPropertySimplePU(86, this, "officeHealthScore");
        this.FULL_SCORE = 100;
        this.__totalSedentaryMinutes = new ObservedPropertySimplePU(252, this, "totalSedentaryMinutes");
        this.__maxContinuousSedentaryMinutes = new ObservedPropertySimplePU(48, this, "maxContinuousSedentaryMinutes");
        this.__standUpTimes = new ObservedPropertySimplePU(6, this, "standUpTimes");
        this.__co2Concentration = new ObservedPropertySimplePU(420, this, "co2Concentration");
        this.__temperature = new ObservedPropertySimplePU(24.6, this, "temperature");
        this.__humidity = new ObservedPropertySimplePU(48, this, "humidity");
        this.__pomodoroCount = new ObservedPropertySimplePU(6, this, "pomodoroCount");
        this.__totalFocusMinutes = new ObservedPropertySimplePU(150, this, "totalFocusMinutes");
        this.__showCalendarPopup = new ObservedPropertySimplePU(false, this, "showCalendarPopup");
        this.__selectDate = new ObservedPropertySimplePU('5月20日 周一', this, "selectDate");
        this.__showCo2Tip = new ObservedPropertySimplePU(false, this, "showCo2Tip");
        this.__hasData = new ObservedPropertySimplePU(true, this, "hasData");
        this.dailyDataMap = new Map();
        this.__co2Series = new ObservedPropertyObjectPU([
            { hour: 0, ppm: 410 }, { hour: 1, ppm: 420 }, { hour: 2, ppm: 430 },
            { hour: 3, ppm: 440 }, { hour: 4, ppm: 430 }, { hour: 5, ppm: 420 },
            { hour: 6, ppm: 410 }, { hour: 7, ppm: 400 }, { hour: 8, ppm: 410 },
            { hour: 9, ppm: 420 }, { hour: 10, ppm: 460 }, { hour: 11, ppm: 520 },
            { hour: 12, ppm: 580 }, { hour: 13, ppm: 620 }, { hour: 14, ppm: 600 },
            { hour: 15, ppm: 540 }, { hour: 16, ppm: 500 }, { hour: 17, ppm: 480 },
            { hour: 18, ppm: 470 }, { hour: 19, ppm: 460 }, { hour: 20, ppm: 450 },
            { hour: 21, ppm: 440 }, { hour: 22, ppm: 430 }, { hour: 23, ppm: 420 }
        ], this, "co2Series");
        this.__co2HighlightHour = new ObservedPropertySimplePU(9, this, "co2HighlightHour");
        this.__sedentarySegments = new ObservedPropertyObjectPU([
            { start: '09:10', end: '10:42', minutes: 92 },
            { start: '11:05', end: '12:30', minutes: 85 },
            { start: '14:00', end: '15:25', minutes: 85 },
            { start: '15:40', end: '16:18', minutes: 38 }
        ], this, "sedentarySegments");
        this.__longestStreakMinutes = new ObservedPropertySimplePU(92, this, "longestStreakMinutes");
        this.__standUpGoal = new ObservedPropertySimplePU(8, this, "standUpGoal");
        this.__standUpDone = new ObservedPropertySimplePU(6, this, "standUpDone");
        this.sedentaryReminders = [
            {
                glyph: { "id": 125832158, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                title: '起身活动',
                desc: '已连续久坐 92 分钟，建议立刻起身活动 2~3 分钟',
                tone: 'bad'
            },
            {
                glyph: { "id": 125832304, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                title: '番茄提醒',
                desc: '距离下一个番茄钟还剩 8 分钟',
                tone: 'good'
            },
            {
                glyph: { "id": 125832271, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                title: '颈椎放松',
                desc: '每 45 分钟做一组颈部拉伸，缓解久坐疲劳',
                tone: 'warn'
            }
        ];
        this.MAX_CO2_PPM = 1200;
        this.MAX_POMODORO_NUM = 10;
        this.MAX_FOCUS_MIN = 240;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Insight_Params) {
        if (params.COLOR_PAGE_BG !== undefined) {
            this.COLOR_PAGE_BG = params.COLOR_PAGE_BG;
        }
        if (params.TEXT_GRAY_MID !== undefined) {
            this.TEXT_GRAY_MID = params.TEXT_GRAY_MID;
        }
        if (params.TEXT_GRAY_DARK !== undefined) {
            this.TEXT_GRAY_DARK = params.TEXT_GRAY_DARK;
        }
        if (params.DIVIDER_COLOR !== undefined) {
            this.DIVIDER_COLOR = params.DIVIDER_COLOR;
        }
        if (params.BIG_CARD_BG !== undefined) {
            this.BIG_CARD_BG = params.BIG_CARD_BG;
        }
        if (params.SMALL_CARD_BG !== undefined) {
            this.SMALL_CARD_BG = params.SMALL_CARD_BG;
        }
        if (params.ENV_CARD_BG !== undefined) {
            this.ENV_CARD_BG = params.ENV_CARD_BG;
        }
        if (params.TAB_UNDERLINE !== undefined) {
            this.TAB_UNDERLINE = params.TAB_UNDERLINE;
        }
        if (params.TOP_TABS !== undefined) {
            this.TOP_TABS = params.TOP_TABS;
        }
        if (params.officeHealthScore !== undefined) {
            this.officeHealthScore = params.officeHealthScore;
        }
        if (params.FULL_SCORE !== undefined) {
            this.FULL_SCORE = params.FULL_SCORE;
        }
        if (params.totalSedentaryMinutes !== undefined) {
            this.totalSedentaryMinutes = params.totalSedentaryMinutes;
        }
        if (params.maxContinuousSedentaryMinutes !== undefined) {
            this.maxContinuousSedentaryMinutes = params.maxContinuousSedentaryMinutes;
        }
        if (params.standUpTimes !== undefined) {
            this.standUpTimes = params.standUpTimes;
        }
        if (params.co2Concentration !== undefined) {
            this.co2Concentration = params.co2Concentration;
        }
        if (params.temperature !== undefined) {
            this.temperature = params.temperature;
        }
        if (params.humidity !== undefined) {
            this.humidity = params.humidity;
        }
        if (params.pomodoroCount !== undefined) {
            this.pomodoroCount = params.pomodoroCount;
        }
        if (params.totalFocusMinutes !== undefined) {
            this.totalFocusMinutes = params.totalFocusMinutes;
        }
        if (params.showCalendarPopup !== undefined) {
            this.showCalendarPopup = params.showCalendarPopup;
        }
        if (params.selectDate !== undefined) {
            this.selectDate = params.selectDate;
        }
        if (params.showCo2Tip !== undefined) {
            this.showCo2Tip = params.showCo2Tip;
        }
        if (params.hasData !== undefined) {
            this.hasData = params.hasData;
        }
        if (params.dailyDataMap !== undefined) {
            this.dailyDataMap = params.dailyDataMap;
        }
        if (params.co2Series !== undefined) {
            this.co2Series = params.co2Series;
        }
        if (params.co2HighlightHour !== undefined) {
            this.co2HighlightHour = params.co2HighlightHour;
        }
        if (params.sedentarySegments !== undefined) {
            this.sedentarySegments = params.sedentarySegments;
        }
        if (params.longestStreakMinutes !== undefined) {
            this.longestStreakMinutes = params.longestStreakMinutes;
        }
        if (params.standUpGoal !== undefined) {
            this.standUpGoal = params.standUpGoal;
        }
        if (params.standUpDone !== undefined) {
            this.standUpDone = params.standUpDone;
        }
        if (params.sedentaryReminders !== undefined) {
            this.sedentaryReminders = params.sedentaryReminders;
        }
        if (params.MAX_CO2_PPM !== undefined) {
            this.MAX_CO2_PPM = params.MAX_CO2_PPM;
        }
        if (params.MAX_POMODORO_NUM !== undefined) {
            this.MAX_POMODORO_NUM = params.MAX_POMODORO_NUM;
        }
        if (params.MAX_FOCUS_MIN !== undefined) {
            this.MAX_FOCUS_MIN = params.MAX_FOCUS_MIN;
        }
    }
    updateStateVars(params: Insight_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__currentTopTab.purgeDependencyOnElmtId(rmElmtId);
        this.__officeHealthScore.purgeDependencyOnElmtId(rmElmtId);
        this.__totalSedentaryMinutes.purgeDependencyOnElmtId(rmElmtId);
        this.__maxContinuousSedentaryMinutes.purgeDependencyOnElmtId(rmElmtId);
        this.__standUpTimes.purgeDependencyOnElmtId(rmElmtId);
        this.__co2Concentration.purgeDependencyOnElmtId(rmElmtId);
        this.__temperature.purgeDependencyOnElmtId(rmElmtId);
        this.__humidity.purgeDependencyOnElmtId(rmElmtId);
        this.__pomodoroCount.purgeDependencyOnElmtId(rmElmtId);
        this.__totalFocusMinutes.purgeDependencyOnElmtId(rmElmtId);
        this.__showCalendarPopup.purgeDependencyOnElmtId(rmElmtId);
        this.__selectDate.purgeDependencyOnElmtId(rmElmtId);
        this.__showCo2Tip.purgeDependencyOnElmtId(rmElmtId);
        this.__hasData.purgeDependencyOnElmtId(rmElmtId);
        this.__co2Series.purgeDependencyOnElmtId(rmElmtId);
        this.__co2HighlightHour.purgeDependencyOnElmtId(rmElmtId);
        this.__sedentarySegments.purgeDependencyOnElmtId(rmElmtId);
        this.__longestStreakMinutes.purgeDependencyOnElmtId(rmElmtId);
        this.__standUpGoal.purgeDependencyOnElmtId(rmElmtId);
        this.__standUpDone.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__currentTopTab.aboutToBeDeleted();
        this.__officeHealthScore.aboutToBeDeleted();
        this.__totalSedentaryMinutes.aboutToBeDeleted();
        this.__maxContinuousSedentaryMinutes.aboutToBeDeleted();
        this.__standUpTimes.aboutToBeDeleted();
        this.__co2Concentration.aboutToBeDeleted();
        this.__temperature.aboutToBeDeleted();
        this.__humidity.aboutToBeDeleted();
        this.__pomodoroCount.aboutToBeDeleted();
        this.__totalFocusMinutes.aboutToBeDeleted();
        this.__showCalendarPopup.aboutToBeDeleted();
        this.__selectDate.aboutToBeDeleted();
        this.__showCo2Tip.aboutToBeDeleted();
        this.__hasData.aboutToBeDeleted();
        this.__co2Series.aboutToBeDeleted();
        this.__co2HighlightHour.aboutToBeDeleted();
        this.__sedentarySegments.aboutToBeDeleted();
        this.__longestStreakMinutes.aboutToBeDeleted();
        this.__standUpGoal.aboutToBeDeleted();
        this.__standUpDone.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // ---------- 主题色 ----------
    private readonly COLOR_PAGE_BG: string;
    private readonly TEXT_GRAY_MID: string;
    private readonly TEXT_GRAY_DARK: string;
    private readonly DIVIDER_COLOR: string;
    private readonly BIG_CARD_BG: string;
    private readonly SMALL_CARD_BG: string;
    private readonly ENV_CARD_BG: string; // 环境卡浅绿底
    private readonly TAB_UNDERLINE: string;
    // ---------- 顶部 Tab：0=久坐 1=环境 2=报告 ----------
    // 核心修改：从内部私有状态改为父组件双向绑定
    private __currentTopTab: SynchedPropertySimpleTwoWayPU<number>;
    get currentTopTab() {
        return this.__currentTopTab.get();
    }
    set currentTopTab(newValue: number) {
        this.__currentTopTab.set(newValue);
    }
    private readonly TOP_TABS: string[];
    // ---------- 报告页数据 ----------
    private __officeHealthScore: ObservedPropertySimplePU<number>;
    get officeHealthScore() {
        return this.__officeHealthScore.get();
    }
    set officeHealthScore(newValue: number) {
        this.__officeHealthScore.set(newValue);
    }
    private readonly FULL_SCORE: number;
    private __totalSedentaryMinutes: ObservedPropertySimplePU<number>;
    get totalSedentaryMinutes() {
        return this.__totalSedentaryMinutes.get();
    }
    set totalSedentaryMinutes(newValue: number) {
        this.__totalSedentaryMinutes.set(newValue);
    }
    private __maxContinuousSedentaryMinutes: ObservedPropertySimplePU<number>;
    get maxContinuousSedentaryMinutes() {
        return this.__maxContinuousSedentaryMinutes.get();
    }
    set maxContinuousSedentaryMinutes(newValue: number) {
        this.__maxContinuousSedentaryMinutes.set(newValue);
    }
    private __standUpTimes: ObservedPropertySimplePU<number>;
    get standUpTimes() {
        return this.__standUpTimes.get();
    }
    set standUpTimes(newValue: number) {
        this.__standUpTimes.set(newValue);
    }
    private __co2Concentration: ObservedPropertySimplePU<number>;
    get co2Concentration() {
        return this.__co2Concentration.get();
    }
    set co2Concentration(newValue: number) {
        this.__co2Concentration.set(newValue);
    }
    private __temperature: ObservedPropertySimplePU<number>;
    get temperature() {
        return this.__temperature.get();
    }
    set temperature(newValue: number) {
        this.__temperature.set(newValue);
    }
    private __humidity: ObservedPropertySimplePU<number>;
    get humidity() {
        return this.__humidity.get();
    }
    set humidity(newValue: number) {
        this.__humidity.set(newValue);
    }
    private __pomodoroCount: ObservedPropertySimplePU<number>;
    get pomodoroCount() {
        return this.__pomodoroCount.get();
    }
    set pomodoroCount(newValue: number) {
        this.__pomodoroCount.set(newValue);
    }
    private __totalFocusMinutes: ObservedPropertySimplePU<number>;
    get totalFocusMinutes() {
        return this.__totalFocusMinutes.get();
    }
    set totalFocusMinutes(newValue: number) {
        this.__totalFocusMinutes.set(newValue);
    }
    private __showCalendarPopup: ObservedPropertySimplePU<boolean>;
    get showCalendarPopup() {
        return this.__showCalendarPopup.get();
    }
    set showCalendarPopup(newValue: boolean) {
        this.__showCalendarPopup.set(newValue);
    }
    private __selectDate: ObservedPropertySimplePU<string>;
    get selectDate() {
        return this.__selectDate.get();
    }
    set selectDate(newValue: string) {
        this.__selectDate.set(newValue);
    }
    private __showCo2Tip: ObservedPropertySimplePU<boolean>;
    get showCo2Tip() {
        return this.__showCo2Tip.get();
    }
    set showCo2Tip(newValue: boolean) {
        this.__showCo2Tip.set(newValue);
    }
    private __hasData: ObservedPropertySimplePU<boolean>;
    get hasData() {
        return this.__hasData.get();
    }
    set hasData(newValue: boolean) {
        this.__hasData.set(newValue);
    }
    private dailyDataMap: Map<string, DailyData>;
    // ---------- 环境 Tab 24h 折线图数据 ----------
    private __co2Series: ObservedPropertyObjectPU<Co2Point[]>;
    get co2Series() {
        return this.__co2Series.get();
    }
    set co2Series(newValue: Co2Point[]) {
        this.__co2Series.set(newValue);
    }
    private __co2HighlightHour: ObservedPropertySimplePU<number>;
    get co2HighlightHour() {
        return this.__co2HighlightHour.get();
    }
    set co2HighlightHour(newValue: number) {
        this.__co2HighlightHour.set(newValue);
    }
    // ---------- 久坐 Tab 模拟数据 ----------
    private __sedentarySegments: ObservedPropertyObjectPU<SedentarySegment[]>;
    get sedentarySegments() {
        return this.__sedentarySegments.get();
    }
    set sedentarySegments(newValue: SedentarySegment[]) {
        this.__sedentarySegments.set(newValue);
    }
    private __longestStreakMinutes: ObservedPropertySimplePU<number>;
    get longestStreakMinutes() {
        return this.__longestStreakMinutes.get();
    }
    set longestStreakMinutes(newValue: number) {
        this.__longestStreakMinutes.set(newValue);
    }
    private __standUpGoal: ObservedPropertySimplePU<number>;
    get standUpGoal() {
        return this.__standUpGoal.get();
    }
    set standUpGoal(newValue: number) {
        this.__standUpGoal.set(newValue);
    }
    private __standUpDone: ObservedPropertySimplePU<number>;
    get standUpDone() {
        return this.__standUpDone.get();
    }
    set standUpDone(newValue: number) {
        this.__standUpDone.set(newValue);
    }
    private sedentaryReminders: SedentaryReminder[];
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
        }
        else {
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
        if (!this.hasData)
            return -1;
        return Math.min(Math.floor(value / max * 100), 100);
    }
    getHealthLevel(score: number): HealthLevel {
        if (!this.hasData) {
            return { text: '无数据', color: GRAY_PLACEHOLDER, bgColor: '#F9F9F9' };
        }
        if (score >= 90)
            return { text: '优秀', color: APPLE_BLUE, bgColor: '#E5F0FF' };
        else if (score >= 80)
            return { text: '良好', color: APPLE_GREEN, bgColor: '#E9F7EC' };
        else if (score >= 60)
            return { text: '一般', color: APPLE_ORANGE, bgColor: '#FFF1E6' };
        else
            return { text: '较差', color: APPLE_RED, bgColor: '#FFEBEB' };
    }
    getCo2Level(ppm: number): HealthLevel {
        if (ppm <= 600)
            return { text: '优', color: '#FFFFFF', bgColor: '#3A8F7E' };
        if (ppm <= 1000)
            return { text: '良', color: '#FFFFFF', bgColor: '#7BC47F' };
        if (ppm <= 1500)
            return { text: '差', color: '#FFFFFF', bgColor: '#FF9500' };
        return { text: '差', color: '#FFFFFF', bgColor: '#FF3B30' };
    }
    getCo2Comment(ppm: number): string {
        if (ppm <= 600)
            return '空气质量优';
        if (ppm <= 1000)
            return '空气质量良';
        if (ppm <= 1500)
            return '建议通风';
        return '空气污浊';
    }
    private readonly MAX_CO2_PPM: number;
    private readonly MAX_POMODORO_NUM: number;
    private readonly MAX_FOCUS_MIN: number;
    // ==================== 页面构建 ====================
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(243:5)", "entry");
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor(this.COLOR_PAGE_BG);
        }, Column);
        this.buildTopHeader.bind(this)();
        this.buildTopTabs.bind(this)();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create();
            Stack.debugLine("entry/src/main/ets/pages/Insight.ets(247:7)", "entry");
            Stack.layoutWeight(1);
            Stack.width('100%');
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            // 内容滚动区
            if (this.currentTopTab === 0) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Scroll.create();
                        Scroll.debugLine("entry/src/main/ets/pages/Insight.ets(250:11)", "entry");
                        Scroll.scrollable(ScrollDirection.Vertical);
                        Scroll.scrollBar(BarState.Auto);
                        Scroll.width('100%');
                        Scroll.height('100%');
                    }, Scroll);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.debugLine("entry/src/main/ets/pages/Insight.ets(251:13)", "entry");
                        Column.width('100%');
                        Column.padding({ bottom: 20 });
                    }, Column);
                    this.buildSedentaryTab.bind(this)();
                    Column.pop();
                    Scroll.pop();
                });
            }
            else if (this.currentTopTab === 1) {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Stack.create();
                        Stack.debugLine("entry/src/main/ets/pages/Insight.ets(262:11)", "entry");
                        Stack.layoutWeight(1);
                        Stack.width('100%');
                    }, Stack);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Scroll.create();
                        Scroll.debugLine("entry/src/main/ets/pages/Insight.ets(263:13)", "entry");
                        Scroll.scrollable(ScrollDirection.Vertical);
                        Scroll.scrollBar(BarState.Auto);
                        Scroll.width('100%');
                        Scroll.height('100%');
                    }, Scroll);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.debugLine("entry/src/main/ets/pages/Insight.ets(264:15)", "entry");
                        Column.width('100%');
                        Column.padding({ bottom: 20 });
                    }, Column);
                    this.buildEnvironmentTab.bind(this)();
                    Column.pop();
                    Scroll.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        If.create();
                        if (this.showCo2Tip) {
                            this.ifElseBranchUpdateFunction(0, () => {
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    Column.create();
                                    Column.debugLine("entry/src/main/ets/pages/Insight.ets(276:15)", "entry");
                                    Column.width('100%');
                                    Column.height('100%');
                                    Column.backgroundColor(BLACK);
                                    Column.onClick(() => { this.showCo2Tip = false; });
                                }, Column);
                                Column.pop();
                                this.buildCo2TipCard.bind(this)();
                            });
                        }
                        else {
                            this.ifElseBranchUpdateFunction(1, () => {
                            });
                        }
                    }, If);
                    If.pop();
                    Stack.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(2, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Stack.create();
                        Stack.debugLine("entry/src/main/ets/pages/Insight.ets(287:11)", "entry");
                        Stack.layoutWeight(1);
                        Stack.width('100%');
                    }, Stack);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Scroll.create();
                        Scroll.debugLine("entry/src/main/ets/pages/Insight.ets(288:13)", "entry");
                        Scroll.scrollable(ScrollDirection.Vertical);
                        Scroll.scrollBar(BarState.Auto);
                        Scroll.width('100%');
                        Scroll.height('100%');
                    }, Scroll);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.debugLine("entry/src/main/ets/pages/Insight.ets(289:15)", "entry");
                        Column.width('100%');
                        Column.padding({ bottom: 20 });
                    }, Column);
                    this.buildDateSelector.bind(this)();
                    this.buildReportTab.bind(this)();
                    Column.pop();
                    Scroll.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        If.create();
                        if (this.showCalendarPopup) {
                            this.ifElseBranchUpdateFunction(0, () => {
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    Column.create();
                                    Column.debugLine("entry/src/main/ets/pages/Insight.ets(302:15)", "entry");
                                    Column.width('100%');
                                    Column.height('100%');
                                    Column.backgroundColor(BLACK);
                                    Column.onClick(() => { this.showCalendarPopup = false; });
                                }, Column);
                                Column.pop();
                                this.buildCalendarDropdown.bind(this)();
                            });
                        }
                        else {
                            this.ifElseBranchUpdateFunction(1, () => {
                            });
                        }
                    }, If);
                    If.pop();
                    Stack.pop();
                });
            }
        }, If);
        If.pop();
        Stack.pop();
        Column.pop();
    }
    // ==================== 顶部标题栏 ====================
    buildTopHeader(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(325:5)", "entry");
            Row.width('100%');
            Row.padding({ left: 20, right: 20, top: 12, bottom: 8 });
            Row.alignItems(VerticalAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('洞察');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(326:7)", "entry");
            Text.fontSize(32);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor(this.TEXT_GRAY_DARK);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/pages/Insight.ets(330:7)", "entry");
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.currentTopTab === 2) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        SymbolGlyph.create({ "id": 125832312, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
                        SymbolGlyph.debugLine("entry/src/main/ets/pages/Insight.ets(332:9)", "entry");
                        SymbolGlyph.fontSize(22);
                        SymbolGlyph.fontColor([APPLE_BLUE]);
                        SymbolGlyph.onClick(() => { this.showCalendarPopup = true; });
                    }, SymbolGlyph);
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        Row.pop();
    }
    // ==================== 顶部 Tab 切换栏 ====================
    buildTopTabs(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(346:5)", "entry");
            Row.width('100%');
            Row.padding({ left: 20, right: 20, bottom: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = (_item, index: number) => {
                const tab = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.debugLine("entry/src/main/ets/pages/Insight.ets(348:9)", "entry");
                    Column.layoutWeight(1);
                    Column.padding({ top: 8, bottom: 8 });
                    Column.alignItems(HorizontalAlign.Center);
                    Column.onClick(() => { this.currentTopTab = index; });
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(tab);
                    Text.debugLine("entry/src/main/ets/pages/Insight.ets(349:11)", "entry");
                    Text.fontSize(18);
                    Text.fontWeight(this.currentTopTab === index ? FontWeight.Medium : FontWeight.Normal);
                    Text.fontColor(this.currentTopTab === index ? this.TEXT_GRAY_DARK : this.TEXT_GRAY_MID);
                }, Text);
                Text.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    // 选中时显示绿色下划线
                    Row.create();
                    Row.debugLine("entry/src/main/ets/pages/Insight.ets(354:11)", "entry");
                    // 选中时显示绿色下划线
                    Row.width(this.currentTopTab === index ? 24 : 0);
                    // 选中时显示绿色下划线
                    Row.height(3);
                    // 选中时显示绿色下划线
                    Row.backgroundColor(this.TAB_UNDERLINE);
                    // 选中时显示绿色下划线
                    Row.borderRadius(1.5);
                    // 选中时显示绿色下划线
                    Row.margin({ top: 6 });
                }, Row);
                // 选中时显示绿色下划线
                Row.pop();
                Column.pop();
            };
            this.forEachUpdateFunction(elmtId, this.TOP_TABS, forEachItemGenFunction, undefined, true, false);
        }, ForEach);
        ForEach.pop();
        Row.pop();
    }
    // ===========================================================
    // ==================== Tab 1：环境 =============================
    // ===========================================================
    buildEnvironmentTab(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(376:5)", "entry");
            Column.width('100%');
            Column.padding({ top: 8 });
        }, Column);
        // ----- 当前 CO₂ 大卡 -----
        this.buildEnvCo2Card.bind(this)();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // ----- 温湿度并排双卡 -----
            Row.create({ space: 12 });
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(380:7)", "entry");
            // ----- 温湿度并排双卡 -----
            Row.width('92%');
            // ----- 温湿度并排双卡 -----
            Row.margin({ top: 12 });
        }, Row);
        this.buildEnvMetricCard.bind(this)('温度', this.temperature.toFixed(1) + '℃', { "id": 125832642, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
        this.buildEnvMetricCard.bind(this)('湿度', this.humidity + '%', { "id": 125831678, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
        // ----- 温湿度并排双卡 -----
        Row.pop();
        // ----- 24h CO₂ 趋势 -----
        this.buildEnvTrendCard.bind(this)();
        // ----- 环境建议 -----
        this.buildEnvAdviceCard.bind(this)();
        Column.pop();
    }
    // 当前 CO2 大卡
    buildEnvCo2Card(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(398:5)", "entry");
            Column.width('92%');
            Column.padding(20);
            Column.backgroundColor(this.ENV_CARD_BG);
            Column.borderRadius(20);
            Column.shadow(CARD_SHADOW);
            Column.margin({ top: 4 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(399:7)", "entry");
            Row.width('100%');
            Row.alignItems(VerticalAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(400:9)", "entry");
            Column.alignItems(HorizontalAlign.Start);
            Column.layoutWeight(1);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('当前 CO₂');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(401:11)", "entry");
            Text.fontSize(14);
            Text.fontColor(this.TEXT_GRAY_MID);
            Text.margin({ bottom: 8 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 8 });
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(406:11)", "entry");
            Row.alignItems(VerticalAlign.Bottom);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.co2Concentration.toString());
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(407:13)", "entry");
            Text.fontSize(56);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor(this.TEXT_GRAY_DARK);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('ppm');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(411:13)", "entry");
            Text.fontSize(20);
            Text.fontColor(this.TEXT_GRAY_MID);
            Text.margin({ bottom: 12 });
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 8 });
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(418:11)", "entry");
            Row.margin({ top: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.getCo2Level(this.co2Concentration).text);
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(419:13)", "entry");
            Text.fontSize(13);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor(this.getCo2Level(this.co2Concentration).color);
            Text.backgroundColor(this.getCo2Level(this.co2Concentration).bgColor);
            Text.padding({ left: 10, right: 10, top: 4, bottom: 4 });
            Text.borderRadius(12);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.getCo2Comment(this.co2Concentration));
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(426:13)", "entry");
            Text.fontSize(15);
            Text.fontColor(this.TEXT_GRAY_DARK);
        }, Text);
        Text.pop();
        Row.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 右侧装饰：用大号 emoji 植物代替图（无插画资源时优雅降级）
            Text.create('🌿');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(436:9)", "entry");
            // 右侧装饰：用大号 emoji 植物代替图（无插画资源时优雅降级）
            Text.fontSize(64);
            // 右侧装饰：用大号 emoji 植物代替图（无插画资源时优雅降级）
            Text.opacity(0.85);
        }, Text);
        // 右侧装饰：用大号 emoji 植物代替图（无插画资源时优雅降级）
        Text.pop();
        Row.pop();
        Column.pop();
    }
    // 温湿度小卡
    buildEnvMetricCard(label: string, value: string, glyph: Resource, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(454:5)", "entry");
            Row.layoutWeight(1);
            Row.padding(16);
            Row.backgroundColor(Color.White);
            Row.borderRadius(16);
            Row.shadow(CARD_SHADOW);
            Row.alignItems(VerticalAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(455:7)", "entry");
            Column.alignItems(HorizontalAlign.Start);
            Column.layoutWeight(1);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(label);
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(456:9)", "entry");
            Text.fontSize(14);
            Text.fontColor(this.TEXT_GRAY_MID);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(value);
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(459:9)", "entry");
            Text.fontSize(28);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor(this.TEXT_GRAY_DARK);
            Text.margin({ top: 8 });
        }, Text);
        Text.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 圆角小图标
            Stack.create();
            Stack.debugLine("entry/src/main/ets/pages/Insight.ets(469:7)", "entry");
            // 圆角小图标
            Stack.width(48);
            // 圆角小图标
            Stack.height(48);
            // 圆角小图标
            Stack.borderRadius(24);
            // 圆角小图标
            Stack.backgroundColor('#D8ECE2');
            // 圆角小图标
            Stack.alignContent(Alignment.Center);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            SymbolGlyph.create(glyph);
            SymbolGlyph.debugLine("entry/src/main/ets/pages/Insight.ets(470:9)", "entry");
            SymbolGlyph.fontSize(24);
            SymbolGlyph.fontColor([APPLE_BLUE]);
        }, SymbolGlyph);
        // 圆角小图标
        Stack.pop();
        Row.pop();
    }
    // 24h CO2 趋势卡
    buildEnvTrendCard(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(491:5)", "entry");
            Column.width('92%');
            Column.padding(16);
            Column.backgroundColor(Color.White);
            Column.borderRadius(20);
            Column.shadow(CARD_SHADOW);
            Column.margin({ top: 12 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('24 小时 CO₂ 趋势');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(492:7)", "entry");
            Text.fontSize(17);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor(this.TEXT_GRAY_DARK);
            Text.width('100%');
            Text.margin({ bottom: 12 });
        }, Text);
        Text.pop();
        this.buildEnvLineChart.bind(this)();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 横轴时间
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(502:7)", "entry");
            // 横轴时间
            Row.width('100%');
            // 横轴时间
            Row.margin({ top: 4 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const h = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(h.toString().padStart(2, '0'));
                    Text.debugLine("entry/src/main/ets/pages/Insight.ets(504:11)", "entry");
                    Text.fontSize(12);
                    Text.fontColor(this.TEXT_GRAY_MID);
                    Text.layoutWeight(1);
                    Text.textAlign(TextAlign.Center);
                }, Text);
                Text.pop();
            };
            this.forEachUpdateFunction(elmtId, [0, 6, 12, 18, 24], forEachItemGenFunction);
        }, ForEach);
        ForEach.pop();
        // 横轴时间
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 点击气泡提示切换
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(515:7)", "entry");
            // 点击气泡提示切换
            Row.width('100%');
            // 点击气泡提示切换
            Row.margin({ top: 10 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('• 当前选中');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(516:9)", "entry");
            Text.fontSize(12);
            Text.fontColor(this.TEXT_GRAY_MID);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${this.co2HighlightHour.toString().padStart(2, '0')}:00  ${this.co2Series[this.co2HighlightHour].ppm} ppm`);
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(519:9)", "entry");
            Text.fontSize(12);
            Text.fontColor(APPLE_BLUE);
            Text.fontWeight(FontWeight.Medium);
            Text.margin({ left: 6 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/pages/Insight.ets(524:9)", "entry");
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('点击图表切换');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(525:9)", "entry");
            Text.fontSize(12);
            Text.fontColor(this.TEXT_GRAY_MID);
        }, Text);
        Text.pop();
        // 点击气泡提示切换
        Row.pop();
        Column.pop();
    }
    // 折线图（Path 实现）
    buildEnvLineChart(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create();
            Stack.debugLine("entry/src/main/ets/pages/Insight.ets(543:5)", "entry");
            Stack.width('100%');
            Stack.height(160);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 网格横线
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(545:7)", "entry");
            // 网格横线
            Column.width('100%');
            // 网格横线
            Column.height('100%');
            // 网格横线
            Column.justifyContent(FlexAlign.SpaceBetween);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = () => {
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Row.create();
                    Row.debugLine("entry/src/main/ets/pages/Insight.ets(547:11)", "entry");
                    Row.width('100%');
                    Row.height(1);
                    Row.backgroundColor('#F0F0F2');
                }, Row);
                Row.pop();
            };
            this.forEachUpdateFunction(elmtId, [0, 1, 2, 3, 4], forEachItemGenFunction);
        }, ForEach);
        ForEach.pop();
        // 网格横线
        Column.pop();
        // 折线（Path 折线命令）
        // 坐标：x = hour/24*100, y = 1 - ppm/max
        this.buildCo2Polyline.bind(this)();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 数据点 + 选中气泡
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const pt = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    If.create();
                    if (pt.hour === this.co2HighlightHour) {
                        this.ifElseBranchUpdateFunction(0, () => {
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                // 气泡提示框
                                Column.create();
                                Column.debugLine("entry/src/main/ets/pages/Insight.ets(565:11)", "entry");
                                // 气泡提示框
                                Column.padding(8);
                                // 气泡提示框
                                Column.backgroundColor('#F4F8F6');
                                // 气泡提示框
                                Column.borderRadius(8);
                                // 气泡提示框
                                Column.borderWidth(1);
                                // 气泡提示框
                                Column.borderColor('#D8ECE2');
                                // 气泡提示框
                                Column.shadow({ radius: 8, color: '#1A000000', offsetY: 2 });
                                // 气泡提示框
                                Column.position({ x: this.getX(pt.hour) - 36, y: this.getY(pt.ppm) - 56 });
                            }, Column);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Text.create(`${pt.hour.toString().padStart(2, '0')}:00`);
                                Text.debugLine("entry/src/main/ets/pages/Insight.ets(566:13)", "entry");
                                Text.fontSize(11);
                                Text.fontColor(this.TEXT_GRAY_MID);
                            }, Text);
                            Text.pop();
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Row.create({ space: 4 });
                                Row.debugLine("entry/src/main/ets/pages/Insight.ets(569:13)", "entry");
                                Row.alignItems(VerticalAlign.Bottom);
                            }, Row);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Text.create(pt.ppm.toString());
                                Text.debugLine("entry/src/main/ets/pages/Insight.ets(570:15)", "entry");
                                Text.fontSize(16);
                                Text.fontWeight(FontWeight.Bold);
                                Text.fontColor(this.TEXT_GRAY_DARK);
                            }, Text);
                            Text.pop();
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Text.create('ppm');
                                Text.debugLine("entry/src/main/ets/pages/Insight.ets(574:15)", "entry");
                                Text.fontSize(10);
                                Text.fontColor(this.TEXT_GRAY_MID);
                            }, Text);
                            Text.pop();
                            Row.pop();
                            // 气泡提示框
                            Column.pop();
                        });
                    }
                    // 选中点的圆环
                    else {
                        this.ifElseBranchUpdateFunction(1, () => {
                        });
                    }
                }, If);
                If.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    If.create();
                    // 选中点的圆环
                    if (pt.hour === this.co2HighlightHour) {
                        this.ifElseBranchUpdateFunction(0, () => {
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Stack.create();
                                Stack.debugLine("entry/src/main/ets/pages/Insight.ets(591:11)", "entry");
                                Stack.width(14);
                                Stack.height(14);
                                Stack.position({ x: this.getX(pt.hour) - 7, y: this.getY(pt.ppm) - 7 });
                            }, Stack);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Row.create();
                                Row.debugLine("entry/src/main/ets/pages/Insight.ets(592:13)", "entry");
                                Row.width(14);
                                Row.height(14);
                                Row.borderRadius(7);
                                Row.backgroundColor('#FFFFFF');
                                Row.borderWidth(3);
                                Row.borderColor(APPLE_BLUE);
                            }, Row);
                            Row.pop();
                            Stack.pop();
                        });
                    }
                    else {
                        this.ifElseBranchUpdateFunction(1, () => {
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                // 普通数据点
                                Row.create();
                                Row.debugLine("entry/src/main/ets/pages/Insight.ets(605:11)", "entry");
                                // 普通数据点
                                Row.width(4);
                                // 普通数据点
                                Row.height(4);
                                // 普通数据点
                                Row.borderRadius(2);
                                // 普通数据点
                                Row.backgroundColor(APPLE_BLUE);
                                // 普通数据点
                                Row.opacity(0.5);
                                // 普通数据点
                                Row.position({ x: this.getX(pt.hour) - 2, y: this.getY(pt.ppm) - 2 });
                            }, Row);
                            // 普通数据点
                            Row.pop();
                        });
                    }
                }, If);
                If.pop();
            };
            this.forEachUpdateFunction(elmtId, this.co2Series, forEachItemGenFunction);
        }, ForEach);
        // 数据点 + 选中气泡
        ForEach.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 触摸层：点击切换高亮点
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(616:7)", "entry");
            // 触摸层：点击切换高亮点
            Row.width('100%');
            // 触摸层：点击切换高亮点
            Row.height('100%');
            // 触摸层：点击切换高亮点
            Row.onClick((event: ClickEvent) => {
                // 简单估算：x 坐标位置决定 hour
                const x = event.x;
                const w = 320; // 估计图表宽
                const ratio = Math.max(0, Math.min(1, x / w));
                this.co2HighlightHour = Math.round(ratio * 23);
            });
        }, Row);
        // 触摸层：点击切换高亮点
        Row.pop();
        Stack.pop();
    }
    // 把 CO2 序列转为 Path 命令
    buildCo2Polyline(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Path.create();
            Path.debugLine("entry/src/main/ets/pages/Insight.ets(634:5)", "entry");
            Path.width('100%');
            Path.height(160);
            Path.commands(this.buildCo2PathCmd());
            Path.stroke(APPLE_BLUE);
            Path.strokeWidth(2);
            Path.fillOpacity(0);
        }, Path);
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
    buildEnvAdviceCard(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(676:5)", "entry");
            Row.width('92%');
            Row.padding(16);
            Row.backgroundColor('#F4F8F6');
            Row.borderRadius(16);
            Row.alignItems(VerticalAlign.Center);
            Row.margin({ top: 12 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create();
            Stack.debugLine("entry/src/main/ets/pages/Insight.ets(677:7)", "entry");
            Stack.width(36);
            Stack.height(36);
            Stack.borderRadius(18);
            Stack.backgroundColor('#D8ECE2');
            Stack.alignContent(Alignment.Center);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            SymbolGlyph.create({ "id": 125832627, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            SymbolGlyph.debugLine("entry/src/main/ets/pages/Insight.ets(678:9)", "entry");
            SymbolGlyph.fontSize(20);
            SymbolGlyph.fontColor([APPLE_BLUE]);
        }, SymbolGlyph);
        Stack.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(688:7)", "entry");
            Column.layoutWeight(1);
            Column.margin({ left: 12 });
            Column.alignItems(HorizontalAlign.Start);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('环境建议');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(689:9)", "entry");
            Text.fontSize(16);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor(this.TEXT_GRAY_DARK);
            Text.margin({ bottom: 4 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('空气质量良好，维持良好通风换气，建议每 2 小时开窗通风 5~10 分钟。');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(694:9)", "entry");
            Text.fontSize(14);
            Text.fontColor(this.TEXT_GRAY_MID);
            Text.lineHeight(20);
        }, Text);
        Text.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('🪟');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(703:7)", "entry");
            Text.fontSize(40);
            Text.opacity(0.85);
        }, Text);
        Text.pop();
        Row.pop();
    }
    // CO2 提示卡
    buildCo2TipCard(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(718:5)", "entry");
            Column.width('85%');
            Column.padding(20);
            Column.backgroundColor(Color.White);
            Column.borderRadius(20);
            Column.shadow(CARD_SHADOW);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('二氧化碳（CO₂）浓度参考');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(719:7)", "entry");
            Text.fontSize(20);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor(this.TEXT_GRAY_DARK);
            Text.margin({ bottom: 16 });
            Text.width('100%');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('400 ~ 600 ppm：空气质量良好，适合办公\n600 ~ 1000 ppm：轻度污染，建议通风\n1000 ppm 以上：空气污浊，易疲劳头痛');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(726:7)", "entry");
            Text.fontSize(16);
            Text.fontColor(this.TEXT_GRAY_MID);
            Text.lineHeight(24);
            Text.width('100%');
        }, Text);
        Text.pop();
        Column.pop();
    }
    // ===========================================================
    // ==================== Tab 0：久坐 =============================
    // ===========================================================
    buildSedentaryTab(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(744:5)", "entry");
            Column.width('100%');
            Column.padding({ top: 8 });
        }, Column);
        // 久坐总览大卡
        this.buildSedentaryOverviewCard.bind(this)();
        // 久坐时段分布
        this.buildSedentarySegmentsCard.bind(this)();
        // 久坐健康提醒
        this.buildSedentaryRemindersCard.bind(this)();
        Column.pop();
    }
    // 久坐总览卡
    buildSedentaryOverviewCard(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(759:5)", "entry");
            Column.width('92%');
            Column.padding(20);
            Column.backgroundColor(this.ENV_CARD_BG);
            Column.borderRadius(20);
            Column.shadow(CARD_SHADOW);
            Column.margin({ top: 4 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(760:7)", "entry");
            Row.width('100%');
            Row.alignItems(VerticalAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(761:9)", "entry");
            Column.alignItems(HorizontalAlign.Start);
            Column.layoutWeight(1);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('累计久坐');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(762:11)", "entry");
            Text.fontSize(14);
            Text.fontColor(this.TEXT_GRAY_MID);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 6 });
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(765:11)", "entry");
            Row.alignItems(VerticalAlign.Bottom);
            Row.margin({ top: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(Math.floor(this.totalSedentaryMinutes / 60).toString());
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(766:13)", "entry");
            Text.fontSize(48);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor(this.TEXT_GRAY_DARK);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('小时');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(770:13)", "entry");
            Text.fontSize(16);
            Text.fontColor(this.TEXT_GRAY_MID);
            Text.margin({ bottom: 8 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create((this.totalSedentaryMinutes % 60).toString());
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(774:13)", "entry");
            Text.fontSize(48);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor(this.TEXT_GRAY_DARK);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('分');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(778:13)", "entry");
            Text.fontSize(16);
            Text.fontColor(this.TEXT_GRAY_MID);
            Text.margin({ bottom: 8 });
        }, Text);
        Text.pop();
        Row.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 进度环（用 Stack 模拟：外圈浅色 + 内圈实色）
            Stack.create({ alignContent: Alignment.Center });
            Stack.debugLine("entry/src/main/ets/pages/Insight.ets(790:9)", "entry");
            // 进度环（用 Stack 模拟：外圈浅色 + 内圈实色）
            Stack.width(96);
            // 进度环（用 Stack 模拟：外圈浅色 + 内圈实色）
            Stack.height(96);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(791:11)", "entry");
            Row.width(96);
            Row.height(96);
            Row.borderRadius(48);
            Row.borderWidth(8);
            Row.borderColor('#D8ECE2');
        }, Row);
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(797:11)", "entry");
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(Math.round((this.standUpDone / this.standUpGoal) * 100) + '%');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(798:13)", "entry");
            Text.fontSize(20);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor(APPLE_BLUE);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('完成度');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(802:13)", "entry");
            Text.fontSize(11);
            Text.fontColor(this.TEXT_GRAY_MID);
        }, Text);
        Text.pop();
        Column.pop();
        // 进度环（用 Stack 模拟：外圈浅色 + 内圈实色）
        Stack.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 站立次数进度条
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(814:7)", "entry");
            // 站立次数进度条
            Column.width('100%');
            // 站立次数进度条
            Column.alignItems(HorizontalAlign.Start);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(815:9)", "entry");
            Row.width('100%');
            Row.margin({ top: 16 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('站立次数');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(816:11)", "entry");
            Text.fontSize(14);
            Text.fontColor(this.TEXT_GRAY_MID);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/pages/Insight.ets(819:11)", "entry");
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${this.standUpDone} / ${this.standUpGoal} 次`);
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(820:11)", "entry");
            Text.fontSize(14);
            Text.fontColor(this.TEXT_GRAY_DARK);
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create({ alignContent: Alignment.Start });
            Stack.debugLine("entry/src/main/ets/pages/Insight.ets(828:9)", "entry");
            Stack.width('100%');
            Stack.margin({ top: 8 });
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(829:11)", "entry");
            Row.width('100%');
            Row.height(8);
            Row.backgroundColor('#D8ECE2');
            Row.borderRadius(4);
        }, Row);
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(834:11)", "entry");
            Row.width(`${(this.standUpDone / this.standUpGoal) * 100}%`);
            Row.height(8);
            Row.backgroundColor(APPLE_BLUE);
            Row.borderRadius(4);
        }, Row);
        Row.pop();
        Stack.pop();
        // 站立次数进度条
        Column.pop();
        Column.pop();
    }
    // 久坐时段分布卡
    buildSedentarySegmentsCard(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(857:5)", "entry");
            Column.width('92%');
            Column.padding(16);
            Column.backgroundColor(Color.White);
            Column.borderRadius(20);
            Column.shadow(CARD_SHADOW);
            Column.margin({ top: 12 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(858:7)", "entry");
            Row.width('100%');
            Row.margin({ bottom: 12 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('久坐时段');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(859:9)", "entry");
            Text.fontSize(17);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor(this.TEXT_GRAY_DARK);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/pages/Insight.ets(863:9)", "entry");
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`最长 ${this.longestStreakMinutes} 分钟`);
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(864:9)", "entry");
            Text.fontSize(13);
            Text.fontColor(this.TEXT_GRAY_MID);
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const seg = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Row.create();
                    Row.debugLine("entry/src/main/ets/pages/Insight.ets(872:9)", "entry");
                    Row.width('100%');
                    Row.padding({ top: 10, bottom: 10 });
                    Row.alignItems(VerticalAlign.Center);
                }, Row);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    SymbolGlyph.create({ "id": 125832302, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
                    SymbolGlyph.debugLine("entry/src/main/ets/pages/Insight.ets(873:11)", "entry");
                    SymbolGlyph.fontSize(18);
                    SymbolGlyph.fontColor([seg.minutes >= 60 ? APPLE_RED : (seg.minutes >= 45 ? APPLE_ORANGE : APPLE_BLUE)]);
                }, SymbolGlyph);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(`${seg.start} - ${seg.end}`);
                    Text.debugLine("entry/src/main/ets/pages/Insight.ets(876:11)", "entry");
                    Text.fontSize(15);
                    Text.fontColor(this.TEXT_GRAY_DARK);
                    Text.margin({ left: 10 });
                }, Text);
                Text.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Blank.create();
                    Blank.debugLine("entry/src/main/ets/pages/Insight.ets(880:11)", "entry");
                }, Blank);
                Blank.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(`${seg.minutes} 分钟`);
                    Text.debugLine("entry/src/main/ets/pages/Insight.ets(881:11)", "entry");
                    Text.fontSize(15);
                    Text.fontColor(seg.minutes >= 60 ? APPLE_RED : (seg.minutes >= 45 ? APPLE_ORANGE : APPLE_BLUE));
                    Text.fontWeight(FontWeight.Medium);
                }, Text);
                Text.pop();
                Row.pop();
            };
            this.forEachUpdateFunction(elmtId, this.sedentarySegments, forEachItemGenFunction);
        }, ForEach);
        ForEach.pop();
        Column.pop();
    }
    // 久坐健康提醒
    buildSedentaryRemindersCard(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(902:5)", "entry");
            Column.width('92%');
            Column.padding(16);
            Column.backgroundColor(Color.White);
            Column.borderRadius(20);
            Column.shadow(CARD_SHADOW);
            Column.margin({ top: 12 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('健康提醒');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(903:7)", "entry");
            Text.fontSize(17);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor(this.TEXT_GRAY_DARK);
            Text.width('100%');
            Text.margin({ bottom: 12 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const item = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Row.create();
                    Row.debugLine("entry/src/main/ets/pages/Insight.ets(911:9)", "entry");
                    Row.width('100%');
                    Row.padding({ top: 8, bottom: 8 });
                    Row.alignItems(VerticalAlign.Center);
                }, Row);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Stack.create();
                    Stack.debugLine("entry/src/main/ets/pages/Insight.ets(912:11)", "entry");
                    Stack.width(40);
                    Stack.height(40);
                    Stack.borderRadius(20);
                    Stack.backgroundColor(item.tone === 'bad' ? '#FFEBEB' : (item.tone === 'warn' ? '#FFF1E6' : '#D8ECE2'));
                    Stack.alignContent(Alignment.Center);
                }, Stack);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    SymbolGlyph.create(item.glyph);
                    SymbolGlyph.debugLine("entry/src/main/ets/pages/Insight.ets(913:13)", "entry");
                    SymbolGlyph.fontSize(20);
                    SymbolGlyph.fontColor([item.tone === 'bad' ? APPLE_RED : (item.tone === 'warn' ? APPLE_ORANGE : APPLE_BLUE)]);
                }, SymbolGlyph);
                Stack.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.debugLine("entry/src/main/ets/pages/Insight.ets(923:11)", "entry");
                    Column.layoutWeight(1);
                    Column.margin({ left: 12 });
                    Column.alignItems(HorizontalAlign.Start);
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(item.title);
                    Text.debugLine("entry/src/main/ets/pages/Insight.ets(924:13)", "entry");
                    Text.fontSize(15);
                    Text.fontWeight(FontWeight.Medium);
                    Text.fontColor(this.TEXT_GRAY_DARK);
                }, Text);
                Text.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(item.desc);
                    Text.debugLine("entry/src/main/ets/pages/Insight.ets(928:13)", "entry");
                    Text.fontSize(13);
                    Text.fontColor(this.TEXT_GRAY_MID);
                    Text.margin({ top: 4 });
                    Text.lineHeight(18);
                }, Text);
                Text.pop();
                Column.pop();
                Row.pop();
            };
            this.forEachUpdateFunction(elmtId, this.sedentaryReminders, forEachItemGenFunction);
        }, ForEach);
        ForEach.pop();
        Column.pop();
    }
    // ===========================================================
    // ==================== Tab 2：报告 =============================
    // ===========================================================
    buildDateSelector(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(956:5)", "entry");
            Row.width('92%');
            Row.padding({ left: 4, right: 4, top: 4, bottom: 8 });
            Row.alignItems(VerticalAlign.Center);
            Row.onClick(() => { this.showCalendarPopup = true; });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.selectDate);
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(957:7)", "entry");
            Text.fontSize(20);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor(this.TEXT_GRAY_DARK);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            SymbolGlyph.create({ "id": 125832666, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            SymbolGlyph.debugLine("entry/src/main/ets/pages/Insight.ets(961:7)", "entry");
            SymbolGlyph.fontSize(16);
            SymbolGlyph.fontColor([this.TEXT_GRAY_MID]);
            SymbolGlyph.margin({ left: 6 });
        }, SymbolGlyph);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/pages/Insight.ets(965:7)", "entry");
        }, Blank);
        Blank.pop();
        Row.pop();
    }
    buildReportTab(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(975:5)", "entry");
            Column.width('100%');
        }, Column);
        this.buildScoreCard.bind(this)(this.getHealthLevel(this.officeHealthScore));
        this.buildIndicatorContent.bind(this)();
        Column.pop();
    }
    buildCalendarDropdown(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(984:5)", "entry");
            Column.width('90%');
            Column.padding(20);
            Column.backgroundColor(Color.White);
            Column.borderRadius(20);
            Column.shadow(CARD_SHADOW);
            Column.margin({ top: 8 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('选择日期');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(985:7)", "entry");
            Text.fontSize(22);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor(this.TEXT_GRAY_DARK);
            Text.margin({ bottom: 16 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(991:7)", "entry");
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const date = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Row.create();
                    Row.debugLine("entry/src/main/ets/pages/Insight.ets(993:11)", "entry");
                    Row.width('100%');
                    Row.padding(14);
                    Row.onClick(() => {
                        this.selectDate = date;
                        this.loadDataForDate(date);
                        this.showCalendarPopup = false;
                    });
                }, Row);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(date);
                    Text.debugLine("entry/src/main/ets/pages/Insight.ets(994:13)", "entry");
                    Text.fontSize(18);
                    Text.fontColor(date === this.selectDate ? APPLE_BLUE : this.TEXT_GRAY_DARK);
                    Text.layoutWeight(1);
                }, Text);
                Text.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    If.create();
                    if (date === this.selectDate) {
                        this.ifElseBranchUpdateFunction(0, () => {
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                SymbolGlyph.create({ "id": 125831490, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
                                SymbolGlyph.debugLine("entry/src/main/ets/pages/Insight.ets(999:15)", "entry");
                                SymbolGlyph.fontSize(20);
                                SymbolGlyph.fontColor([APPLE_BLUE]);
                            }, SymbolGlyph);
                        });
                    }
                    else {
                        this.ifElseBranchUpdateFunction(1, () => {
                        });
                    }
                }, If);
                If.pop();
                Row.pop();
            };
            this.forEachUpdateFunction(elmtId, ['5月19日 周日', '5月20日 周一', '5月21日 周二', '5月22日 周三'], forEachItemGenFunction);
        }, ForEach);
        ForEach.pop();
        Column.pop();
        Column.pop();
    }
    buildScoreCard(level: HealthLevel, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(1024:5)", "entry");
            Column.width('92%');
            Column.padding(24);
            Column.backgroundColor(this.hasData ? level.bgColor : '#F9F9F9');
            Column.borderRadius(24);
            Column.shadow(CARD_SHADOW);
            Column.margin({ top: 8, bottom: 12 });
            Column.alignItems(HorizontalAlign.Start);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.hasData) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                        Row.debugLine("entry/src/main/ets/pages/Insight.ets(1026:9)", "entry");
                        Row.alignItems(VerticalAlign.Bottom);
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(this.officeHealthScore.toString());
                        Text.debugLine("entry/src/main/ets/pages/Insight.ets(1027:11)", "entry");
                        Text.fontSize(96);
                        Text.fontWeight(FontWeight.Bold);
                        Text.fontColor(APPLE_BLUE);
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(`/${this.FULL_SCORE}`);
                        Text.debugLine("entry/src/main/ets/pages/Insight.ets(1031:11)", "entry");
                        Text.fontSize(32);
                        Text.fontColor(this.TEXT_GRAY_MID);
                    }, Text);
                    Text.pop();
                    Row.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(level.text);
                        Text.debugLine("entry/src/main/ets/pages/Insight.ets(1037:9)", "entry");
                        Text.fontSize(28);
                        Text.fontWeight(FontWeight.Medium);
                        Text.fontColor(level.color);
                        Text.margin({ top: 8 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('今日办公健康总分');
                        Text.debugLine("entry/src/main/ets/pages/Insight.ets(1043:9)", "entry");
                        Text.fontSize(17);
                        Text.fontColor(this.TEXT_GRAY_MID);
                        Text.margin({ top: 6 });
                    }, Text);
                    Text.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('--');
                        Text.debugLine("entry/src/main/ets/pages/Insight.ets(1048:9)", "entry");
                        Text.fontSize(96);
                        Text.fontWeight(FontWeight.Bold);
                        Text.fontColor(GRAY_PLACEHOLDER);
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('无数据');
                        Text.debugLine("entry/src/main/ets/pages/Insight.ets(1052:9)", "entry");
                        Text.fontSize(28);
                        Text.fontWeight(FontWeight.Medium);
                        Text.fontColor(GRAY_PLACEHOLDER);
                        Text.margin({ top: 8 });
                    }, Text);
                    Text.pop();
                });
            }
        }, If);
        If.pop();
        Column.pop();
    }
    buildIndicatorContent(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.hasData) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.debugLine("entry/src/main/ets/pages/Insight.ets(1071:7)", "entry");
                        Column.width('92%');
                        Column.padding(20);
                        Column.backgroundColor(this.BIG_CARD_BG);
                        Column.borderRadius(20);
                        Column.shadow(CARD_SHADOW);
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('健康指标');
                        Text.debugLine("entry/src/main/ets/pages/Insight.ets(1072:9)", "entry");
                        Text.fontSize(20);
                        Text.fontWeight(FontWeight.Bold);
                        Text.fontColor(this.TEXT_GRAY_DARK);
                        Text.width('100%');
                        Text.margin({ bottom: 16 });
                    }, Text);
                    Text.pop();
                    this.buildIndicatorGroup.bind(this)('久坐', APPLE_ORANGE, [
                        {
                            glyph: { "id": 125832135, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                            label: '久坐时间',
                            progress: -1,
                            desc: `${Math.floor(this.totalSedentaryMinutes / 60)}小时${this.totalSedentaryMinutes % 60}分`,
                            color: APPLE_ORANGE
                        },
                        {
                            glyph: { "id": 125832304, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                            label: '最长连续久坐',
                            progress: -1,
                            desc: `${this.maxContinuousSedentaryMinutes} 分钟`,
                            color: APPLE_ORANGE
                        },
                        {
                            glyph: { "id": 125832158, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                            label: '站立次数',
                            progress: -1,
                            desc: `${this.standUpTimes}次`,
                            color: APPLE_ORANGE
                        }
                    ]);
                    this.buildEnvironmentCard.bind(this)();
                    this.buildIndicatorGroup.bind(this)('专注', APPLE_GREEN, [
                        {
                            glyph: { "id": 125832627, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                            label: '番茄钟数量',
                            progress: this.getProgressVal(this.pomodoroCount, this.MAX_POMODORO_NUM),
                            desc: `${this.pomodoroCount}个`,
                            color: APPLE_GREEN
                        },
                        {
                            glyph: { "id": 125832302, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                            label: '专注总时长',
                            progress: this.getProgressVal(this.totalFocusMinutes, this.MAX_FOCUS_MIN),
                            desc: `${this.totalFocusMinutes} 分钟`,
                            color: APPLE_GREEN
                        }
                    ]);
                    // 今日建议
                    this.buildTodayAdviceCard.bind(this)();
                    Column.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.debugLine("entry/src/main/ets/pages/Insight.ets(1131:7)", "entry");
                        Column.width('92%');
                        Column.padding(40);
                        Column.backgroundColor(this.BIG_CARD_BG);
                        Column.borderRadius(20);
                        Column.shadow(CARD_SHADOW);
                        Column.justifyContent(FlexAlign.Center);
                        Column.alignItems(HorizontalAlign.Center);
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        SymbolGlyph.create({ "id": 125832448, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
                        SymbolGlyph.debugLine("entry/src/main/ets/pages/Insight.ets(1132:9)", "entry");
                        SymbolGlyph.fontSize(48);
                        SymbolGlyph.fontColor([GRAY_PLACEHOLDER]);
                    }, SymbolGlyph);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('暂无健康数据');
                        Text.debugLine("entry/src/main/ets/pages/Insight.ets(1135:9)", "entry");
                        Text.fontSize(18);
                        Text.fontColor(GRAY_PLACEHOLDER);
                        Text.margin({ top: 12 });
                    }, Text);
                    Text.pop();
                    Column.pop();
                });
            }
        }, If);
        If.pop();
    }
    // 指标分组
    buildIndicatorGroup(title: string, categoryColor: ResourceColor, items: IndicatorParam[], parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(1153:5)", "entry");
            Column.width('100%');
            Column.padding(16);
            Column.backgroundColor(this.SMALL_CARD_BG);
            Column.borderRadius(16);
            Column.margin({ bottom: 12 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(title);
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(1154:7)", "entry");
            Text.fontSize(18);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor(categoryColor);
            Text.width('100%');
            Text.margin({ bottom: 12 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const item = _item;
                this.buildSingleIndicator.bind(this)(item);
            };
            this.forEachUpdateFunction(elmtId, items, forEachItemGenFunction);
        }, ForEach);
        ForEach.pop();
        Column.pop();
    }
    // 环境指标卡（报告中复用）
    buildEnvironmentCard(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(1174:5)", "entry");
            Column.width('100%');
            Column.padding(16);
            Column.backgroundColor(this.SMALL_CARD_BG);
            Column.borderRadius(16);
            Column.margin({ bottom: 12 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('环境');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(1175:7)", "entry");
            Text.fontSize(18);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor(APPLE_BLUE);
            Text.width('100%');
            Text.margin({ bottom: 12 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(1182:7)", "entry");
            Column.width('100%');
            Column.padding({ top: 8, bottom: 12 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(1183:9)", "entry");
            Row.alignItems(VerticalAlign.Center);
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            SymbolGlyph.create({ "id": 125832515, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            SymbolGlyph.debugLine("entry/src/main/ets/pages/Insight.ets(1184:11)", "entry");
            SymbolGlyph.fontSize(24);
            SymbolGlyph.fontColor([APPLE_BLUE]);
        }, SymbolGlyph);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('CO₂');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(1187:11)", "entry");
            Text.fontSize(16);
            Text.fontColor(this.TEXT_GRAY_DARK);
            Text.margin({ left: 10 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/pages/Insight.ets(1191:11)", "entry");
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${this.co2Concentration} ppm`);
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(1192:11)", "entry");
            Text.fontSize(16);
            Text.fontColor(this.TEXT_GRAY_MID);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            SymbolGlyph.create({ "id": 125832644, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            SymbolGlyph.debugLine("entry/src/main/ets/pages/Insight.ets(1195:11)", "entry");
            SymbolGlyph.fontSize(18);
            SymbolGlyph.fontColor([APPLE_BLUE]);
            SymbolGlyph.margin({ left: 6 });
            SymbolGlyph.onClick(() => { this.showCo2Tip = true; });
        }, SymbolGlyph);
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create({ alignContent: Alignment.Start });
            Stack.debugLine("entry/src/main/ets/pages/Insight.ets(1204:9)", "entry");
            Stack.width('100%');
            Stack.margin({ top: 10 });
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(1205:11)", "entry");
            Row.width('100%');
            Row.height(6);
            Row.backgroundColor(this.DIVIDER_COLOR);
            Row.borderRadius(3);
        }, Row);
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(1210:11)", "entry");
            Row.width(`${this.getProgressVal(this.co2Concentration, this.MAX_CO2_PPM)}%`);
            Row.height(6);
            Row.backgroundColor(APPLE_BLUE);
            Row.borderRadius(3);
        }, Row);
        Row.pop();
        Stack.pop();
        Column.pop();
        this.buildSingleIndicator.bind(this)(makeBuilderParameterProxy("buildSingleIndicator", { glyph: () => ({ "id": 125832642, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }), label: () => '温度 / 湿度', progress: () => -1, desc: () => `${this.temperature}℃ / ${this.humidity}%`, color: () => APPLE_BLUE }));
        Column.pop();
    }
    // 单条指标
    buildSingleIndicator(params: IndicatorParam, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(1240:5)", "entry");
            Column.width('100%');
            Column.padding({ top: 8, bottom: 8 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(1241:7)", "entry");
            Row.alignItems(VerticalAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            SymbolGlyph.create(params.glyph);
            SymbolGlyph.debugLine("entry/src/main/ets/pages/Insight.ets(1242:9)", "entry");
            SymbolGlyph.fontSize(24);
            SymbolGlyph.fontColor([params.color]);
        }, SymbolGlyph);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(params.label);
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(1245:9)", "entry");
            Text.fontSize(16);
            Text.fontColor(this.TEXT_GRAY_DARK);
            Text.margin({ left: 10 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/pages/Insight.ets(1249:9)", "entry");
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(params.desc);
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(1250:9)", "entry");
            Text.fontSize(16);
            Text.fontColor(this.TEXT_GRAY_MID);
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (params.progress >= 0) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Stack.create({ alignContent: Alignment.Start });
                        Stack.debugLine("entry/src/main/ets/pages/Insight.ets(1257:9)", "entry");
                        Stack.width('100%');
                        Stack.margin({ top: 10 });
                    }, Stack);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                        Row.debugLine("entry/src/main/ets/pages/Insight.ets(1258:11)", "entry");
                        Row.width('100%');
                        Row.height(6);
                        Row.backgroundColor(this.DIVIDER_COLOR);
                        Row.borderRadius(3);
                    }, Row);
                    Row.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                        Row.debugLine("entry/src/main/ets/pages/Insight.ets(1263:11)", "entry");
                        Row.width(`${params.progress}%`);
                        Row.height(6);
                        Row.backgroundColor(params.color);
                        Row.borderRadius(3);
                    }, Row);
                    Row.pop();
                    Stack.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        Column.pop();
    }
    // 今日建议（三张并排小卡）
    buildTodayAdviceCard(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(1280:5)", "entry");
            Column.width('100%');
            Column.margin({ top: 4 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('今日建议');
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(1281:7)", "entry");
            Text.fontSize(18);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor(this.TEXT_GRAY_DARK);
            Text.width('100%');
            Text.margin({ bottom: 12 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 10 });
            Row.debugLine("entry/src/main/ets/pages/Insight.ets(1288:7)", "entry");
            Row.width('100%');
        }, Row);
        this.buildAdviceMiniCard.bind(this)({ "id": 125832158, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }, '适时起身', '每 45 分钟起身');
        this.buildAdviceMiniCard.bind(this)({ "id": 125832627, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }, '保持通风', '空气湿度适宜');
        this.buildAdviceMiniCard.bind(this)({ "id": 125831673, "type": 40000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }, '专注节奏', '劳逸结合');
        Row.pop();
        Column.pop();
    }
    buildAdviceMiniCard(glyph: Resource, title: string, desc: string, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Insight.ets(1301:5)", "entry");
            Column.layoutWeight(1);
            Column.padding({ top: 14, bottom: 14 });
            Column.backgroundColor(this.SMALL_CARD_BG);
            Column.borderRadius(14);
            Column.alignItems(HorizontalAlign.Center);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            SymbolGlyph.create(glyph);
            SymbolGlyph.debugLine("entry/src/main/ets/pages/Insight.ets(1302:7)", "entry");
            SymbolGlyph.fontSize(22);
            SymbolGlyph.fontColor([APPLE_BLUE]);
        }, SymbolGlyph);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(title);
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(1305:7)", "entry");
            Text.fontSize(14);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor(this.TEXT_GRAY_DARK);
            Text.margin({ top: 8 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(desc);
            Text.debugLine("entry/src/main/ets/pages/Insight.ets(1310:7)", "entry");
            Text.fontSize(11);
            Text.fontColor(this.TEXT_GRAY_MID);
            Text.margin({ top: 2 });
            Text.textAlign(TextAlign.Center);
        }, Text);
        Text.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
