if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
    btStatus?: BluetoothStatus;
    wifiLevel?: WifiSignalLevel;
    battery?: number;
    healthScore?: number;
    currentTab?: number;
    activeFeatureDepth?: number;
    insightTopTab?: number;
    targetList?: TargetItem[];
}
import { DeviceStatusBar } from "@normalized:N&&&entry/src/main/ets/common/components/DeviceStatusBar&";
import { HealthScoreCard } from "@normalized:N&&&entry/src/main/ets/common/components/HealthScoreCard&";
import { MetricCard } from "@normalized:N&&&entry/src/main/ets/common/components/MetricCard&";
import { SmartAdviceCard } from "@normalized:N&&&entry/src/main/ets/common/components/SmartAdviceCard&";
import { TodayTargetCard } from "@normalized:N&&&entry/src/main/ets/common/components/TodayTargetCard&";
import { BottomTabBar } from "@normalized:N&&&entry/src/main/ets/common/components/BottomTabBar&";
import { BluetoothStatus } from "@normalized:N&&&entry/src/main/ets/common/constants/StatusEnum&";
import { WifiSignalLevel } from "@normalized:N&&&entry/src/main/ets/common/constants/StatusEnum&";
import router from "@ohos:router";
import { Insight } from "@normalized:N&&&entry/src/main/ets/pages/Insight&";
import { MineRoot } from "@normalized:N&&&entry/src/main/ets/features/mine/MineRoot&";
import type { TargetItem } from '../common/model/TargetTypes';
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__btStatus = new ObservedPropertySimplePU(BluetoothStatus.CONNECTED, this, "btStatus");
        this.__wifiLevel = new ObservedPropertySimplePU(WifiSignalLevel.FULL, this, "wifiLevel");
        this.__battery = new ObservedPropertySimplePU(85, this, "battery");
        this.__healthScore = new ObservedPropertySimplePU(86
        // 当前选中的Tab索引，和底部导航、Tabs双向绑定
        , this, "healthScore");
        this.__currentTab = new ObservedPropertySimplePU(0
        // 当前功能内部导航深度：0 表示功能首页；大于 0 表示二级页。
        // 壳层只依赖“深度”，不依赖 Mine 的具体路由，从而保持功能解耦。
        , this, "currentTab");
        this.__activeFeatureDepth = new ObservedPropertySimplePU(0
        // 洞察页顶部Tab选中索引
        , this, "activeFeatureDepth");
        this.__insightTopTab = new ObservedPropertySimplePU(1
        // 今日目标全局数据，与设置页双向同步
        , this, "insightTopTab");
        this.__targetList = this.createStorageLink('targetList', []
        /**
         * 应用级设备详情入口。
         * 首页设置按钮和 Mine 设备卡片都复用这个方法，避免子组件直接依赖页面 URL。
         */
        , "targetList");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.btStatus !== undefined) {
            this.btStatus = params.btStatus;
        }
        if (params.wifiLevel !== undefined) {
            this.wifiLevel = params.wifiLevel;
        }
        if (params.battery !== undefined) {
            this.battery = params.battery;
        }
        if (params.healthScore !== undefined) {
            this.healthScore = params.healthScore;
        }
        if (params.currentTab !== undefined) {
            this.currentTab = params.currentTab;
        }
        if (params.activeFeatureDepth !== undefined) {
            this.activeFeatureDepth = params.activeFeatureDepth;
        }
        if (params.insightTopTab !== undefined) {
            this.insightTopTab = params.insightTopTab;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__btStatus.purgeDependencyOnElmtId(rmElmtId);
        this.__wifiLevel.purgeDependencyOnElmtId(rmElmtId);
        this.__battery.purgeDependencyOnElmtId(rmElmtId);
        this.__healthScore.purgeDependencyOnElmtId(rmElmtId);
        this.__currentTab.purgeDependencyOnElmtId(rmElmtId);
        this.__activeFeatureDepth.purgeDependencyOnElmtId(rmElmtId);
        this.__insightTopTab.purgeDependencyOnElmtId(rmElmtId);
        this.__targetList.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__btStatus.aboutToBeDeleted();
        this.__wifiLevel.aboutToBeDeleted();
        this.__battery.aboutToBeDeleted();
        this.__healthScore.aboutToBeDeleted();
        this.__currentTab.aboutToBeDeleted();
        this.__activeFeatureDepth.aboutToBeDeleted();
        this.__insightTopTab.aboutToBeDeleted();
        this.__targetList.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // 首页演示状态；当前仍是静态数据，未来接入真实数据源时再抽到 ViewModel/Repository。
    private __btStatus: ObservedPropertySimplePU<BluetoothStatus>;
    get btStatus() {
        return this.__btStatus.get();
    }
    set btStatus(newValue: BluetoothStatus) {
        this.__btStatus.set(newValue);
    }
    private __wifiLevel: ObservedPropertySimplePU<WifiSignalLevel>;
    get wifiLevel() {
        return this.__wifiLevel.get();
    }
    set wifiLevel(newValue: WifiSignalLevel) {
        this.__wifiLevel.set(newValue);
    }
    private __battery: ObservedPropertySimplePU<number>;
    get battery() {
        return this.__battery.get();
    }
    set battery(newValue: number) {
        this.__battery.set(newValue);
    }
    private __healthScore: ObservedPropertySimplePU<number>;
    get healthScore() {
        return this.__healthScore.get();
    }
    set healthScore(newValue: number) {
        this.__healthScore.set(newValue);
    }
    // 当前选中的Tab索引，和底部导航、Tabs双向绑定
    private __currentTab: ObservedPropertySimplePU<number>;
    get currentTab() {
        return this.__currentTab.get();
    }
    set currentTab(newValue: number) {
        this.__currentTab.set(newValue);
    }
    // 当前功能内部导航深度：0 表示功能首页；大于 0 表示二级页。
    // 壳层只依赖“深度”，不依赖 Mine 的具体路由，从而保持功能解耦。
    private __activeFeatureDepth: ObservedPropertySimplePU<number>;
    get activeFeatureDepth() {
        return this.__activeFeatureDepth.get();
    }
    set activeFeatureDepth(newValue: number) {
        this.__activeFeatureDepth.set(newValue);
    }
    // 洞察页顶部Tab选中索引
    private __insightTopTab: ObservedPropertySimplePU<number>;
    get insightTopTab() {
        return this.__insightTopTab.get();
    }
    set insightTopTab(newValue: number) {
        this.__insightTopTab.set(newValue);
    }
    // 今日目标全局数据，与设置页双向同步
    private __targetList: ObservedPropertyAbstractPU<TargetItem[]>;
    get targetList() {
        return this.__targetList.get();
    }
    set targetList(newValue: TargetItem[]) {
        this.__targetList.set(newValue);
    }
    /**
     * 应用级设备详情入口。
     * 首页设置按钮和 Mine 设备卡片都复用这个方法，避免子组件直接依赖页面 URL。
     */
    private openDeviceDetail(): void {
        console.info('===== 开始执行设备详情跳转 =====');
        try {
            router.pushUrl({
                url: 'pages/Setting'
            });
            console.info('设备详情跳转指令已发出');
        }
        catch (err) {
            console.error('设备详情跳转失败：', JSON.stringify(err));
        }
    }
    aboutToAppear() {
        // 增加空值兜底，防止初始undefined导致length报错
        if (!this.targetList || this.targetList.length === 0) {
            this.targetList = [
                { id: '1', content: '完成 4 个番茄钟', isFinished: false },
                { id: '2', content: '达到 8 次站立', isFinished: false },
                { id: '3', content: '保持空气良好', isFinished: false }
            ];
        }
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Index.ets(66:5)", "entry");
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('#F7F8FA');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 页面容器：占满剩余空间，支持左右滑动切换
            Tabs.create({ index: this.currentTab });
            Tabs.debugLine("entry/src/main/ets/pages/Index.ets(68:7)", "entry");
            // 页面容器：占满剩余空间，支持左右滑动切换
            Tabs.barHeight(0);
            // 页面容器：占满剩余空间，支持左右滑动切换
            Tabs.onChange((index: number) => {
                // 左右滑动页面时，同步更新底部导航的选中状态
                this.currentTab = index;
            });
            // 页面容器：占满剩余空间，支持左右滑动切换
            Tabs.scrollable(this.activeFeatureDepth === 0);
            // 页面容器：占满剩余空间，支持左右滑动切换
            Tabs.layoutWeight(1);
        }, Tabs);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TabContent.create(() => {
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Scroll.create();
                    Scroll.debugLine("entry/src/main/ets/pages/Index.ets(71:11)", "entry");
                    Scroll.width('100%');
                    Scroll.height('100%');
                }, Scroll);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.debugLine("entry/src/main/ets/pages/Index.ets(72:13)", "entry");
                    Column.width('100%');
                }, Column);
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new 
                            // 1. 设备连接状态栏
                            DeviceStatusBar(this, {
                                btStatus: this.btStatus,
                                onDeviceClick: () => {
                                    console.info('点击设备连接栏');
                                },
                                onNotifyClick: () => {
                                    console.info('点击消息铃铛');
                                },
                                // 设置按钮跳转逻辑
                                onSettingClick: () => {
                                    this.openDeviceDetail();
                                }
                            }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Index.ets", line: 74, col: 15 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {
                                    btStatus: this.btStatus,
                                    onDeviceClick: () => {
                                        console.info('点击设备连接栏');
                                    },
                                    onNotifyClick: () => {
                                        console.info('点击消息铃铛');
                                    },
                                    // 设置按钮跳转逻辑
                                    onSettingClick: () => {
                                        this.openDeviceDetail();
                                    }
                                };
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {
                                btStatus: this.btStatus
                            });
                        }
                    }, { name: "DeviceStatusBar" });
                }
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    __Common__.create();
                    __Common__.margin({ left: 20, right: 20, top: 8 });
                    __Common__.onClick(() => {
                        this.insightTopTab = 2; // 定位到报告Tab
                        this.currentTab = 1; // 切到洞察页
                    });
                }, __Common__);
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new 
                            // 2. 健康评分卡片（新增点击：跳转到洞察-报告页）
                            HealthScoreCard(this, {
                                score: this.healthScore
                            }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Index.ets", line: 89, col: 15 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {
                                    score: this.healthScore
                                };
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {
                                score: this.healthScore
                            });
                        }
                    }, { name: "HealthScoreCard" });
                }
                __Common__.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    // 3. 三指标卡片行
                    Row.create({ space: 12 });
                    Row.debugLine("entry/src/main/ets/pages/Index.ets(99:15)", "entry");
                    // 3. 三指标卡片行
                    Row.width('100%');
                    // 3. 三指标卡片行
                    Row.padding({ left: 20, right: 20, top: 12 });
                }, Row);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    __Common__.create();
                    __Common__.layoutWeight(1);
                    __Common__.onClick(() => {
                        this.insightTopTab = 0; // 定位到久坐Tab
                        this.currentTab = 1; // 切到洞察页
                    });
                }, __Common__);
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new MetricCard(this, {
                                title: '久坐',
                                value: '4',
                                unit: '小时',
                                secondValue: '12',
                                secondUnit: '分',
                                iconResource: { "id": 16777231, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }
                            }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Index.ets", line: 100, col: 17 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {
                                    title: '久坐',
                                    value: '4',
                                    unit: '小时',
                                    secondValue: '12',
                                    secondUnit: '分',
                                    iconResource: { "id": 16777231, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }
                                };
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {
                                title: '久坐',
                                value: '4',
                                unit: '小时',
                                secondValue: '12',
                                secondUnit: '分',
                                iconResource: { "id": 16777231, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }
                            });
                        }
                    }, { name: "MetricCard" });
                }
                __Common__.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    __Common__.create();
                    __Common__.layoutWeight(1);
                    __Common__.onClick(() => {
                        this.insightTopTab = 1; // 定位到环境Tab
                        this.currentTab = 1; // 切到洞察页
                    });
                }, __Common__);
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new MetricCard(this, {
                                title: '环境',
                                value: '420',
                                unit: 'ppm',
                                iconResource: { "id": 16777220, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }
                            }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Index.ets", line: 114, col: 17 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {
                                    title: '环境',
                                    value: '420',
                                    unit: 'ppm',
                                    iconResource: { "id": 16777220, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }
                                };
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {
                                title: '环境',
                                value: '420',
                                unit: 'ppm',
                                iconResource: { "id": 16777220, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }
                            });
                        }
                    }, { name: "MetricCard" });
                }
                __Common__.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    __Common__.create();
                    __Common__.layoutWeight(1);
                    __Common__.onClick(() => {
                        this.currentTab = 2; // 直接切到底部专注Tab
                    });
                }, __Common__);
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new MetricCard(this, {
                                title: '专注',
                                value: '150',
                                unit: '分钟',
                                iconResource: { "id": 16777229, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }
                            }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Index.ets", line: 126, col: 17 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {
                                    title: '专注',
                                    value: '150',
                                    unit: '分钟',
                                    iconResource: { "id": 16777229, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }
                                };
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {
                                title: '专注',
                                value: '150',
                                unit: '分钟',
                                iconResource: { "id": 16777229, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }
                            });
                        }
                    }, { name: "MetricCard" });
                }
                __Common__.pop();
                // 3. 三指标卡片行
                Row.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    __Common__.create();
                    __Common__.margin({ left: 20, right: 20, top: 12 });
                }, __Common__);
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new 
                            // 4. 智能建议卡片
                            SmartAdviceCard(this, {
                                adviceText: '上午久坐偏多，建议下午每45分钟起身活动',
                                onViewClick: () => {
                                    // 点击「去查看」跳转到建议详情页
                                    try {
                                        router.pushUrl({
                                            url: 'pages/AdviceDetail'
                                        });
                                    }
                                    catch (err) {
                                        console.error('跳转建议详情失败：', JSON.stringify(err));
                                    }
                                }
                            }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Index.ets", line: 141, col: 15 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {
                                    adviceText: '上午久坐偏多，建议下午每45分钟起身活动',
                                    onViewClick: () => {
                                        // 点击「去查看」跳转到建议详情页
                                        try {
                                            router.pushUrl({
                                                url: 'pages/AdviceDetail'
                                            });
                                        }
                                        catch (err) {
                                            console.error('跳转建议详情失败：', JSON.stringify(err));
                                        }
                                    }
                                };
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {
                                adviceText: '上午久坐偏多，建议下午每45分钟起身活动'
                            });
                        }
                    }, { name: "SmartAdviceCard" });
                }
                __Common__.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    __Common__.create();
                    __Common__.margin({ left: 20, right: 20, top: 12 });
                    __Common__.onClick(() => {
                        try {
                            router.pushUrl({
                                url: 'pages/TargetSetting'
                            });
                        }
                        catch (err) {
                            console.error('跳转目标设置失败：', JSON.stringify(err));
                        }
                    });
                }, __Common__);
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new 
                            // 5. 今日目标卡片
                            TodayTargetCard(this, {
                                targetList: this.targetList
                            }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Index.ets", line: 157, col: 15 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {
                                    targetList: this.targetList
                                };
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {
                                targetList: this.targetList
                            });
                        }
                    }, { name: "TodayTargetCard" });
                }
                __Common__.pop();
                Column.pop();
                Scroll.pop();
            });
            TabContent.debugLine("entry/src/main/ets/pages/Index.ets(70:9)", "entry");
        }, TabContent);
        TabContent.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TabContent.create(() => {
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new Insight(this, {
                                currentTopTab: this.__insightTopTab
                            }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Index.ets", line: 180, col: 11 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {
                                    currentTopTab: this.insightTopTab
                                };
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {});
                        }
                    }, { name: "Insight" });
                }
            });
            TabContent.debugLine("entry/src/main/ets/pages/Index.ets(179:9)", "entry");
        }, TabContent);
        TabContent.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TabContent.create(() => {
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.debugLine("entry/src/main/ets/pages/Index.ets(187:11)", "entry");
                    Column.width('100%');
                    Column.height('100%');
                    Column.justifyContent(FlexAlign.Center);
                    Column.backgroundColor('#F7F8FA');
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create('专注页面');
                    Text.debugLine("entry/src/main/ets/pages/Index.ets(188:13)", "entry");
                    Text.fontSize(20);
                    Text.fontColor('#999999');
                }, Text);
                Text.pop();
                Column.pop();
            });
            TabContent.debugLine("entry/src/main/ets/pages/Index.ets(186:9)", "entry");
        }, TabContent);
        TabContent.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TabContent.create(() => {
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new 
                            // MineRoot 是“我的”功能唯一对外入口。
                            // 第一个回调同步壳层显示状态；第二个回调请求应用打开独立设备详情页。
                            MineRoot(this, {
                                onNavigationDepthChange: (depth: number) => {
                                    this.activeFeatureDepth = depth;
                                },
                                onOpenDeviceDetail: () => {
                                    this.openDeviceDetail();
                                }
                            }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Index.ets", line: 202, col: 11 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {
                                    onNavigationDepthChange: (depth: number) => {
                                        this.activeFeatureDepth = depth;
                                    },
                                    onOpenDeviceDetail: () => {
                                        this.openDeviceDetail();
                                    }
                                };
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {});
                        }
                    }, { name: "MineRoot" });
                }
            });
            TabContent.debugLine("entry/src/main/ets/pages/Index.ets(199:9)", "entry");
        }, TabContent);
        TabContent.pop();
        // 页面容器：占满剩余空间，支持左右滑动切换
        Tabs.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            // 底部固定导航栏
            // Mine 内部二级页出现时隐藏底栏；回到功能根页面后自动恢复。
            if (this.activeFeatureDepth === 0) {
                this.ifElseBranchUpdateFunction(0, () => {
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let componentCall = new BottomTabBar(this, {
                                    currentIndex: this.__currentTab,
                                    onTabChange: (index: number) => {
                                        // 点击底部Tab时，切换到对应页面
                                        this.currentTab = index;
                                    }
                                }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Index.ets", line: 224, col: 9 });
                                ViewPU.create(componentCall);
                                let paramsLambda = () => {
                                    return {
                                        currentIndex: this.currentTab,
                                        onTabChange: (index: number) => {
                                            // 点击底部Tab时，切换到对应页面
                                            this.currentTab = index;
                                        }
                                    };
                                };
                                componentCall.paramsGenerator_ = paramsLambda;
                            }
                            else {
                                this.updateStateVarsOfChildByElmtId(elmtId, {});
                            }
                        }, { name: "BottomTabBar" });
                    }
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
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Index";
    }
}
registerNamedRoute(() => new Index(undefined, {}), "", { bundleName: "com.zhi.zuoan", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
