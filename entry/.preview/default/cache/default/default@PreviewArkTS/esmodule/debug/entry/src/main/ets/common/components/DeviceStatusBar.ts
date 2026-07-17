if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface DeviceStatusBar_Params {
    btStatus?: BluetoothStatus;
    // 点击回调
    onDeviceClick?: () => void;
    onNotifyClick?: () => void;
    onSettingClick?: () => void;
    notifyPressed?: boolean;
    settingPressed?: boolean;
}
import { BluetoothStatus } from "@normalized:N&&&entry/src/main/ets/common/constants/StatusEnum&";
export class DeviceStatusBar extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__btStatus = new SynchedPropertySimpleOneWayPU(params.btStatus, this, "btStatus");
        this.onDeviceClick = undefined;
        this.onNotifyClick = undefined;
        this.onSettingClick = undefined;
        this.__notifyPressed = new ObservedPropertySimplePU(false, this, "notifyPressed");
        this.__settingPressed = new ObservedPropertySimplePU(false, this, "settingPressed");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: DeviceStatusBar_Params) {
        if (params.btStatus === undefined) {
            this.__btStatus.set(BluetoothStatus.DISCONNECTED
            // 点击回调
            );
        }
        if (params.onDeviceClick !== undefined) {
            this.onDeviceClick = params.onDeviceClick;
        }
        if (params.onNotifyClick !== undefined) {
            this.onNotifyClick = params.onNotifyClick;
        }
        if (params.onSettingClick !== undefined) {
            this.onSettingClick = params.onSettingClick;
        }
        if (params.notifyPressed !== undefined) {
            this.notifyPressed = params.notifyPressed;
        }
        if (params.settingPressed !== undefined) {
            this.settingPressed = params.settingPressed;
        }
    }
    updateStateVars(params: DeviceStatusBar_Params) {
        this.__btStatus.reset(params.btStatus);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__btStatus.purgeDependencyOnElmtId(rmElmtId);
        this.__notifyPressed.purgeDependencyOnElmtId(rmElmtId);
        this.__settingPressed.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__btStatus.aboutToBeDeleted();
        this.__notifyPressed.aboutToBeDeleted();
        this.__settingPressed.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __btStatus: SynchedPropertySimpleOneWayPU<BluetoothStatus>;
    get btStatus() {
        return this.__btStatus.get();
    }
    set btStatus(newValue: BluetoothStatus) {
        this.__btStatus.set(newValue);
    }
    // 点击回调
    private onDeviceClick?: () => void;
    private onNotifyClick?: () => void;
    private onSettingClick?: () => void;
    // 按压状态，分别控制两个图标动效
    private __notifyPressed: ObservedPropertySimplePU<boolean>;
    get notifyPressed() {
        return this.__notifyPressed.get();
    }
    set notifyPressed(newValue: boolean) {
        this.__notifyPressed.set(newValue);
    }
    private __settingPressed: ObservedPropertySimplePU<boolean>;
    get settingPressed() {
        return this.__settingPressed.get();
    }
    set settingPressed(newValue: boolean) {
        this.__settingPressed.set(newValue);
    }
    private getDotColor(): ResourceColor {
        switch (this.btStatus) {
            case BluetoothStatus.CONNECTED:
                return '#3A8F7E';
            case BluetoothStatus.CONNECTING:
                return '#E2A75C';
            default:
                return '#B0B3B8';
        }
    }
    private getStatusText(): string {
        switch (this.btStatus) {
            case BluetoothStatus.CONNECTED:
                return '工位终端已连接';
            case BluetoothStatus.CONNECTING:
                return '连接中...';
            case BluetoothStatus.OFF:
                return '蓝牙未开启';
            default:
                return '设备未连接';
        }
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/common/components/DeviceStatusBar.ets(41:5)", "entry");
            Row.width('100%');
            Row.padding({ left: 20, right: 20, top: 8, bottom: 12 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 左侧设备状态区域
            Row.create({ space: 10 });
            Row.debugLine("entry/src/main/ets/common/components/DeviceStatusBar.ets(43:7)", "entry");
            // 左侧设备状态区域
            Row.onClick(() => {
                this.onDeviceClick?.();
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Circle.create({ width: 10, height: 10 });
            Circle.debugLine("entry/src/main/ets/common/components/DeviceStatusBar.ets(44:9)", "entry");
            globalThis.Context.animation({
                duration: 1000,
                iterations: -1,
                curve: Curve.EaseInOut
            });
            Circle.fill(this.getDotColor());
            Circle.opacity(this.btStatus === BluetoothStatus.CONNECTING ? 0.4 : 1);
            globalThis.Context.animation(null);
        }, Circle);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.getStatusText());
            Text.debugLine("entry/src/main/ets/common/components/DeviceStatusBar.ets(53:9)", "entry");
            Text.fontSize(16);
            Text.fontColor('#1A1A1A');
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        Text.pop();
        // 左侧设备状态区域
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/common/components/DeviceStatusBar.ets(62:7)", "entry");
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 右侧通知、设置图标
            Row.create({ space: 20 });
            Row.debugLine("entry/src/main/ets/common/components/DeviceStatusBar.ets(65:7)", "entry");
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 通知铃铛
            Image.create({ "id": 16777232, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/common/components/DeviceStatusBar.ets(67:9)", "entry");
            globalThis.Context.animation({ duration: 120, curve: Curve.EaseInOut });
            // 通知铃铛
            Image.width(22);
            // 通知铃铛
            Image.height(22);
            // 通知铃铛
            Image.objectFit(ImageFit.Contain);
            // 通知铃铛
            Image.scale({
                x: this.notifyPressed ? 0.9 : 1,
                y: this.notifyPressed ? 0.9 : 1
            });
            globalThis.Context.animation(null);
            // 通知铃铛
            Image.onTouch((e: TouchEvent) => {
                if (e.type === TouchType.Down)
                    this.notifyPressed = true;
                else
                    this.notifyPressed = false;
            });
            // 通知铃铛
            Image.onClick(() => {
                this.onNotifyClick?.();
            });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 设置图标
            Image.create({ "id": 16777233, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/common/components/DeviceStatusBar.ets(85:9)", "entry");
            globalThis.Context.animation({ duration: 120, curve: Curve.EaseInOut });
            // 设置图标
            Image.width(22);
            // 设置图标
            Image.height(22);
            // 设置图标
            Image.objectFit(ImageFit.Contain);
            // 设置图标
            Image.scale({
                x: this.settingPressed ? 0.9 : 1,
                y: this.settingPressed ? 0.9 : 1
            });
            globalThis.Context.animation(null);
            // 设置图标
            Image.onTouch((e: TouchEvent) => {
                if (e.type === TouchType.Down)
                    this.settingPressed = true;
                else
                    this.settingPressed = false;
            });
            // 设置图标
            Image.onClick(() => {
                this.onSettingClick?.();
            });
        }, Image);
        // 右侧通知、设置图标
        Row.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
