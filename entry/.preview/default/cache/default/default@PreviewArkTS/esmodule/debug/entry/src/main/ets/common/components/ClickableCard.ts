if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface ClickableCard_Params {
    onTap?: () => void;
    scaleRate?: number;
    isPressed?: boolean;
    content?: () => void;
}
export class ClickableCard extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.onTap = undefined;
        this.scaleRate = 0.96;
        this.__isPressed = new ObservedPropertySimplePU(false
        // 新增：默认空构建函数，满足本地初始化要求
        , this, "isPressed");
        this.content = this.defaultContent;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: ClickableCard_Params) {
        if (params.onTap !== undefined) {
            this.onTap = params.onTap;
        }
        if (params.scaleRate !== undefined) {
            this.scaleRate = params.scaleRate;
        }
        if (params.isPressed !== undefined) {
            this.isPressed = params.isPressed;
        }
        if (params.content !== undefined) {
            this.content = params.content;
        }
    }
    updateStateVars(params: ClickableCard_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__isPressed.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__isPressed.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private onTap?: () => void;
    private scaleRate: number;
    private __isPressed: ObservedPropertySimplePU<boolean>;
    get isPressed() {
        return this.__isPressed.get();
    }
    set isPressed(newValue: boolean) {
        this.__isPressed.set(newValue);
    }
    // 新增：默认空构建函数，满足本地初始化要求
    defaultContent(parent = null) { }
    // 给 BuilderParam 绑定默认值
    private __content;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create();
            Stack.debugLine("entry/src/main/ets/common/components/ClickableCard.ets(15:5)", "entry");
            globalThis.Context.animation({
                duration: 120,
                curve: Curve.EaseInOut
            });
            Stack.scale({
                x: this.isPressed ? this.scaleRate : 1,
                y: this.isPressed ? this.scaleRate : 1
            });
            globalThis.Context.animation(null);
            Stack.onTouch((event: TouchEvent) => {
                if (event.type === TouchType.Down) {
                    this.isPressed = true;
                }
                else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
                    this.isPressed = false;
                }
            });
            Stack.onClick(() => {
                this.onTap?.();
            });
        }, Stack);
        this.content.bind(this)();
        Stack.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
