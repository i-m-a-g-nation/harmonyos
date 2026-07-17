if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface UnbindButton_Params {
    // 改名：避开系统原生 onClick 方法名，自定义业务回调
    onUnbindClick?: () => void;
}
export class UnbindButton extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.onUnbindClick = undefined;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: UnbindButton_Params) {
        if (params.onUnbindClick !== undefined) {
            this.onUnbindClick = params.onUnbindClick;
        }
    }
    updateStateVars(params: UnbindButton_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // 改名：避开系统原生 onClick 方法名，自定义业务回调
    private onUnbindClick?: () => void;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 12 });
            Row.debugLine("entry/src/main/ets/common/components/UnbindButton.ets(7:5)", "entry");
            Row.width('100%');
            Row.height(56);
            Row.justifyContent(FlexAlign.Center);
            Row.backgroundColor('rgba(255, 77, 79, 0.08)');
            Row.borderRadius(16);
            Row.onClick(() => {
                this.onUnbindClick?.();
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777265, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/common/components/UnbindButton.ets(8:7)", "entry");
            Image.width(22);
            Image.height(22);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('解除绑定');
            Text.debugLine("entry/src/main/ets/common/components/UnbindButton.ets(13:7)", "entry");
            Text.fontSize(18);
            Text.fontColor('#F5222D');
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        Text.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
