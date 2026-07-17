if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface BatteryIcon_Params {
    batteryLevel?: number;
    iconSize?: number;
    LOW_THRESHOLD?: number;
}
export class BatteryIcon extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__batteryLevel = new SynchedPropertySimpleOneWayPU(params.batteryLevel, this, "batteryLevel");
        this.__iconSize = new SynchedPropertySimpleOneWayPU(params.iconSize, this, "iconSize");
        this.LOW_THRESHOLD = 20;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: BatteryIcon_Params) {
        if (params.batteryLevel === undefined) {
            this.__batteryLevel.set(85);
        }
        if (params.iconSize === undefined) {
            this.__iconSize.set(20
            // 低电量阈值
            );
        }
        if (params.LOW_THRESHOLD !== undefined) {
            this.LOW_THRESHOLD = params.LOW_THRESHOLD;
        }
    }
    updateStateVars(params: BatteryIcon_Params) {
        this.__batteryLevel.reset(params.batteryLevel);
        this.__iconSize.reset(params.iconSize);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__batteryLevel.purgeDependencyOnElmtId(rmElmtId);
        this.__iconSize.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__batteryLevel.aboutToBeDeleted();
        this.__iconSize.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // 电量数值 0-100
    private __batteryLevel: SynchedPropertySimpleOneWayPU<number>;
    get batteryLevel() {
        return this.__batteryLevel.get();
    }
    set batteryLevel(newValue: number) {
        this.__batteryLevel.set(newValue);
    }
    private __iconSize: SynchedPropertySimpleOneWayPU<number>;
    get iconSize() {
        return this.__iconSize.get();
    }
    set iconSize(newValue: number) {
        this.__iconSize.set(newValue);
    }
    // 低电量阈值
    private readonly LOW_THRESHOLD: number;
    // 获取填充色
    private getFillColor(): string {
        return this.batteryLevel <= this.LOW_THRESHOLD ? '#E74C3C' : '#333333';
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create({ alignContent: Alignment.Start });
            Stack.debugLine("entry/src/main/ets/common/components/BatteryIcon.ets(15:5)", "entry");
            Stack.width(this.iconSize + 2);
            Stack.height(this.iconSize * 0.55);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 1. 电池主体外框
            Rect.create();
            Rect.debugLine("entry/src/main/ets/common/components/BatteryIcon.ets(17:7)", "entry");
            // 1. 电池主体外框
            Rect.width(this.iconSize);
            // 1. 电池主体外框
            Rect.height(this.iconSize * 0.55);
            // 1. 电池主体外框
            Rect.borderRadius(2);
            // 1. 电池主体外框
            Rect.stroke('#909399');
            // 1. 电池主体外框
            Rect.strokeWidth(1.2);
            // 1. 电池主体外框
            Rect.fill(Color.Transparent);
        }, Rect);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 2. 电池正极小帽
            Rect.create();
            Rect.debugLine("entry/src/main/ets/common/components/BatteryIcon.ets(26:7)", "entry");
            // 2. 电池正极小帽
            Rect.width(2);
            // 2. 电池正极小帽
            Rect.height(this.iconSize * 0.25);
            // 2. 电池正极小帽
            Rect.fill('#909399');
            // 2. 电池正极小帽
            Rect.borderRadius({ topRight: 1, bottomRight: 1 });
            // 2. 电池正极小帽
            Rect.position({
                x: this.iconSize,
                y: (this.iconSize * 0.55 - this.iconSize * 0.25) / 2
            });
        }, Rect);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            // 3. 内部电量填充
            if (this.batteryLevel > 0) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Rect.create();
                        Rect.debugLine("entry/src/main/ets/common/components/BatteryIcon.ets(38:9)", "entry");
                        globalThis.Context.animation({ duration: 300 });
                        Rect.width((this.iconSize - 3) * (this.batteryLevel / 100));
                        Rect.height(this.iconSize * 0.55 - 3);
                        Rect.fill(this.getFillColor());
                        Rect.borderRadius(1);
                        Rect.margin({ left: 1.5 });
                        globalThis.Context.animation(null);
                    }, Rect);
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        Stack.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
