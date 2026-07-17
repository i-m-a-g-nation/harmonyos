if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface TopStatusBar_Params {
    btStatus?: BluetoothStatus;
    wifiLevel?: WifiSignalLevel;
    batteryLevel?: number;
    currentTime?: string;
    timerId?: number;
}
import { BluetoothStatus } from "@normalized:N&&&entry/src/main/ets/common/constants/StatusEnum&";
import { WifiSignalLevel } from "@normalized:N&&&entry/src/main/ets/common/constants/StatusEnum&";
import { BluetoothStatusIcon } from "@normalized:N&&&entry/src/main/ets/common/components/BluetoothStatusIcon&";
import { WifiSignalIcon } from "@normalized:N&&&entry/src/main/ets/common/components/WifiSignalIcon&";
import { BatteryIcon } from "@normalized:N&&&entry/src/main/ets/common/components/BatteryIcon&";
export class TopStatusBar extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__btStatus = new SynchedPropertySimpleOneWayPU(params.btStatus, this, "btStatus");
        this.__wifiLevel = new SynchedPropertySimpleOneWayPU(params.wifiLevel, this, "wifiLevel");
        this.__batteryLevel = new SynchedPropertySimpleOneWayPU(params.batteryLevel, this, "batteryLevel");
        this.__currentTime = new ObservedPropertySimplePU(''
        // 定时器ID，用于销毁时清除
        , this, "currentTime");
        this.timerId = -1;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: TopStatusBar_Params) {
        if (params.btStatus === undefined) {
            this.__btStatus.set(BluetoothStatus.CONNECTED);
        }
        if (params.wifiLevel === undefined) {
            this.__wifiLevel.set(WifiSignalLevel.FULL);
        }
        if (params.batteryLevel === undefined) {
            this.__batteryLevel.set(85
            // 内部维护的真实时间
            );
        }
        if (params.currentTime !== undefined) {
            this.currentTime = params.currentTime;
        }
        if (params.timerId !== undefined) {
            this.timerId = params.timerId;
        }
    }
    updateStateVars(params: TopStatusBar_Params) {
        this.__btStatus.reset(params.btStatus);
        this.__wifiLevel.reset(params.wifiLevel);
        this.__batteryLevel.reset(params.batteryLevel);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__btStatus.purgeDependencyOnElmtId(rmElmtId);
        this.__wifiLevel.purgeDependencyOnElmtId(rmElmtId);
        this.__batteryLevel.purgeDependencyOnElmtId(rmElmtId);
        this.__currentTime.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__btStatus.aboutToBeDeleted();
        this.__wifiLevel.aboutToBeDeleted();
        this.__batteryLevel.aboutToBeDeleted();
        this.__currentTime.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // 对外状态参数
    private __btStatus: SynchedPropertySimpleOneWayPU<BluetoothStatus>;
    get btStatus() {
        return this.__btStatus.get();
    }
    set btStatus(newValue: BluetoothStatus) {
        this.__btStatus.set(newValue);
    }
    private __wifiLevel: SynchedPropertySimpleOneWayPU<WifiSignalLevel>;
    get wifiLevel() {
        return this.__wifiLevel.get();
    }
    set wifiLevel(newValue: WifiSignalLevel) {
        this.__wifiLevel.set(newValue);
    }
    private __batteryLevel: SynchedPropertySimpleOneWayPU<number>;
    get batteryLevel() {
        return this.__batteryLevel.get();
    }
    set batteryLevel(newValue: number) {
        this.__batteryLevel.set(newValue);
    }
    // 内部维护的真实时间
    private __currentTime: ObservedPropertySimplePU<string>;
    get currentTime() {
        return this.__currentTime.get();
    }
    set currentTime(newValue: string) {
        this.__currentTime.set(newValue);
    }
    // 定时器ID，用于销毁时清除
    private timerId: number;
    /**
     * 获取并格式化当前时间：时:分
     * 分钟自动补零，小时不补零，和系统状态栏样式一致
     */
    private updateTime(): void {
        const now = new Date();
        const hour = now.getHours();
        const minute = now.getMinutes().toString().padStart(2, '0');
        this.currentTime = `${hour}:${minute}`;
    }
    aboutToAppear(): void {
        // 进入页面立即刷新一次时间，避免空白
        this.updateTime();
        // 每分钟更新一次，兼顾准确和功耗
        this.timerId = setInterval(() => {
            this.updateTime();
        }, 60 * 1000);
    }
    aboutToDisappear(): void {
        // 页面销毁时清除定时器，防止内存泄漏
        if (this.timerId !== -1) {
            clearInterval(this.timerId);
            this.timerId = -1;
        }
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/common/components/TopStatusBar.ets(48:5)", "entry");
            Row.width('100%');
            Row.padding({ left: 20, right: 20, top: 12, bottom: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 左侧：真实系统时间
            Text.create(this.currentTime);
            Text.debugLine("entry/src/main/ets/common/components/TopStatusBar.ets(50:7)", "entry");
            // 左侧：真实系统时间
            Text.fontSize(15);
            // 左侧：真实系统时间
            Text.fontColor('#1A1A1A');
            // 左侧：真实系统时间
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        // 左侧：真实系统时间
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/common/components/TopStatusBar.ets(55:7)", "entry");
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 右侧：状态图标组
            Row.create({ space: 12 });
            Row.debugLine("entry/src/main/ets/common/components/TopStatusBar.ets(58:7)", "entry");
        }, Row);
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new BluetoothStatusIcon(this, {
                        status: this.btStatus,
                        iconSize: 15
                    }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/common/components/TopStatusBar.ets", line: 59, col: 9 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            status: this.btStatus,
                            iconSize: 15
                        };
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {
                        status: this.btStatus,
                        iconSize: 15
                    });
                }
            }, { name: "BluetoothStatusIcon" });
        }
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new WifiSignalIcon(this, {
                        level: this.wifiLevel,
                        iconSize: 15
                    }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/common/components/TopStatusBar.ets", line: 64, col: 9 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            level: this.wifiLevel,
                            iconSize: 15
                        };
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {
                        level: this.wifiLevel,
                        iconSize: 15
                    });
                }
            }, { name: "WifiSignalIcon" });
        }
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new BatteryIcon(this, {
                        batteryLevel: this.batteryLevel,
                        iconSize: 19
                    }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/common/components/TopStatusBar.ets", line: 69, col: 9 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            batteryLevel: this.batteryLevel,
                            iconSize: 19
                        };
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {
                        batteryLevel: this.batteryLevel,
                        iconSize: 19
                    });
                }
            }, { name: "BatteryIcon" });
        }
        // 右侧：状态图标组
        Row.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
