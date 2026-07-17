if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface DeviceDetail_Params {
    batteryLevel?: number;
}
import router from "@ohos:router";
import { DeviceInfoCard } from "@normalized:N&&&entry/src/main/ets/common/components/DeviceInfoCard&";
import { DeviceMenuCard } from "@normalized:N&&&entry/src/main/ets/common/components/DeviceMenuCard&";
import { UnbindButton } from "@normalized:N&&&entry/src/main/ets/common/components/UnbindButton&";
class DeviceDetail extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__batteryLevel = new SynchedPropertySimpleOneWayPU(params.batteryLevel, this, "batteryLevel");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: DeviceDetail_Params) {
        if (params.batteryLevel === undefined) {
            this.__batteryLevel.set(78);
        }
    }
    updateStateVars(params: DeviceDetail_Params) {
        this.__batteryLevel.reset(params.batteryLevel);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__batteryLevel.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__batteryLevel.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __batteryLevel: SynchedPropertySimpleOneWayPU<number>;
    get batteryLevel() {
        return this.__batteryLevel.get();
    }
    set batteryLevel(newValue: number) {
        this.__batteryLevel.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Setting.ets(13:5)", "entry");
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('#F7F8FA');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 1. 页面导航栏
            Stack.create({ alignContent: Alignment.Center });
            Stack.debugLine("entry/src/main/ets/pages/Setting.ets(15:7)", "entry");
            // 1. 页面导航栏
            Stack.width('100%');
            // 1. 页面导航栏
            Stack.padding({ left: 20, right: 20, top: 8, bottom: 0 });
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('设备详情');
            Text.debugLine("entry/src/main/ets/pages/Setting.ets(16:9)", "entry");
            Text.fontSize(22);
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Setting.ets(20:9)", "entry");
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777245, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Setting.ets(21:11)", "entry");
            Image.width(24);
            Image.height(24);
            Image.objectFit(ImageFit.Contain);
            Image.onClick(() => {
                router.back();
            });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/pages/Setting.ets(28:11)", "entry");
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777244, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Setting.ets(29:11)", "entry");
            Image.width(24);
            Image.height(24);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        Row.pop();
        // 1. 页面导航栏
        Stack.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 2. 可滚动内容区
            Scroll.create();
            Scroll.debugLine("entry/src/main/ets/pages/Setting.ets(40:7)", "entry");
            // 2. 可滚动内容区
            Scroll.layoutWeight(1);
            // 2. 可滚动内容区
            Scroll.scrollBar(BarState.Off);
        }, Scroll);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 16 });
            Column.debugLine("entry/src/main/ets/pages/Setting.ets(41:9)", "entry");
            Column.width('100%');
            Column.justifyContent(FlexAlign.Start);
            Column.padding({ bottom: 30 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            __Common__.create();
            __Common__.margin({ left: 20, right: 20, top: -2 });
        }, __Common__);
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new 
                    // 设备信息卡片
                    DeviceInfoCard(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Setting.ets", line: 43, col: 11 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {};
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, { name: "DeviceInfoCard" });
        }
        __Common__.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            __Common__.create();
            __Common__.margin({ left: 20, right: 20 });
        }, __Common__);
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new 
                    // 功能菜单卡片
                    DeviceMenuCard(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Setting.ets", line: 47, col: 11 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {};
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, { name: "DeviceMenuCard" });
        }
        __Common__.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            __Common__.create();
            __Common__.margin({ left: 20, right: 20 });
        }, __Common__);
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new UnbindButton(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Setting.ets", line: 50, col: 11 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {};
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, { name: "UnbindButton" });
        }
        __Common__.pop();
        Column.pop();
        // 2. 可滚动内容区
        Scroll.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "DeviceDetail";
    }
}
registerNamedRoute(() => new DeviceDetail(undefined, {}), "", { bundleName: "com.zhi.zuoan", moduleName: "entry", pagePath: "pages/Setting", pageFullPath: "entry/src/main/ets/pages/Setting", integratedHsp: "false", moduleType: "followWithHap" });
