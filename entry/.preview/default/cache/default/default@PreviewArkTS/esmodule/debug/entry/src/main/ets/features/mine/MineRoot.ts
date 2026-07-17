if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface MineRoot_Params {
    // 把功能内部状态转换成通用深度通知给 Index，避免向外泄漏 MineDetailRoute。
    onNavigationDepthChange?: (depth: number) => void;
    // 请求应用打开独立设备详情页；实际 URL 由 Index 决定。
    onOpenDeviceDetail?: () => void;
    pathStack?: NavPathStack;
}
import { getMineDetailTitle, getMineNavigationDepth } from "@normalized:N&&&entry/src/main/ets/features/mine/model/MinePageModel&";
import type { MineDetailRoute } from "@normalized:N&&&entry/src/main/ets/features/mine/model/MinePageModel&";
import { MineDetailPage } from "@normalized:N&&&entry/src/main/ets/features/mine/pages/MineDetailPage&";
import { MineHomePage } from "@normalized:N&&&entry/src/main/ets/features/mine/pages/MineHomePage&";
export class MineRoot extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.onNavigationDepthChange = undefined;
        this.onOpenDeviceDetail = undefined;
        this.pathStack = new NavPathStack();
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: MineRoot_Params) {
        if (params.onNavigationDepthChange !== undefined) {
            this.onNavigationDepthChange = params.onNavigationDepthChange;
        }
        if (params.onOpenDeviceDetail !== undefined) {
            this.onOpenDeviceDetail = params.onOpenDeviceDetail;
        }
        if (params.pathStack !== undefined) {
            this.pathStack = params.pathStack;
        }
    }
    updateStateVars(params: MineRoot_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // 把功能内部状态转换成通用深度通知给 Index，避免向外泄漏 MineDetailRoute。
    private onNavigationDepthChange?: (depth: number) => void;
    // 请求应用打开独立设备详情页；实际 URL 由 Index 决定。
    private onOpenDeviceDetail?: () => void;
    // Mine 私有导航栈。Navigation 组件会观察栈的 push/pop，无需把它声明成 @State。
    private readonly pathStack: NavPathStack;
    // Mine 首页入口点击后，把对应内部路由压入功能自己的导航栈。
    private openDetail(route: MineDetailRoute): void {
        this.pathStack.pushPath({ name: route });
    }
    // 自定义返回按钮调用 pop；系统返回也由 Navigation 按相同导航栈处理。
    private closeDetail(): void {
        this.pathStack.pop();
    }
    MineDestination(name: string, param: object, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            NavDestination.create(() => {
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let componentCall = new MineDetailPage(this, {
                                title: getMineDetailTitle(name as MineDetailRoute),
                                onBack: () => {
                                    this.closeDetail();
                                }
                            }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/features/mine/MineRoot.ets", line: 39, col: 7 });
                            ViewPU.create(componentCall);
                            let paramsLambda = () => {
                                return {
                                    title: getMineDetailTitle(name as MineDetailRoute),
                                    onBack: () => {
                                        this.closeDetail();
                                    }
                                };
                            };
                            componentCall.paramsGenerator_ = paramsLambda;
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {
                                title: getMineDetailTitle(name as MineDetailRoute)
                            });
                        }
                    }, { name: "MineDetailPage" });
                }
            }, { moduleName: "entry", pagePath: "entry/src/main/ets/features/mine/MineRoot" });
            NavDestination.hideTitleBar(true);
            NavDestination.debugLine("entry/src/main/ets/features/mine/MineRoot.ets(38:5)", "entry");
        }, NavDestination);
        NavDestination.pop();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 花括号中的 MineHomePage 是导航根页面；pushPath 后由 MineDestination 构建二级页。
            Navigation.create(this.pathStack, { moduleName: "entry", pagePath: "entry/src/main/ets/features/mine/MineRoot", isUserCreateStack: true });
            Navigation.debugLine("entry/src/main/ets/features/mine/MineRoot.ets(51:5)", "entry");
            // 花括号中的 MineHomePage 是导航根页面；pushPath 后由 MineDestination 构建二级页。
            Navigation.hideTitleBar(true);
            // 花括号中的 MineHomePage 是导航根页面；pushPath 后由 MineDestination 构建二级页。
            Navigation.mode(NavigationMode.Stack);
            // 花括号中的 MineHomePage 是导航根页面；pushPath 后由 MineDestination 构建二级页。
            Navigation.navDestination({ builder: this.MineDestination.bind(this) });
            // 花括号中的 MineHomePage 是导航根页面；pushPath 后由 MineDestination 构建二级页。
            Navigation.onNavBarStateChange((isVisible: boolean) => {
                this.onNavigationDepthChange?.(getMineNavigationDepth(isVisible, this.pathStack.size()));
            });
            // 花括号中的 MineHomePage 是导航根页面；pushPath 后由 MineDestination 构建二级页。
            Navigation.width('100%');
            // 花括号中的 MineHomePage 是导航根页面；pushPath 后由 MineDestination 构建二级页。
            Navigation.height('100%');
            // 花括号中的 MineHomePage 是导航根页面；pushPath 后由 MineDestination 构建二级页。
            Navigation.backgroundColor('#F7F8FA');
        }, Navigation);
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new MineHomePage(this, {
                        onOpenDetail: (route: MineDetailRoute) => {
                            this.openDetail(route);
                        },
                        onOpenDeviceDetail: () => {
                            this.onOpenDeviceDetail?.();
                        }
                    }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/features/mine/MineRoot.ets", line: 52, col: 7 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            onOpenDetail: (route: MineDetailRoute) => {
                                this.openDetail(route);
                            },
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
            }, { name: "MineHomePage" });
        }
        // 花括号中的 MineHomePage 是导航根页面；pushPath 后由 MineDestination 构建二级页。
        Navigation.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
