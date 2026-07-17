if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface MineMenuGroupCard_Params {
    group?: MineMenuGroup;
    onOpenDetail?: (route: MineDetailRoute) => void;
}
import { MineMenuIconKey } from "@normalized:N&&&entry/src/main/ets/features/mine/model/MinePageModel&";
import type { MineDetailRoute, MineMenuGroup, MineMenuItem } from "@normalized:N&&&entry/src/main/ets/features/mine/model/MinePageModel&";
export class MineMenuGroupCard extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__group = new SynchedPropertyObjectOneWayPU(params.group, this, "group");
        this.onOpenDetail = undefined;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: MineMenuGroupCard_Params) {
        if (params.group === undefined) {
            this.__group.set({ items: [] });
        }
        if (params.onOpenDetail !== undefined) {
            this.onOpenDetail = params.onOpenDetail;
        }
    }
    updateStateVars(params: MineMenuGroupCard_Params) {
        this.__group.reset(params.group);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__group.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__group.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // @Prop 表示数据由父组件传入；本组件只读取，不负责修改菜单模型。
    private __group: SynchedPropertySimpleOneWayPU<MineMenuGroup>;
    get group() {
        return this.__group.get();
    }
    set group(newValue: MineMenuGroup) {
        this.__group.set(newValue);
    }
    private onOpenDetail?: (route: MineDetailRoute) => void;
    // 资源选择留在 UI 层，纯模型只保存稳定的语义键，便于单元测试。
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
            Column.debugLine("entry/src/main/ets/features/mine/components/MineMenuGroupCard.ets(36:5)", "entry");
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
            // route 唯一且稳定，因此可作为 ForEach 节点 key。
            ForEach.create();
            const forEachItemGenFunction = (_item, index: number) => {
                const item = _item;
                this.MenuRow.bind(this)(item);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    If.create();
                    if (index < this.group.items.length - 1) {
                        this.ifElseBranchUpdateFunction(0, () => {
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Divider.create();
                                Divider.debugLine("entry/src/main/ets/features/mine/components/MineMenuGroupCard.ets(42:11)", "entry");
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
            this.forEachUpdateFunction(elmtId, this.group.items, forEachItemGenFunction, (item: MineMenuItem) => item.route, true, false);
        }, ForEach);
        // route 唯一且稳定，因此可作为 ForEach 节点 key。
        ForEach.pop();
        Column.pop();
    }
    // 同一分组中的标准菜单行；点击时只上报 route，不在这里执行导航。
    MenuRow(item: MineMenuItem, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 16 });
            Row.debugLine("entry/src/main/ets/features/mine/components/MineMenuGroupCard.ets(63:5)", "entry");
            Row.width('100%');
            Row.height(53);
            Row.alignItems(VerticalAlign.Center);
            Row.onClick(() => {
                this.onOpenDetail?.(item.route);
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create(this.getMenuIcon(item.iconKey));
            Image.debugLine("entry/src/main/ets/features/mine/components/MineMenuGroupCard.ets(64:7)", "entry");
            Image.width(24);
            Image.height(24);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(item.label);
            Text.debugLine("entry/src/main/ets/features/mine/components/MineMenuGroupCard.ets(69:7)", "entry");
            Text.fontSize(17);
            Text.fontColor('#252729');
            Text.layoutWeight(1);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777256, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/features/mine/components/MineMenuGroupCard.ets(74:7)", "entry");
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
