if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface WifiSignalIcon_Params {
    level?: WifiSignalLevel;
    iconSize?: number;
    normalColor?: string;
    disableColor?: string;
}
import { WifiSignalLevel } from "@normalized:N&&&entry/src/main/ets/common/constants/StatusEnum&";
export class WifiSignalIcon extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__level = new SynchedPropertySimpleOneWayPU(params.level, this, "level");
        this.__iconSize = new SynchedPropertySimpleOneWayPU(params.iconSize, this, "iconSize");
        this.normalColor = '#333333';
        this.disableColor = '#D0D0D0';
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: WifiSignalIcon_Params) {
        if (params.level === undefined) {
            this.__level.set(WifiSignalLevel.FULL);
        }
        if (params.iconSize === undefined) {
            this.__iconSize.set(16
            // 正常状态颜色
            );
        }
        if (params.normalColor !== undefined) {
            this.normalColor = params.normalColor;
        }
        if (params.disableColor !== undefined) {
            this.disableColor = params.disableColor;
        }
    }
    updateStateVars(params: WifiSignalIcon_Params) {
        this.__level.reset(params.level);
        this.__iconSize.reset(params.iconSize);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__level.purgeDependencyOnElmtId(rmElmtId);
        this.__iconSize.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__level.aboutToBeDeleted();
        this.__iconSize.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __level: SynchedPropertySimpleOneWayPU<WifiSignalLevel>;
    get level() {
        return this.__level.get();
    }
    set level(newValue: WifiSignalLevel) {
        this.__level.set(newValue);
    }
    private __iconSize: SynchedPropertySimpleOneWayPU<number>;
    get iconSize() {
        return this.__iconSize.get();
    }
    set iconSize(newValue: number) {
        this.__iconSize.set(newValue);
    }
    // 正常状态颜色
    private readonly normalColor: string;
    // 无信号颜色
    private readonly disableColor: string;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 4格信号条，底部对齐，高度递增
            Row.create({ space: 2 });
            Row.debugLine("entry/src/main/ets/common/components/WifiSignalIcon.ets(14:5)", "entry");
            // 4格信号条，底部对齐，高度递增
            Row.width(this.iconSize);
            // 4格信号条，底部对齐，高度递增
            Row.height(this.iconSize);
            // 4格信号条，底部对齐，高度递增
            Row.alignItems(VerticalAlign.Bottom);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const index = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Rect.create();
                    Rect.debugLine("entry/src/main/ets/common/components/WifiSignalIcon.ets(16:9)", "entry");
                    Rect.width(2);
                    Rect.height(this.iconSize * (index / 4));
                    Rect.borderRadius(1);
                    Rect.fill(index <= this.level ? this.normalColor : this.disableColor);
                }, Rect);
            };
            this.forEachUpdateFunction(elmtId, [1, 2, 3, 4], forEachItemGenFunction);
        }, ForEach);
        ForEach.pop();
        // 4格信号条，底部对齐，高度递增
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
