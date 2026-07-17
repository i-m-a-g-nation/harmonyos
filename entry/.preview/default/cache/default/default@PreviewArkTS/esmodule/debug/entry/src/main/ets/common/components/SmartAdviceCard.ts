if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface SmartAdviceCard_Params {
    adviceText?: string;
    // 点击回调
    onViewClick?: () => void;
}
export class SmartAdviceCard extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__adviceText = new SynchedPropertySimpleOneWayPU(params.adviceText, this, "adviceText");
        this.onViewClick = undefined;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: SmartAdviceCard_Params) {
        if (params.adviceText === undefined) {
            this.__adviceText.set('上午久坐偏多，建议下午每45分钟起身活动'
            // 点击回调
            );
        }
        if (params.onViewClick !== undefined) {
            this.onViewClick = params.onViewClick;
        }
    }
    updateStateVars(params: SmartAdviceCard_Params) {
        this.__adviceText.reset(params.adviceText);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__adviceText.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__adviceText.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // 建议内容，外部可传入
    private __adviceText: SynchedPropertySimpleOneWayPU<string>;
    get adviceText() {
        return this.__adviceText.get();
    }
    set adviceText(newValue: string) {
        this.__adviceText.set(newValue);
    }
    // 点击回调
    private onViewClick?: () => void;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 10 });
            Column.debugLine("entry/src/main/ets/common/components/SmartAdviceCard.ets(9:5)", "entry");
            Column.width('100%');
            Column.padding(16);
            Column.backgroundColor('#FFFFFF');
            Column.borderRadius(16);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 顶部：图标 + 标题
            Row.create({ space: 6 });
            Row.debugLine("entry/src/main/ets/common/components/SmartAdviceCard.ets(11:7)", "entry");
            // 顶部：图标 + 标题
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777234, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/common/components/SmartAdviceCard.ets(12:9)", "entry");
            Image.width(16);
            Image.height(16);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('智能建议');
            Text.debugLine("entry/src/main/ets/common/components/SmartAdviceCard.ets(17:9)", "entry");
            Text.fontSize(14);
            Text.fontColor('#333333');
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        Text.pop();
        // 顶部：图标 + 标题
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 底部：建议文字 + 去查看按钮
            Row.create();
            Row.debugLine("entry/src/main/ets/common/components/SmartAdviceCard.ets(25:7)", "entry");
            // 底部：建议文字 + 去查看按钮
            Row.width('100%');
            // 底部：建议文字 + 去查看按钮
            Row.alignItems(VerticalAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.adviceText);
            Text.debugLine("entry/src/main/ets/common/components/SmartAdviceCard.ets(26:9)", "entry");
            Text.fontSize(15);
            Text.fontColor('#333333');
            Text.layoutWeight(1);
            Text.maxLines(2);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 纯代码实现的胶囊按钮，无需素材
            Text.create('去查看');
            Text.debugLine("entry/src/main/ets/common/components/SmartAdviceCard.ets(33:9)", "entry");
            // 纯代码实现的胶囊按钮，无需素材
            Text.fontSize(13);
            // 纯代码实现的胶囊按钮，无需素材
            Text.fontColor('#FFFFFF');
            // 纯代码实现的胶囊按钮，无需素材
            Text.padding({ left: 16, right: 16, top: 6, bottom: 6 });
            // 纯代码实现的胶囊按钮，无需素材
            Text.backgroundColor('#3A8F7E');
            // 纯代码实现的胶囊按钮，无需素材
            Text.borderRadius(999);
            // 纯代码实现的胶囊按钮，无需素材
            Text.onClick(() => {
                this.onViewClick?.();
            });
        }, Text);
        // 纯代码实现的胶囊按钮，无需素材
        Text.pop();
        // 底部：建议文字 + 去查看按钮
        Row.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
