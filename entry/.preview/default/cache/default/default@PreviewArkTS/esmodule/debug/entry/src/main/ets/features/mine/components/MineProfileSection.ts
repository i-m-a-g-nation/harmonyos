if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface MineProfileSection_Params {
    // 具体进入哪个目的地由 MineHomePage/MineRoot 决定，组件保持可复用。
    onOpenProfile?: () => void;
}
export class MineProfileSection extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.onOpenProfile = undefined;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: MineProfileSection_Params) {
        if (params.onOpenProfile !== undefined) {
            this.onOpenProfile = params.onOpenProfile;
        }
    }
    updateStateVars(params: MineProfileSection_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // 具体进入哪个目的地由 MineHomePage/MineRoot 决定，组件保持可复用。
    private onOpenProfile?: () => void;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 18 });
            Row.debugLine("entry/src/main/ets/features/mine/components/MineProfileSection.ets(8:5)", "entry");
            Row.width('100%');
            Row.padding({ top: 8, bottom: 6 });
            Row.alignItems(VerticalAlign.Center);
            Row.onClick(() => {
                this.onOpenProfile?.();
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777251, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/features/mine/components/MineProfileSection.ets(9:7)", "entry");
            Image.width(64);
            Image.height(64);
            Image.borderRadius(32);
            Image.objectFit(ImageFit.Cover);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 7 });
            Column.debugLine("entry/src/main/ets/features/mine/components/MineProfileSection.ets(15:7)", "entry");
            Column.alignItems(HorizontalAlign.Start);
            Column.layoutWeight(1);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('张小悦');
            Text.debugLine("entry/src/main/ets/features/mine/components/MineProfileSection.ets(16:9)", "entry");
            Text.fontSize(23);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor('#1A1A1A');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('健康办公，高效生活');
            Text.debugLine("entry/src/main/ets/features/mine/components/MineProfileSection.ets(21:9)", "entry");
            Text.fontSize(14);
            Text.fontColor('#5F6266');
        }, Text);
        Text.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777256, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/features/mine/components/MineProfileSection.ets(28:7)", "entry");
            Image.width(22);
            Image.height(22);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
