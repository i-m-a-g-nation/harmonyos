if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface AdviceDetail_Params {
}
import router from "@ohos:router";
class AdviceDetail extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: AdviceDetail_Params) {
    }
    updateStateVars(params: AdviceDetail_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(7:5)", "entry");
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('#F7F8FA');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 顶部导航栏（与设备详情页风格统一）
            Stack.create({ alignContent: Alignment.Center });
            Stack.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(9:7)", "entry");
            // 顶部导航栏（与设备详情页风格统一）
            Stack.width('100%');
            // 顶部导航栏（与设备详情页风格统一）
            Stack.padding({ left: 20, right: 20, top: 8, bottom: 0 });
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('健康建议详情');
            Text.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(10:9)", "entry");
            Text.fontSize(22);
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(14:9)", "entry");
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777245, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(15:11)", "entry");
            Image.width(24);
            Image.height(24);
            Image.objectFit(ImageFit.Contain);
            Image.onClick(() => {
                router.back();
            });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(22:11)", "entry");
        }, Blank);
        Blank.pop();
        Row.pop();
        // 顶部导航栏（与设备详情页风格统一）
        Stack.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 内容滚动区
            Scroll.create();
            Scroll.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(30:7)", "entry");
            // 内容滚动区
            Scroll.layoutWeight(1);
            // 内容滚动区
            Scroll.scrollBar(BarState.Off);
        }, Scroll);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 16 });
            Column.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(31:9)", "entry");
            Column.width('100%');
            Column.padding({ left: 20, right: 20, bottom: 30 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 建议概览卡片
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(33:11)", "entry");
            // 建议概览卡片
            Column.width('100%');
            // 建议概览卡片
            Column.padding(20);
            // 建议概览卡片
            Column.backgroundColor('#EAF5EF');
            // 建议概览卡片
            Column.borderRadius(16);
            // 建议概览卡片
            Column.margin({ top: 12 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(34:13)", "entry");
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('💡');
            Text.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(35:15)", "entry");
            Text.fontSize(32);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 6 });
            Column.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(37:15)", "entry");
            Column.margin({ left: 12 });
            Column.alignItems(HorizontalAlign.Start);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('久坐提醒');
            Text.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(38:17)", "entry");
            Text.fontSize(20);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor('#1C1C1E');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('上午久坐偏多，建议调整作息');
            Text.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(42:17)", "entry");
            Text.fontSize(14);
            Text.fontColor('#8E8E93');
        }, Text);
        Text.pop();
        Column.pop();
        Row.pop();
        // 建议概览卡片
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 原因分析
            Column.create({ space: 12 });
            Column.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(58:11)", "entry");
            // 原因分析
            Column.width('100%');
            // 原因分析
            Column.padding(20);
            // 原因分析
            Column.backgroundColor('#FFFFFF');
            // 原因分析
            Column.borderRadius(16);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('原因分析');
            Text.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(59:13)", "entry");
            Text.fontSize(18);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor('#1C1C1E');
            Text.width('100%');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('今日上午累计久坐 3 小时 12 分钟，最长连续久坐 92 分钟未起身，超过了健康办公的推荐阈值。长期保持该状态会增加颈椎、腰椎负担，同时室内二氧化碳浓度逐步升高，容易引发疲劳、注意力下降。');
            Text.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(65:13)", "entry");
            Text.fontSize(15);
            Text.fontColor('#3C3C43');
            Text.lineHeight(22);
            Text.width('100%');
        }, Text);
        Text.pop();
        // 原因分析
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 改善建议列表
            Column.create({ space: 12 });
            Column.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(77:11)", "entry");
            // 改善建议列表
            Column.width('100%');
            // 改善建议列表
            Column.padding(20);
            // 改善建议列表
            Column.backgroundColor('#FFFFFF');
            // 改善建议列表
            Column.borderRadius(16);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('改善建议');
            Text.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(78:13)", "entry");
            Text.fontSize(18);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor('#1C1C1E');
            Text.width('100%');
        }, Text);
        Text.pop();
        this.buildAdviceItem.bind(this)('01', '定时起身', '每 45 分钟起身活动 2~3 分钟，做简单的颈部、腰部拉伸。');
        this.buildAdviceItem.bind(this)('02', '开窗通风', '建议立刻开窗通风 5 分钟，降低室内二氧化碳浓度。');
        this.buildAdviceItem.bind(this)('03', '调整节奏', '下午采用番茄工作法，25 分钟专注 + 5 分钟休息交替。');
        // 改善建议列表
        Column.pop();
        Column.pop();
        // 内容滚动区
        Scroll.pop();
        Column.pop();
    }
    buildAdviceItem(index: string, title: string, desc: string, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 12 });
            Row.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(106:5)", "entry");
            Row.width('100%');
            Row.padding({ top: 8, bottom: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(index);
            Text.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(107:7)", "entry");
            Text.fontSize(16);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor('#3A8F7E');
            Text.width(28);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 4 });
            Column.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(113:7)", "entry");
            Column.alignItems(HorizontalAlign.Start);
            Column.layoutWeight(1);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(title);
            Text.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(114:9)", "entry");
            Text.fontSize(16);
            Text.fontColor('#1C1C1E');
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(desc);
            Text.debugLine("entry/src/main/ets/pages/AdviceDetail.ets(118:9)", "entry");
            Text.fontSize(14);
            Text.fontColor('#8E8E93');
            Text.lineHeight(20);
        }, Text);
        Text.pop();
        Column.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "AdviceDetail";
    }
}
registerNamedRoute(() => new AdviceDetail(undefined, {}), "", { bundleName: "com.zhi.zuoan", moduleName: "entry", pagePath: "pages/AdviceDetail", pageFullPath: "entry/src/main/ets/pages/AdviceDetail", integratedHsp: "false", moduleType: "followWithHap" });
