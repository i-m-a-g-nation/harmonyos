if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface TodayTargetCard_Params {
    targetList?: TargetItem[];
}
import type { TargetItem } from '../model/TargetTypes';
export class TodayTargetCard extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__targetList = new SynchedPropertyObjectOneWayPU(params.targetList, this, "targetList");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: TodayTargetCard_Params) {
        if (params.targetList === undefined) {
            this.__targetList.set([]
            // 安全获取数组，不会返回undefined
            );
        }
    }
    updateStateVars(params: TodayTargetCard_Params) {
        this.__targetList.reset(params.targetList);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__targetList.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__targetList.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __targetList: SynchedPropertySimpleOneWayPU<TargetItem[]>;
    get targetList() {
        return this.__targetList.get();
    }
    set targetList(newValue: TargetItem[]) {
        this.__targetList.set(newValue);
    }
    // 安全获取数组，不会返回undefined
    private getSafeList(): TargetItem[] {
        if (!this.targetList) {
            return [];
        }
        return this.targetList;
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 12 });
            Column.debugLine("entry/src/main/ets/common/components/TodayTargetCard.ets(16:5)", "entry");
            Column.width('100%');
            Column.padding(16);
            Column.backgroundColor('#FFFFFF');
            Column.borderRadius(16);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/common/components/TodayTargetCard.ets(17:7)", "entry");
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('今日目标');
            Text.debugLine("entry/src/main/ets/common/components/TodayTargetCard.ets(18:9)", "entry");
            Text.fontSize(16);
            Text.fontColor('#1A1A1A');
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/common/components/TodayTargetCard.ets(23:9)", "entry");
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 直接在行内调用方法获取总数，不在build顶部定义变量
            Text.create(`${this.getSafeList().length} 个目标`);
            Text.debugLine("entry/src/main/ets/common/components/TodayTargetCard.ets(26:9)", "entry");
            // 直接在行内调用方法获取总数，不在build顶部定义变量
            Text.fontSize(14);
            // 直接在行内调用方法获取总数，不在build顶部定义变量
            Text.fontColor('#3A8F7E');
            // 直接在行内调用方法获取总数，不在build顶部定义变量
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        // 直接在行内调用方法获取总数，不在build顶部定义变量
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 10 });
            Column.debugLine("entry/src/main/ets/common/components/TodayTargetCard.ets(33:7)", "entry");
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // ForEach直接调用安全方法
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const item = _item;
                this.TargetItem.bind(this)(item.content);
            };
            this.forEachUpdateFunction(elmtId, this.getSafeList(), forEachItemGenFunction, (item: TargetItem) => item.id, false, false);
        }, ForEach);
        // ForEach直接调用安全方法
        ForEach.pop();
        Column.pop();
        Column.pop();
    }
    TargetItem(text: string, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/common/components/TodayTargetCard.ets(49:5)", "entry");
            Row.width('100%');
            Row.alignItems(VerticalAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Circle.create({ width: 8, height: 8 });
            Circle.debugLine("entry/src/main/ets/common/components/TodayTargetCard.ets(50:7)", "entry");
            Circle.fill('#D0D3D6');
        }, Circle);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(text);
            Text.debugLine("entry/src/main/ets/common/components/TodayTargetCard.ets(53:7)", "entry");
            Text.fontSize(15);
            Text.fontColor('#999999');
            Text.margin({ left: 10 });
            Text.layoutWeight(1);
        }, Text);
        Text.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
