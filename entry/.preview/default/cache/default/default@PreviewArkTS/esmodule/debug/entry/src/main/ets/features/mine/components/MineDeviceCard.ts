if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface MineDeviceCard_Params {
    // 由 MineRoot 最终转发给 Index，组件自身不知道 pages/Setting 的存在。
    onOpenDeviceDetail?: () => void;
}
export class MineDeviceCard extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.onOpenDeviceDetail = undefined;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: MineDeviceCard_Params) {
        if (params.onOpenDeviceDetail !== undefined) {
            this.onOpenDeviceDetail = params.onOpenDeviceDetail;
        }
    }
    updateStateVars(params: MineDeviceCard_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // 由 MineRoot 最终转发给 Index，组件自身不知道 pages/Setting 的存在。
    private onOpenDeviceDetail?: () => void;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 16 });
            Row.debugLine("entry/src/main/ets/features/mine/components/MineDeviceCard.ets(8:5)", "entry");
            Row.width('100%');
            Row.padding({ left: 18, right: 18, top: 14, bottom: 14 });
            Row.backgroundColor('#FFFFFF');
            Row.borderRadius(20);
            Row.shadow({
                radius: 18,
                color: 'rgba(0, 0, 0, 0.045)',
                offsetY: 4
            });
            Row.onClick(() => {
                this.onOpenDeviceDetail?.();
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777252, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/features/mine/components/MineDeviceCard.ets(9:7)", "entry");
            Image.width(68);
            Image.height(112);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 12 });
            Column.debugLine("entry/src/main/ets/features/mine/components/MineDeviceCard.ets(14:7)", "entry");
            Column.layoutWeight(1);
            Column.alignItems(HorizontalAlign.Start);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 8 });
            Row.debugLine("entry/src/main/ets/features/mine/components/MineDeviceCard.ets(15:9)", "entry");
            Row.width('100%');
            Row.alignItems(VerticalAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('办公健康终端 Pro');
            Text.debugLine("entry/src/main/ets/features/mine/components/MineDeviceCard.ets(16:11)", "entry");
            Text.fontSize(16);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor('#1A1A1A');
            Text.layoutWeight(1);
            Text.maxLines(1);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('已连接');
            Text.debugLine("entry/src/main/ets/features/mine/components/MineDeviceCard.ets(23:11)", "entry");
            Text.fontSize(12);
            Text.fontColor('#2E7D6F');
            Text.padding({ left: 10, right: 10, top: 5, bottom: 5 });
            Text.backgroundColor('#EEF6F2');
            Text.borderRadius(12);
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 10 });
            Row.debugLine("entry/src/main/ets/features/mine/components/MineDeviceCard.ets(33:9)", "entry");
            Row.alignItems(VerticalAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('电量');
            Text.debugLine("entry/src/main/ets/features/mine/components/MineDeviceCard.ets(34:11)", "entry");
            Text.width(62);
            Text.fontSize(14);
            Text.fontColor('#777A7E');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('78%');
            Text.debugLine("entry/src/main/ets/features/mine/components/MineDeviceCard.ets(39:11)", "entry");
            Text.fontSize(14);
            Text.fontColor('#777A7E');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777253, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/features/mine/components/MineDeviceCard.ets(43:11)", "entry");
            Image.width(24);
            Image.height(18);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        Row.pop();
        this.DeviceInfoRow.bind(this)('固件版本', '1.2.3');
        this.DeviceInfoRow.bind(this)('同步时间', '今天 09:30');
        Column.pop();
        Row.pop();
    }
    // 卡片内部的小型重复布局，未单独拆组件以避免产生过细文件。
    DeviceInfoRow(label: string, value: string, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 10 });
            Row.debugLine("entry/src/main/ets/features/mine/components/MineDeviceCard.ets(74:5)", "entry");
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(label);
            Text.debugLine("entry/src/main/ets/features/mine/components/MineDeviceCard.ets(75:7)", "entry");
            Text.width(62);
            Text.fontSize(14);
            Text.fontColor('#777A7E');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(value);
            Text.debugLine("entry/src/main/ets/features/mine/components/MineDeviceCard.ets(80:7)", "entry");
            Text.fontSize(14);
            Text.fontColor('#777A7E');
        }, Text);
        Text.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
