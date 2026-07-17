if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface MetricCard_Params {
    title?: string;
    value?: string;
    unit?: string;
    secondValue?: string;
    secondUnit?: string;
    iconResource?: Resource;
}
export class MetricCard extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__title = new SynchedPropertySimpleOneWayPU(params.title, this, "title");
        this.__value = new SynchedPropertySimpleOneWayPU(params.value, this, "value");
        this.__unit = new SynchedPropertySimpleOneWayPU(params.unit, this, "unit");
        this.__secondValue = new SynchedPropertySimpleOneWayPU(params.secondValue, this, "secondValue");
        this.__secondUnit = new SynchedPropertySimpleOneWayPU(params.secondUnit, this, "secondUnit");
        this.__iconResource = new SynchedPropertyObjectOneWayPU(params.iconResource, this, "iconResource");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: MetricCard_Params) {
        if (params.title === undefined) {
            this.__title.set('');
        }
        if (params.value === undefined) {
            this.__value.set('');
        }
        if (params.unit === undefined) {
            this.__unit.set('');
        }
        if (params.secondValue === undefined) {
            this.__secondValue.set('');
        }
        if (params.secondUnit === undefined) {
            this.__secondUnit.set('');
        }
        if (params.iconResource === undefined) {
            this.__iconResource.set({ "id": 16777231, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
        }
    }
    updateStateVars(params: MetricCard_Params) {
        this.__title.reset(params.title);
        this.__value.reset(params.value);
        this.__unit.reset(params.unit);
        this.__secondValue.reset(params.secondValue);
        this.__secondUnit.reset(params.secondUnit);
        this.__iconResource.reset(params.iconResource);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__title.purgeDependencyOnElmtId(rmElmtId);
        this.__value.purgeDependencyOnElmtId(rmElmtId);
        this.__unit.purgeDependencyOnElmtId(rmElmtId);
        this.__secondValue.purgeDependencyOnElmtId(rmElmtId);
        this.__secondUnit.purgeDependencyOnElmtId(rmElmtId);
        this.__iconResource.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__title.aboutToBeDeleted();
        this.__value.aboutToBeDeleted();
        this.__unit.aboutToBeDeleted();
        this.__secondValue.aboutToBeDeleted();
        this.__secondUnit.aboutToBeDeleted();
        this.__iconResource.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __title: SynchedPropertySimpleOneWayPU<string>;
    get title() {
        return this.__title.get();
    }
    set title(newValue: string) {
        this.__title.set(newValue);
    }
    private __value: SynchedPropertySimpleOneWayPU<string>;
    get value() {
        return this.__value.get();
    }
    set value(newValue: string) {
        this.__value.set(newValue);
    }
    private __unit: SynchedPropertySimpleOneWayPU<string>;
    get unit() {
        return this.__unit.get();
    }
    set unit(newValue: string) {
        this.__unit.set(newValue);
    }
    private __secondValue: SynchedPropertySimpleOneWayPU<string>;
    get secondValue() {
        return this.__secondValue.get();
    }
    set secondValue(newValue: string) {
        this.__secondValue.set(newValue);
    }
    private __secondUnit: SynchedPropertySimpleOneWayPU<string>;
    get secondUnit() {
        return this.__secondUnit.get();
    }
    set secondUnit(newValue: string) {
        this.__secondUnit.set(newValue);
    }
    private __iconResource: SynchedPropertySimpleOneWayPU<Resource>;
    get iconResource() {
        return this.__iconResource.get();
    }
    set iconResource(newValue: Resource) {
        this.__iconResource.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 10 });
            Column.debugLine("entry/src/main/ets/common/components/MetricCard.ets(11:5)", "entry");
            Column.width('100%');
            Column.padding({ top: 14, bottom: 14 });
            Column.backgroundColor('#FFFFFF');
            Column.borderRadius(16);
            Column.justifyContent(FlexAlign.Center);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 标题
            Text.create(this.title);
            Text.debugLine("entry/src/main/ets/common/components/MetricCard.ets(13:7)", "entry");
            // 标题
            Text.fontSize(14);
            // 标题
            Text.fontColor('#666666');
        }, Text);
        // 标题
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 数值行
            Row.create();
            Row.debugLine("entry/src/main/ets/common/components/MetricCard.ets(18:7)", "entry");
            // 数值行
            Row.alignItems(VerticalAlign.Bottom);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.value);
            Text.debugLine("entry/src/main/ets/common/components/MetricCard.ets(19:9)", "entry");
            Text.fontSize(24);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor('#1A1A1A');
            Text.maxLines(1);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.unit);
            Text.debugLine("entry/src/main/ets/common/components/MetricCard.ets(24:9)", "entry");
            Text.fontSize(13);
            Text.fontColor('#666666');
            Text.margin({ left: 2 });
            Text.maxLines(1);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.secondValue) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(this.secondValue);
                        Text.debugLine("entry/src/main/ets/common/components/MetricCard.ets(31:11)", "entry");
                        Text.fontSize(24);
                        Text.fontWeight(FontWeight.Bold);
                        Text.fontColor('#1A1A1A');
                        Text.margin({ left: 4 });
                        Text.maxLines(1);
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(this.secondUnit);
                        Text.debugLine("entry/src/main/ets/common/components/MetricCard.ets(37:11)", "entry");
                        Text.fontSize(13);
                        Text.fontColor('#666666');
                        Text.margin({ left: 2 });
                        Text.maxLines(1);
                    }, Text);
                    Text.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        // 数值行
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 底部图标
            Image.create(this.iconResource);
            Image.debugLine("entry/src/main/ets/common/components/MetricCard.ets(47:7)", "entry");
            // 底部图标
            Image.width(32);
            // 底部图标
            Image.height(32);
            // 底部图标
            Image.objectFit(ImageFit.Contain);
        }, Image);
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
