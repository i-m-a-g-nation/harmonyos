if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface BottomTabBar_Params {
    currentIndex?: number;
    onTabChange?: (index: number) => void;
    tabList?: TabItem[];
}
// 先显式声明 Tab 项的数据接口
interface TabItem {
    name: string;
    normalIcon: Resource;
    activeIcon: Resource;
    isCenter: boolean;
}
export class BottomTabBar extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__currentIndex = new SynchedPropertySimpleTwoWayPU(params.currentIndex, this, "currentIndex");
        this.onTabChange = undefined;
        this.tabList = [
            {
                name: '首页',
                normalIcon: { "id": 16777236, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                activeIcon: { "id": 16777239, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                isCenter: false
            },
            {
                name: '洞察',
                normalIcon: { "id": 16777238, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                activeIcon: { "id": 16777242, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                isCenter: false
            },
            {
                name: '专注',
                normalIcon: { "id": 16777237, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                activeIcon: { "id": 16777240, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                isCenter: true
            },
            {
                name: '我的',
                normalIcon: { "id": 16777241, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                activeIcon: { "id": 16777235, "type": 20000, params: [], "bundleName": "com.zhi.zuoan", "moduleName": "entry" },
                isCenter: false
            }
        ];
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: BottomTabBar_Params) {
        if (params.onTabChange !== undefined) {
            this.onTabChange = params.onTabChange;
        }
        if (params.tabList !== undefined) {
            this.tabList = params.tabList;
        }
    }
    updateStateVars(params: BottomTabBar_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__currentIndex.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__currentIndex.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __currentIndex: SynchedPropertySimpleTwoWayPU<number>;
    get currentIndex() {
        return this.__currentIndex.get();
    }
    set currentIndex(newValue: number) {
        this.__currentIndex.set(newValue);
    }
    private onTabChange?: (index: number) => void;
    // 指定数组的明确类型，避免类型推断失败
    private readonly tabList: TabItem[];
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/common/components/BottomTabBar.ets(43:5)", "entry");
            Row.width('100%');
            Row.height(56);
            Row.backgroundColor('#FFFFFF');
            Row.shadow({
                radius: 8,
                color: 'rgba(0, 0, 0, 0.03)',
                offsetY: -2
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = (_item, index: number) => {
                const item = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create({ space: 4 });
                    Column.debugLine("entry/src/main/ets/common/components/BottomTabBar.ets(45:9)", "entry");
                    Column.layoutWeight(1);
                    Column.justifyContent(FlexAlign.Center);
                    Column.margin({ top: 0 });
                    Column.onClick(() => {
                        this.currentIndex = index;
                        this.onTabChange?.(index);
                    });
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Image.create(this.currentIndex === index ? item.activeIcon : item.normalIcon);
                    Image.debugLine("entry/src/main/ets/common/components/BottomTabBar.ets(46:11)", "entry");
                    Image.width(24);
                    Image.height(24);
                    Image.objectFit(ImageFit.Contain);
                }, Image);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(item.name);
                    Text.debugLine("entry/src/main/ets/common/components/BottomTabBar.ets(51:11)", "entry");
                    Text.fontSize(12);
                    Text.fontColor(this.currentIndex === index ? '#3A8F7E' : '#999999');
                }, Text);
                Text.pop();
                Column.pop();
            };
            this.forEachUpdateFunction(elmtId, this.tabList, forEachItemGenFunction, undefined, true, false);
        }, ForEach);
        ForEach.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
