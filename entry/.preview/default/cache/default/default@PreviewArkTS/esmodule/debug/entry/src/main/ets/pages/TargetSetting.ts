if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface TargetSetting_Params {
    targetList?: TargetItem[];
    newTargetText?: string;
}
import router from "@ohos:router";
import type { TargetItem } from '../common/model/TargetTypes';
class TargetSetting extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__targetList = this.createStorageLink('targetList', [], "targetList");
        this.__newTargetText = new ObservedPropertySimplePU(''
        // 添加新目标
        , this, "newTargetText");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: TargetSetting_Params) {
        if (params.newTargetText !== undefined) {
            this.newTargetText = params.newTargetText;
        }
    }
    updateStateVars(params: TargetSetting_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__targetList.purgeDependencyOnElmtId(rmElmtId);
        this.__newTargetText.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__targetList.aboutToBeDeleted();
        this.__newTargetText.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __targetList: ObservedPropertyAbstractPU<TargetItem[]>;
    get targetList() {
        return this.__targetList.get();
    }
    set targetList(newValue: TargetItem[]) {
        this.__targetList.set(newValue);
    }
    private __newTargetText: ObservedPropertySimplePU<string>;
    get newTargetText() {
        return this.__newTargetText.get();
    }
    set newTargetText(newValue: string) {
        this.__newTargetText.set(newValue);
    }
    // 添加新目标
    private addNewTarget() {
        if (this.newTargetText.trim().length === 0)
            return;
        const newItem: TargetItem = {
            id: Date.now().toString(),
            content: this.newTargetText.trim(),
            isFinished: false
        };
        // 用 concat 生成新数组，符合 ArkTS 语法
        this.targetList = this.targetList.concat([newItem]);
        this.newTargetText = '';
    }
    // 删除目标
    private deleteTarget(id: string) {
        this.targetList = this.targetList.filter(item => item.id !== id);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/TargetSetting.ets(29:5)", "entry");
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('#F7F8FA');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 顶部导航栏
            Stack.create({ alignContent: Alignment.Center });
            Stack.debugLine("entry/src/main/ets/pages/TargetSetting.ets(31:7)", "entry");
            // 顶部导航栏
            Stack.width('100%');
            // 顶部导航栏
            Stack.padding({ left: 20, right: 20, top: 8, bottom: 0 });
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('今日目标管理');
            Text.debugLine("entry/src/main/ets/pages/TargetSetting.ets(32:9)", "entry");
            Text.fontSize(22);
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/TargetSetting.ets(36:9)", "entry");
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777245, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/TargetSetting.ets(37:11)", "entry");
            Image.width(24);
            Image.height(24);
            Image.objectFit(ImageFit.Contain);
            Image.onClick(() => {
                router.back();
            });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/pages/TargetSetting.ets(44:11)", "entry");
        }, Blank);
        Blank.pop();
        Row.pop();
        // 顶部导航栏
        Stack.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 目标列表
            Scroll.create();
            Scroll.debugLine("entry/src/main/ets/pages/TargetSetting.ets(52:7)", "entry");
            // 目标列表
            Scroll.layoutWeight(1);
            // 目标列表
            Scroll.scrollBar(BarState.Off);
        }, Scroll);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 12 });
            Column.debugLine("entry/src/main/ets/pages/TargetSetting.ets(53:9)", "entry");
            Column.width('100%');
            Column.padding({ left: 20, right: 20, bottom: 20 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 0 });
            Column.debugLine("entry/src/main/ets/pages/TargetSetting.ets(54:11)", "entry");
            Column.width('100%');
            Column.backgroundColor('#FFFFFF');
            Column.borderRadius(16);
            Column.margin({ top: 12 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = (_item, index: number) => {
                const item = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Row.create();
                    Row.debugLine("entry/src/main/ets/pages/TargetSetting.ets(56:15)", "entry");
                    Row.width('100%');
                    Row.padding({ top: 14, bottom: 14, left: 16, right: 16 });
                }, Row);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(item.content);
                    Text.debugLine("entry/src/main/ets/pages/TargetSetting.ets(57:17)", "entry");
                    Text.fontSize(16);
                    Text.fontColor('#1A1A1A');
                    Text.layoutWeight(1);
                }, Text);
                Text.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create('删除');
                    Text.debugLine("entry/src/main/ets/pages/TargetSetting.ets(62:17)", "entry");
                    Text.fontSize(14);
                    Text.fontColor('#FF3B30');
                    Text.onClick(() => {
                        this.deleteTarget(item.id);
                    });
                }, Text);
                Text.pop();
                Row.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    If.create();
                    if (index < this.targetList.length - 1) {
                        this.ifElseBranchUpdateFunction(0, () => {
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Divider.create();
                                Divider.debugLine("entry/src/main/ets/pages/TargetSetting.ets(73:17)", "entry");
                                Divider.color('#F0F0F0');
                                Divider.margin({ left: 16 });
                            }, Divider);
                        });
                    }
                    else {
                        this.ifElseBranchUpdateFunction(1, () => {
                        });
                    }
                }, If);
                If.pop();
            };
            this.forEachUpdateFunction(elmtId, this.targetList || [], forEachItemGenFunction, (item: TargetItem) => item.id, true, false);
        }, ForEach);
        ForEach.pop();
        Column.pop();
        Column.pop();
        // 目标列表
        Scroll.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 底部新增输入区
            Row.create({ space: 12 });
            Row.debugLine("entry/src/main/ets/pages/TargetSetting.ets(89:7)", "entry");
            // 底部新增输入区
            Row.width('100%');
            // 底部新增输入区
            Row.padding({ left: 20, right: 20, bottom: 20, top: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TextInput.create({ placeholder: '添加新的今日目标', text: this.newTargetText });
            TextInput.debugLine("entry/src/main/ets/pages/TargetSetting.ets(90:9)", "entry");
            TextInput.layoutWeight(1);
            TextInput.height(44);
            TextInput.backgroundColor('#FFFFFF');
            TextInput.borderRadius(12);
            TextInput.padding({ left: 14, right: 14 });
            TextInput.onChange((value: string) => {
                this.newTargetText = value;
            });
        }, TextInput);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('添加');
            Button.debugLine("entry/src/main/ets/pages/TargetSetting.ets(100:9)", "entry");
            Button.height(44);
            Button.backgroundColor('#3A8F7E');
            Button.borderRadius(12);
            Button.fontSize(15);
            Button.onClick(() => {
                this.addNewTarget();
            });
        }, Button);
        Button.pop();
        // 底部新增输入区
        Row.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "TargetSetting";
    }
}
registerNamedRoute(() => new TargetSetting(undefined, {}), "", { bundleName: "com.zhi.zuoan", moduleName: "entry", pagePath: "pages/TargetSetting", pageFullPath: "entry/src/main/ets/pages/TargetSetting", integratedHsp: "false", moduleType: "followWithHap" });
