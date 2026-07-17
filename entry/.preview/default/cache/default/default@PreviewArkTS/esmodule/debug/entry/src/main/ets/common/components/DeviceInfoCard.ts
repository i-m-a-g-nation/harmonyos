if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface DeviceInfoCard_Params {
    deviceName?: string;
    isConnected?: boolean;
    batteryPercent?: number;
    firmwareVersion?: string;
    syncTime?: string;
}
export class DeviceInfoCard extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.deviceName = '办公健康终端 Pro';
        this.isConnected = true;
        this.batteryPercent = 78;
        this.firmwareVersion = '1.2.3';
        this.syncTime = '今天 09:30';
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: DeviceInfoCard_Params) {
        if (params.deviceName !== undefined) {
            this.deviceName = params.deviceName;
        }
        if (params.isConnected !== undefined) {
            this.isConnected = params.isConnected;
        }
        if (params.batteryPercent !== undefined) {
            this.batteryPercent = params.batteryPercent;
        }
        if (params.firmwareVersion !== undefined) {
            this.firmwareVersion = params.firmwareVersion;
        }
        if (params.syncTime !== undefined) {
            this.syncTime = params.syncTime;
        }
    }
    updateStateVars(params: DeviceInfoCard_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private deviceName: string;
    private isConnected: boolean;
    private batteryPercent: number;
    private firmwareVersion: string;
    private syncTime: string;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 16 });
            Row.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(10:5)", "entry");
            Row.width('100%');
            Row.padding(16);
            Row.backgroundColor('#FFFFFF');
            Row.borderRadius(16);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 左侧：设备主图，尺寸压低一些
            Image.create({ "id": 16777247, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(12:7)", "entry");
            // 左侧：设备主图，尺寸压低一些
            Image.width(100);
            // 左侧：设备主图，尺寸压低一些
            Image.height(100);
            // 左侧：设备主图，尺寸压低一些
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 右侧：信息列表
            Column.create({ space: 14 });
            Column.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(18:7)", "entry");
            // 右侧：信息列表
            Column.layoutWeight(1);
            // 右侧：信息列表
            Column.alignItems(HorizontalAlign.Start);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 设备名称 + 连接状态
            Column.create({ space: 6 });
            Column.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(20:9)", "entry");
            // 设备名称 + 连接状态
            Column.alignItems(HorizontalAlign.Start);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.deviceName);
            Text.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(21:11)", "entry");
            Text.fontSize(20);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor('#1A1A1A');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 8 });
            Row.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(26:11)", "entry");
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Circle.create({ width: 10, height: 10 });
            Circle.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(27:13)", "entry");
            Circle.fill(this.isConnected ? '#3A8F7E' : '#B0B3B8');
        }, Circle);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.isConnected ? '已连接' : '未连接');
            Text.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(29:13)", "entry");
            Text.fontSize(15);
            Text.fontColor(this.isConnected ? '#3A8F7E' : '#999999');
        }, Text);
        Text.pop();
        Row.pop();
        // 设备名称 + 连接状态
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Divider.create();
            Divider.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(36:9)", "entry");
            Divider.color('#F0F0F0');
        }, Divider);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 电量行
            Row.create();
            Row.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(40:9)", "entry");
            // 电量行
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 左侧图标+文字
            Row.create({ space: 10 });
            Row.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(42:11)", "entry");
            // 左侧图标+文字
            Row.layoutWeight(1);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777248, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(43:13)", "entry");
            Image.width(18);
            Image.height(18);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('电量');
            Text.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(47:13)", "entry");
            Text.fontSize(15);
            Text.fontColor('#666666');
        }, Text);
        Text.pop();
        // 左侧图标+文字
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 右侧电量数值 + 进度条
            Row.create({ space: 10 });
            Row.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(54:11)", "entry");
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${this.batteryPercent}%`);
            Text.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(55:13)", "entry");
            Text.fontSize(15);
            Text.fontColor('#1A1A1A');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(59:13)", "entry");
            Row.width(72);
            Row.height(14);
            Row.backgroundColor('#F0F0F0');
            Row.borderRadius(7);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(60:15)", "entry");
            Row.width(`${this.batteryPercent}%`);
            Row.height('100%');
            Row.backgroundColor('#52C41A');
            Row.borderRadius(6);
        }, Row);
        Row.pop();
        Row.pop();
        // 右侧电量数值 + 进度条
        Row.pop();
        // 电量行
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Divider.create();
            Divider.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(74:9)", "entry");
            Divider.color('#F0F0F0');
        }, Divider);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 固件版本行
            Row.create();
            Row.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(78:9)", "entry");
            // 固件版本行
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 10 });
            Row.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(79:11)", "entry");
            Row.layoutWeight(1);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777250, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(80:13)", "entry");
            Image.width(18);
            Image.height(18);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('固件版本');
            Text.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(84:13)", "entry");
            Text.fontSize(15);
            Text.fontColor('#666666');
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.firmwareVersion);
            Text.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(90:11)", "entry");
            Text.fontSize(15);
            Text.fontColor('#1A1A1A');
        }, Text);
        Text.pop();
        // 固件版本行
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Divider.create();
            Divider.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(96:9)", "entry");
            Divider.color('#F0F0F0');
        }, Divider);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 同步时间行
            Row.create();
            Row.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(100:9)", "entry");
            // 同步时间行
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 10 });
            Row.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(101:11)", "entry");
            Row.layoutWeight(1);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777249, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(102:13)", "entry");
            Image.width(18);
            Image.height(18);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('同步时间');
            Text.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(106:13)", "entry");
            Text.fontSize(15);
            Text.fontColor('#666666');
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.syncTime);
            Text.debugLine("entry/src/main/ets/common/components/DeviceInfoCard.ets(112:11)", "entry");
            Text.fontSize(15);
            Text.fontColor('#1A1A1A');
        }, Text);
        Text.pop();
        // 同步时间行
        Row.pop();
        // 右侧：信息列表
        Column.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
