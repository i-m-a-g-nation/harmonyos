if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface MineHomePage_Params {
    // 个人资料和菜单入口使用 Mine 内部 Navigation。
    onOpenDetail?: (route: MineDetailRoute) => void;
    // 设备卡片打开的是应用级独立页面，因此单独向根组件上报。
    onOpenDeviceDetail?: () => void;
    menuGroups?: MineMenuGroup[];
}
import { MineDeviceCard } from "@normalized:N&&&entry/src/main/ets/features/mine/components/MineDeviceCard&";
import { MineMenuGroupCard } from "@normalized:N&&&entry/src/main/ets/features/mine/components/MineMenuGroupCard&";
import { MineProfileSection } from "@normalized:N&&&entry/src/main/ets/features/mine/components/MineProfileSection&";
import { createMineMenuGroups, MineDetailRoute } from "@normalized:N&&&entry/src/main/ets/features/mine/model/MinePageModel&";
import type { MineMenuGroup } from "@normalized:N&&&entry/src/main/ets/features/mine/model/MinePageModel&";
export class MineHomePage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.onOpenDetail = undefined;
        this.onOpenDeviceDetail = undefined;
        this.menuGroups = createMineMenuGroups();
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: MineHomePage_Params) {
        if (params.onOpenDetail !== undefined) {
            this.onOpenDetail = params.onOpenDetail;
        }
        if (params.onOpenDeviceDetail !== undefined) {
            this.onOpenDeviceDetail = params.onOpenDeviceDetail;
        }
        if (params.menuGroups !== undefined) {
            this.menuGroups = params.menuGroups;
        }
    }
    updateStateVars(params: MineHomePage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // 个人资料和菜单入口使用 Mine 内部 Navigation。
    private onOpenDetail?: (route: MineDetailRoute) => void;
    // 设备卡片打开的是应用级独立页面，因此单独向根组件上报。
    private onOpenDeviceDetail?: () => void;
    // 菜单定义集中在 model，页面不重复维护标题、图标键和路由字符串。
    private readonly menuGroups: MineMenuGroup[];
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/features/mine/pages/MineHomePage.ets(25:5)", "entry");
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('#F7F8FA');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Scroll.create();
            Scroll.debugLine("entry/src/main/ets/features/mine/pages/MineHomePage.ets(26:7)", "entry");
            Scroll.layoutWeight(1);
            Scroll.width('100%');
            Scroll.scrollBar(BarState.Off);
        }, Scroll);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 14 });
            Column.debugLine("entry/src/main/ets/features/mine/pages/MineHomePage.ets(27:9)", "entry");
            Column.width('100%');
            Column.padding({ left: 20, right: 20, bottom: 12 });
        }, Column);
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new 
                    // 个人资料区：点击后进入 Mine 内部个人资料目的地。
                    MineProfileSection(this, {
                        onOpenProfile: () => {
                            this.onOpenDetail?.(MineDetailRoute.PROFILE);
                        }
                    }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/features/mine/pages/MineHomePage.ets", line: 29, col: 11 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            onOpenProfile: () => {
                                this.onOpenDetail?.(MineDetailRoute.PROFILE);
                            }
                        };
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, { name: "MineProfileSection" });
        }
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new 
                    // 设备卡片：整卡点击，通过回调链请求 Index 打开 pages/Setting。
                    MineDeviceCard(this, {
                        onOpenDeviceDetail: () => {
                            this.onOpenDeviceDetail?.();
                        }
                    }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/features/mine/pages/MineHomePage.ets", line: 36, col: 11 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            onOpenDeviceDetail: () => {
                                this.onOpenDeviceDetail?.();
                            }
                        };
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, { name: "MineDeviceCard" });
        }
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // model 返回两个菜单分组；每一行只把对应 MineDetailRoute 上报给根组件。
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const group = _item;
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new MineMenuGroupCard(this, {
                                group: group,
                                onOpenDetail: (route: MineDetailRoute) => {
                                    this.onOpenDetail?.(route);
                                }
                            }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/features/mine/pages/MineHomePage.ets", line: 44, col: 13 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {
                                    group: group,
                                    onOpenDetail: (route: MineDetailRoute) => {
                                        this.onOpenDetail?.(route);
                                    }
                                };
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {
                                group: group
                            });
                        }
                    }, { name: "MineMenuGroupCard" });
                }
            };
            this.forEachUpdateFunction(elmtId, this.menuGroups, forEachItemGenFunction);
        }, ForEach);
        // model 返回两个菜单分组；每一行只把对应 MineDetailRoute 上报给根组件。
        ForEach.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.debugLine("entry/src/main/ets/features/mine/pages/MineHomePage.ets(52:11)", "entry");
            Blank.height(8);
        }, Blank);
        Blank.pop();
        Column.pop();
        Scroll.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
