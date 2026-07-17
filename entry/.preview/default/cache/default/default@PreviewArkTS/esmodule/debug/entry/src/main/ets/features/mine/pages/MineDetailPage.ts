if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface MineDetailPage_Params {
    title?: string;
    // 返回行为由持有 NavPathStack 的 MineRoot 实现。
    onBack?: () => void;
}
export class MineDetailPage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__title = new SynchedPropertySimpleOneWayPU(params.title, this, "title");
        this.onBack = undefined;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: MineDetailPage_Params) {
        if (params.title === undefined) {
            this.__title.set(''
            // 返回行为由持有 NavPathStack 的 MineRoot 实现。
            );
        }
        if (params.onBack !== undefined) {
            this.onBack = params.onBack;
        }
    }
    updateStateVars(params: MineDetailPage_Params) {
        this.__title.reset(params.title);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__title.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__title.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // 标题由 MinePageModel 根据路由统一映射，页面本身不判断业务类型。
    private __title: SynchedPropertySimpleOneWayPU<string>;
    get title() {
        return this.__title.get();
    }
    set title(newValue: string) {
        this.__title.set(newValue);
    }
    // 返回行为由持有 NavPathStack 的 MineRoot 实现。
    private onBack?: () => void;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/features/mine/pages/MineDetailPage.ets(13:5)", "entry");
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('#F7F8FA');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/features/mine/pages/MineDetailPage.ets(14:7)", "entry");
            Row.width('100%');
            Row.height(52);
            Row.padding({ left: 8, right: 8 });
            Row.alignItems(VerticalAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 左右各保留 48vp 宽度，使中间标题在视觉上保持真正居中。
            Row.create();
            Row.debugLine("entry/src/main/ets/features/mine/pages/MineDetailPage.ets(16:9)", "entry");
            // 左右各保留 48vp 宽度，使中间标题在视觉上保持真正居中。
            Row.width(48);
            // 左右各保留 48vp 宽度，使中间标题在视觉上保持真正居中。
            Row.height(48);
            // 左右各保留 48vp 宽度，使中间标题在视觉上保持真正居中。
            Row.justifyContent(FlexAlign.Center);
            // 左右各保留 48vp 宽度，使中间标题在视觉上保持真正居中。
            Row.onClick(() => {
                this.onBack?.();
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777256, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/features/mine/pages/MineDetailPage.ets(17:11)", "entry");
            Image.width(22);
            Image.height(22);
            Image.objectFit(ImageFit.Contain);
            Image.rotate({ angle: 180 });
        }, Image);
        // 左右各保留 48vp 宽度，使中间标题在视觉上保持真正居中。
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.title);
            Text.debugLine("entry/src/main/ets/features/mine/pages/MineDetailPage.ets(30:9)", "entry");
            Text.fontSize(20);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor('#1A1A1A');
            Text.textAlign(TextAlign.Center);
            Text.layoutWeight(1);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/features/mine/pages/MineDetailPage.ets(37:9)", "entry");
            Blank.width(48);
        }, Blank);
        Blank.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 当前只搭建导航框架，具体二级页内容将在后续任务中填充。
            Blank.create();
            Blank.debugLine("entry/src/main/ets/features/mine/pages/MineDetailPage.ets(46:7)", "entry");
            // 当前只搭建导航框架，具体二级页内容将在后续任务中填充。
            Blank.layoutWeight(1);
        }, Blank);
        // 当前只搭建导航框架，具体二级页内容将在后续任务中填充。
        Blank.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
