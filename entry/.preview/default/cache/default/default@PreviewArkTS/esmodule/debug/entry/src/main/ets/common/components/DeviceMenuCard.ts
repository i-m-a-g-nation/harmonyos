if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface DeviceMenuCard_Params {
    // 预留点击回调，后续绑定跳转直接传参即可
    onInfoClick?: () => void;
    onUpgradeClick?: () => void;
    onSyncClick?: () => void;
    onDiagnoseClick?: () => void;
}
export class DeviceMenuCard extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.onInfoClick = undefined;
        this.onUpgradeClick = undefined;
        this.onSyncClick = undefined;
        this.onDiagnoseClick = undefined;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: DeviceMenuCard_Params) {
        if (params.onInfoClick !== undefined) {
            this.onInfoClick = params.onInfoClick;
        }
        if (params.onUpgradeClick !== undefined) {
            this.onUpgradeClick = params.onUpgradeClick;
        }
        if (params.onSyncClick !== undefined) {
            this.onSyncClick = params.onSyncClick;
        }
        if (params.onDiagnoseClick !== undefined) {
            this.onDiagnoseClick = params.onDiagnoseClick;
        }
    }
    updateStateVars(params: DeviceMenuCard_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // 预留点击回调，后续绑定跳转直接传参即可
    private onInfoClick?: () => void;
    private onUpgradeClick?: () => void;
    private onSyncClick?: () => void;
    private onDiagnoseClick?: () => void;
    // 通用菜单项构建器
    MenuItem(icon: Resource, title: string, subTitle: string, isRoundBg: boolean, onClick?: () => void, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/common/components/DeviceMenuCard.ets(17:5)", "entry");
            Row.width('100%');
            Row.padding({ top: 14, bottom: 14 });
            Row.onClick(() => {
                onClick?.();
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 左侧：图标 + 浅绿背景
            Row.create();
            Row.debugLine("entry/src/main/ets/common/components/DeviceMenuCard.ets(19:7)", "entry");
            // 左侧：图标 + 浅绿背景
            Row.width(36);
            // 左侧：图标 + 浅绿背景
            Row.height(36);
            // 左侧：图标 + 浅绿背景
            Row.justifyContent(FlexAlign.Center);
            // 左侧：图标 + 浅绿背景
            Row.backgroundColor('rgba(58, 143, 126, 0.1)');
            // 左侧：图标 + 浅绿背景
            Row.borderRadius(isRoundBg ? 18 : 8);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create(icon);
            Image.debugLine("entry/src/main/ets/common/components/DeviceMenuCard.ets(20:9)", "entry");
            Image.width(20);
            Image.height(20);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        // 左侧：图标 + 浅绿背景
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 中间：标题 + 副标题
            Column.create({ space: 4 });
            Column.debugLine("entry/src/main/ets/common/components/DeviceMenuCard.ets(32:7)", "entry");
            // 中间：标题 + 副标题
            Column.margin({ left: 14 });
            // 中间：标题 + 副标题
            Column.alignItems(HorizontalAlign.Start);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(title);
            Text.debugLine("entry/src/main/ets/common/components/DeviceMenuCard.ets(33:9)", "entry");
            Text.fontSize(17);
            Text.fontColor('#1A1A1A');
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (subTitle.length > 0) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(subTitle);
                        Text.debugLine("entry/src/main/ets/common/components/DeviceMenuCard.ets(39:11)", "entry");
                        Text.fontSize(14);
                        Text.fontColor('#999999');
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
        // 中间：标题 + 副标题
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/common/components/DeviceMenuCard.ets(47:7)", "entry");
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 右侧：箭头
            Image.create({ "id": 16777264, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/common/components/DeviceMenuCard.ets(50:7)", "entry");
            // 右侧：箭头
            Image.width(18);
            // 右侧：箭头
            Image.height(18);
            // 右侧：箭头
            Image.objectFit(ImageFit.Contain);
        }, Image);
        Row.pop();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/common/components/DeviceMenuCard.ets(63:5)", "entry");
            Column.width('100%');
            Column.padding({ left: 16, right: 16 });
            Column.backgroundColor('#FFFFFF');
            Column.borderRadius(16);
        }, Column);
        this.MenuItem.bind(this)({ "id": 16777261, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }, '设备信息', '', false, this.onInfoClick);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Divider.create();
            Divider.debugLine("entry/src/main/ets/common/components/DeviceMenuCard.ets(72:7)", "entry");
            Divider.color('#F0F0F0');
        }, Divider);
        this.MenuItem.bind(this)({ "id": 16777263, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }, '固件升级', '当前已是最新版本 1.2.3', true, this.onUpgradeClick);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Divider.create();
            Divider.debugLine("entry/src/main/ets/common/components/DeviceMenuCard.ets(82:7)", "entry");
            Divider.color('#F0F0F0');
        }, Divider);
        this.MenuItem.bind(this)({ "id": 16777262, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }, '数据同步', '上次同步：今天 09:30', true, this.onSyncClick);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Divider.create();
            Divider.debugLine("entry/src/main/ets/common/components/DeviceMenuCard.ets(92:7)", "entry");
            Divider.color('#F0F0F0');
        }, Divider);
        this.MenuItem.bind(this)({ "id": 16777260, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" }, '连接诊断', '', true, this.onDiagnoseClick);
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
