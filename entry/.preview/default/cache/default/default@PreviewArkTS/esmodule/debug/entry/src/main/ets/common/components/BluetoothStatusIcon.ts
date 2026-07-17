if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface BluetoothStatusIcon_Params {
    status?: BluetoothStatus;
    iconSize?: number;
}
import { BluetoothStatus } from "@normalized:N&&&entry/src/main/ets/common/constants/StatusEnum&";
export class BluetoothStatusIcon extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__status = new SynchedPropertySimpleOneWayPU(params.status, this, "status");
        this.__iconSize = new SynchedPropertySimpleOneWayPU(params.iconSize, this, "iconSize");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: BluetoothStatusIcon_Params) {
        if (params.status === undefined) {
            this.__status.set(BluetoothStatus.DISCONNECTED
            /**
             * 图标尺寸，外部可自定义大小，默认16vp
             */
            );
        }
        if (params.iconSize === undefined) {
            this.__iconSize.set(16
            /**
             * 根据状态返回对应图标颜色
             * 已连接：主题绿；连接中：警示橙；未连接/关闭：中性灰
             */
            );
        }
    }
    updateStateVars(params: BluetoothStatusIcon_Params) {
        this.__status.reset(params.status);
        this.__iconSize.reset(params.iconSize);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__status.purgeDependencyOnElmtId(rmElmtId);
        this.__iconSize.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__status.aboutToBeDeleted();
        this.__iconSize.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    /**
     * 外部传入的蓝牙状态，默认未连接
     */
    private __status: SynchedPropertySimpleOneWayPU<BluetoothStatus>;
    get status() {
        return this.__status.get();
    }
    set status(newValue: BluetoothStatus) {
        this.__status.set(newValue);
    }
    /**
     * 图标尺寸，外部可自定义大小，默认16vp
     */
    private __iconSize: SynchedPropertySimpleOneWayPU<number>;
    get iconSize() {
        return this.__iconSize.get();
    }
    set iconSize(newValue: number) {
        this.__iconSize.set(newValue);
    }
    /**
     * 根据状态返回对应图标颜色
     * 已连接：主题绿；连接中：警示橙；未连接/关闭：中性灰
     */
    private getStatusColor(): ResourceColor {
        switch (this.status) {
            case BluetoothStatus.CONNECTED:
                return '#3A8F7E'; // 莫兰迪低饱和绿，贴合你的设计风格
            case BluetoothStatus.CONNECTING:
                return '#E2A75C'; // 低饱和橙
            case BluetoothStatus.OFF:
                return '#B0B3B8'; // 浅灰
            default:
                return '#B0B3B8'; // 默认未连接灰色
        }
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 用Stack堆叠：底层蓝牙图标 + 连接中动画圆环
            Stack.create({ alignContent: Alignment.Center });
            Stack.debugLine("entry/src/main/ets/common/components/BluetoothStatusIcon.ets(34:5)", "entry");
            // 用Stack堆叠：底层蓝牙图标 + 连接中动画圆环
            Stack.width(this.iconSize);
            // 用Stack堆叠：底层蓝牙图标 + 连接中动画圆环
            Stack.height(this.iconSize);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 1. 基础蓝牙图标，通过fillColor统一改色
            Image.create({ "id": 16777230, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/common/components/BluetoothStatusIcon.ets(36:7)", "entry");
            // 1. 基础蓝牙图标，通过fillColor统一改色
            Image.width(this.iconSize);
            // 1. 基础蓝牙图标，通过fillColor统一改色
            Image.height(this.iconSize);
            // 1. 基础蓝牙图标，通过fillColor统一改色
            Image.fillColor(this.getStatusColor());
            // 1. 基础蓝牙图标，通过fillColor统一改色
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            // 2. 连接中状态：叠加旋转虚线圆环（纯代码实现，无需额外素材）
            if (this.status === BluetoothStatus.CONNECTING) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Circle.create();
                        Circle.debugLine("entry/src/main/ets/common/components/BluetoothStatusIcon.ets(44:9)", "entry");
                        globalThis.Context.animation({
                            duration: 1500,
                            iterations: -1,
                            curve: Curve.Linear // 匀速旋转
                        });
                        Circle.width(this.iconSize + 6);
                        Circle.height(this.iconSize + 6);
                        Circle.strokeWidth(1.5);
                        Circle.stroke('#E2A75C');
                        Circle.strokeDashArray([4, 4]);
                        Circle.rotate({ angle: 360 });
                        globalThis.Context.animation(null);
                    }, Circle);
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        // 用Stack堆叠：底层蓝牙图标 + 连接中动画圆环
        Stack.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
