if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Mine_Params {
    btStatus?: BluetoothStatus;
    wifiLevel?: WifiSignalLevel;
    batteryLevel?: number;
    onDetailRouteChange?: (route: MineDetailRoute) => void;
    activeRoute?: MineDetailRoute;
    menuGroups?: MineMenuGroup[];
}
import { BluetoothStatus, WifiSignalLevel } from "@normalized:N&&&entry/src/main/ets/common/constants/StatusEnum&";
import { createMineMenuGroups, getMineDetailTitle, MineDetailRoute, MineMenuIconKey } from "@normalized:N&&&entry/src/main/ets/pages/mine/MinePageModel&";
import type { MineMenuGroup, MineMenuItem } from "@normalized:N&&&entry/src/main/ets/pages/mine/MinePageModel&";
export class Mine extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__btStatus = new SynchedPropertySimpleOneWayPU(params.btStatus, this, "btStatus");
        this.__wifiLevel = new SynchedPropertySimpleOneWayPU(params.wifiLevel, this, "wifiLevel");
        this.__batteryLevel = new SynchedPropertySimpleOneWayPU(params.batteryLevel, this, "batteryLevel");
        this.onDetailRouteChange = undefined;
        this.__activeRoute = new ObservedPropertySimplePU(MineDetailRoute.NONE, this, "activeRoute");
        this.menuGroups = createMineMenuGroups();
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Mine_Params) {
        if (params.btStatus === undefined) {
            this.__btStatus.set(BluetoothStatus.CONNECTED);
        }
        if (params.wifiLevel === undefined) {
            this.__wifiLevel.set(WifiSignalLevel.FULL);
        }
        if (params.batteryLevel === undefined) {
            this.__batteryLevel.set(85);
        }
        if (params.onDetailRouteChange !== undefined) {
            this.onDetailRouteChange = params.onDetailRouteChange;
        }
        if (params.activeRoute !== undefined) {
            this.activeRoute = params.activeRoute;
        }
        if (params.menuGroups !== undefined) {
            this.menuGroups = params.menuGroups;
        }
    }
    updateStateVars(params: Mine_Params) {
        this.__btStatus.reset(params.btStatus);
        this.__wifiLevel.reset(params.wifiLevel);
        this.__batteryLevel.reset(params.batteryLevel);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__btStatus.purgeDependencyOnElmtId(rmElmtId);
        this.__wifiLevel.purgeDependencyOnElmtId(rmElmtId);
        this.__batteryLevel.purgeDependencyOnElmtId(rmElmtId);
        this.__activeRoute.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__btStatus.aboutToBeDeleted();
        this.__wifiLevel.aboutToBeDeleted();
        this.__batteryLevel.aboutToBeDeleted();
        this.__activeRoute.aboutToBeDeleted();
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
    private onDetailRouteChange?: (route: MineDetailRoute) => void;
    private __activeRoute: ObservedPropertySimplePU<MineDetailRoute>;
    get activeRoute() {
        return this.__activeRoute.get();
    }
    set activeRoute(newValue: MineDetailRoute) {
        this.__activeRoute.set(newValue);
    }
    private readonly menuGroups: MineMenuGroup[];
    private openDetail(route: MineDetailRoute): void {
        this.activeRoute = route;
        this.onDetailRouteChange?.(route);
    }
    private closeDetail(): void {
        this.activeRoute = MineDetailRoute.NONE;
        this.onDetailRouteChange?.(MineDetailRoute.NONE);
    }
    private getMenuIcon(iconKey: MineMenuIconKey): Resource {
        switch (iconKey) {
            case MineMenuIconKey.HEALTH_SETTINGS:
                return { "id": 16777258, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" };
            case MineMenuIconKey.DATA_MANAGEMENT:
                return { "id": 16777254, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" };
            case MineMenuIconKey.DEVICE_MANAGEMENT:
                return { "id": 16777257, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" };
            case MineMenuIconKey.PRIVACY:
                return { "id": 16777246, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" };
            case MineMenuIconKey.HELP:
                return { "id": 16777255, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" };
            case MineMenuIconKey.ABOUT:
                return { "id": 16777259, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" };
            default:
                return { "id": 16777259, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" };
        }
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Mine.ets(53:5)", "entry");
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('#F7F8FA');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.activeRoute === MineDetailRoute.NONE) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.MineHome.bind(this)();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.DetailPage.bind(this)();
                });
            }
        }, If);
        If.pop();
        Column.pop();
    }
    MineHome(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Mine.ets(67:5)", "entry");
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('#F7F8FA');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            /*
            TopStatusBar({
              btStatus: this.btStatus,
              wifiLevel: this.wifiLevel,
              batteryLevel: this.batteryLevel
            })
            */
            Scroll.create();
            Scroll.debugLine("entry/src/main/ets/pages/Mine.ets(76:7)", "entry");
            /*
            TopStatusBar({
              btStatus: this.btStatus,
              wifiLevel: this.wifiLevel,
              batteryLevel: this.batteryLevel
            })
            */
            Scroll.layoutWeight(1);
            /*
            TopStatusBar({
              btStatus: this.btStatus,
              wifiLevel: this.wifiLevel,
              batteryLevel: this.batteryLevel
            })
            */
            Scroll.width('100%');
            /*
            TopStatusBar({
              btStatus: this.btStatus,
              wifiLevel: this.wifiLevel,
              batteryLevel: this.batteryLevel
            })
            */
            Scroll.scrollBar(BarState.Off);
        }, Scroll);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 14 });
            Column.debugLine("entry/src/main/ets/pages/Mine.ets(77:9)", "entry");
            Column.width('100%');
            Column.padding({ left: 20, right: 20, bottom: 12 });
        }, Column);
        this.ProfileSection.bind(this)();
        this.DeviceCard.bind(this)();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const group = _item;
                this.MenuGroupCard.bind(this)(group);
            };
            this.forEachUpdateFunction(elmtId, this.menuGroups, forEachItemGenFunction);
        }, ForEach);
        ForEach.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/pages/Mine.ets(85:11)", "entry");
            Blank.height(8);
        }, Blank);
        Blank.pop();
        Column.pop();
        /*
        TopStatusBar({
          btStatus: this.btStatus,
          wifiLevel: this.wifiLevel,
          batteryLevel: this.batteryLevel
        })
        */
        Scroll.pop();
        Column.pop();
    }
    DetailPage(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Mine.ets(101:5)", "entry");
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('#F7F8FA');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            /*
            TopStatusBar({
              btStatus: this.btStatus,
              wifiLevel: this.wifiLevel,
              batteryLevel: this.batteryLevel
            })
            */
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Mine.ets(110:7)", "entry");
            /*
            TopStatusBar({
              btStatus: this.btStatus,
              wifiLevel: this.wifiLevel,
              batteryLevel: this.batteryLevel
            })
            */
            Row.width('100%');
            /*
            TopStatusBar({
              btStatus: this.btStatus,
              wifiLevel: this.wifiLevel,
              batteryLevel: this.batteryLevel
            })
            */
            Row.height(52);
            /*
            TopStatusBar({
              btStatus: this.btStatus,
              wifiLevel: this.wifiLevel,
              batteryLevel: this.batteryLevel
            })
            */
            Row.padding({ left: 8, right: 8 });
            /*
            TopStatusBar({
              btStatus: this.btStatus,
              wifiLevel: this.wifiLevel,
              batteryLevel: this.batteryLevel
            })
            */
            Row.alignItems(VerticalAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Mine.ets(111:9)", "entry");
            Row.width(48);
            Row.height(48);
            Row.justifyContent(FlexAlign.Center);
            Row.onClick(() => {
                this.closeDetail();
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777256, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Mine.ets(112:11)", "entry");
            Image.width(22);
            Image.height(22);
            Image.objectFit(ImageFit.Contain);
            Image.rotate({ angle: 180 });
        }, Image);
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(getMineDetailTitle(this.activeRoute));
            Text.debugLine("entry/src/main/ets/pages/Mine.ets(125:9)", "entry");
            Text.fontSize(20);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor('#1A1A1A');
            Text.textAlign(TextAlign.Center);
            Text.layoutWeight(1);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/pages/Mine.ets(132:9)", "entry");
            Blank.width(48);
        }, Blank);
        Blank.pop();
        /*
        TopStatusBar({
          btStatus: this.btStatus,
          wifiLevel: this.wifiLevel,
          batteryLevel: this.batteryLevel
        })
        */
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/pages/Mine.ets(140:7)", "entry");
            Blank.layoutWeight(1);
        }, Blank);
        Blank.pop();
        Column.pop();
    }
    ProfileSection(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 18 });
            Row.debugLine("entry/src/main/ets/pages/Mine.ets(150:5)", "entry");
            Row.width('100%');
            Row.padding({ top: 8, bottom: 6 });
            Row.alignItems(VerticalAlign.Center);
            Row.onClick(() => {
                this.openDetail(MineDetailRoute.PROFILE);
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777251, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Mine.ets(151:7)", "entry");
            Image.width(64);
            Image.height(64);
            Image.borderRadius(32);
            Image.objectFit(ImageFit.Cover);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 7 });
            Column.debugLine("entry/src/main/ets/pages/Mine.ets(157:7)", "entry");
            Column.alignItems(HorizontalAlign.Start);
            Column.layoutWeight(1);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('张小悦');
            Text.debugLine("entry/src/main/ets/pages/Mine.ets(158:9)", "entry");
            Text.fontSize(23);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor('#1A1A1A');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('健康办公，高效生活');
            Text.debugLine("entry/src/main/ets/pages/Mine.ets(163:9)", "entry");
            Text.fontSize(14);
            Text.fontColor('#5F6266');
        }, Text);
        Text.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777256, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Mine.ets(170:7)", "entry");
            Image.width(22);
            Image.height(22);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        Row.pop();
    }
    DeviceCard(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 16 });
            Row.debugLine("entry/src/main/ets/pages/Mine.ets(185:5)", "entry");
            Row.width('100%');
            Row.padding({ left: 18, right: 18, top: 14, bottom: 14 });
            Row.backgroundColor('#FFFFFF');
            Row.borderRadius(20);
            Row.shadow({
                radius: 18,
                color: 'rgba(0, 0, 0, 0.045)',
                offsetY: 4
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777252, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Mine.ets(186:7)", "entry");
            Image.width(68);
            Image.height(112);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 12 });
            Column.debugLine("entry/src/main/ets/pages/Mine.ets(191:7)", "entry");
            Column.layoutWeight(1);
            Column.alignItems(HorizontalAlign.Start);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 8 });
            Row.debugLine("entry/src/main/ets/pages/Mine.ets(192:9)", "entry");
            Row.width('100%');
            Row.alignItems(VerticalAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('办公健康终端 Pro');
            Text.debugLine("entry/src/main/ets/pages/Mine.ets(193:11)", "entry");
            Text.fontSize(16);
            Text.fontWeight(FontWeight.Medium);
            Text.fontColor('#1A1A1A');
            Text.layoutWeight(1);
            Text.maxLines(1);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('已连接');
            Text.debugLine("entry/src/main/ets/pages/Mine.ets(200:11)", "entry");
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
            Row.debugLine("entry/src/main/ets/pages/Mine.ets(210:9)", "entry");
            Row.alignItems(VerticalAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('电量');
            Text.debugLine("entry/src/main/ets/pages/Mine.ets(211:11)", "entry");
            Text.width(62);
            Text.fontSize(14);
            Text.fontColor('#777A7E');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('78%');
            Text.debugLine("entry/src/main/ets/pages/Mine.ets(216:11)", "entry");
            Text.fontSize(14);
            Text.fontColor('#777A7E');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777253, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Mine.ets(220:11)", "entry");
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
    DeviceInfoRow(label: string, value: string, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 10 });
            Row.debugLine("entry/src/main/ets/pages/Mine.ets(246:5)", "entry");
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(label);
            Text.debugLine("entry/src/main/ets/pages/Mine.ets(247:7)", "entry");
            Text.width(62);
            Text.fontSize(14);
            Text.fontColor('#777A7E');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(value);
            Text.debugLine("entry/src/main/ets/pages/Mine.ets(252:7)", "entry");
            Text.fontSize(14);
            Text.fontColor('#777A7E');
        }, Text);
        Text.pop();
        Row.pop();
    }
    MenuGroupCard(group: MineMenuGroup, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Mine.ets(260:5)", "entry");
            Column.width('100%');
            Column.padding({ left: 18, right: 14 });
            Column.backgroundColor('#FFFFFF');
            Column.borderRadius(18);
            Column.shadow({
                radius: 16,
                color: 'rgba(0, 0, 0, 0.035)',
                offsetY: 3
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = (_item, index: number) => {
                const item = _item;
                this.MenuRow.bind(this)(item);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    If.create();
                    if (index < group.items.length - 1) {
                        this.ifElseBranchUpdateFunction(0, () => {
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Divider.create();
                                Divider.debugLine("entry/src/main/ets/pages/Mine.ets(265:11)", "entry");
                                Divider.strokeWidth(0.6);
                                Divider.color('#E8EAEB');
                                Divider.margin({ left: 50 });
                            }, Divider);
                        });
                    }
                    else {
                        this.ifElseBranchUpdateFunction(1, () => {
                        });
                    }
                }, If);
                If.pop();
            };
            this.forEachUpdateFunction(elmtId, group.items, forEachItemGenFunction, undefined, true, false);
        }, ForEach);
        ForEach.pop();
        Column.pop();
    }
    MenuRow(item: MineMenuItem, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 16 });
            Row.debugLine("entry/src/main/ets/pages/Mine.ets(285:5)", "entry");
            Row.width('100%');
            Row.height(53);
            Row.alignItems(VerticalAlign.Center);
            Row.onClick(() => {
                this.openDetail(item.route);
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create(this.getMenuIcon(item.iconKey));
            Image.debugLine("entry/src/main/ets/pages/Mine.ets(286:7)", "entry");
            Image.width(24);
            Image.height(24);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(item.label);
            Text.debugLine("entry/src/main/ets/pages/Mine.ets(291:7)", "entry");
            Text.fontSize(17);
            Text.fontColor('#252729');
            Text.layoutWeight(1);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777256, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Mine.ets(296:7)", "entry");
            Image.width(20);
            Image.height(20);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
