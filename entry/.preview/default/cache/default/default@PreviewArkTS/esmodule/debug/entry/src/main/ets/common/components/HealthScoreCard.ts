if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface HealthScoreCard_Params {
    score?: number;
    CIRCLE_DIAMETER?: number;
    STROKE_WIDTH?: number;
    CIRCUMFERENCE?: number;
    TOTAL_ARC_LENGTH?: number;
}
export class HealthScoreCard extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__score = new SynchedPropertySimpleOneWayPU(params.score, this, "score");
        this.CIRCLE_DIAMETER = 150;
        this.STROKE_WIDTH = 10;
        this.CIRCUMFERENCE = this.CIRCLE_DIAMETER * Math.PI;
        this.TOTAL_ARC_LENGTH = this.CIRCUMFERENCE * 0.75 // 270°总弧长
        ;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: HealthScoreCard_Params) {
        if (params.score === undefined) {
            this.__score.set(86
            // 缩小圆环尺寸，降低卡片高度
            );
        }
        if (params.CIRCLE_DIAMETER !== undefined) {
            this.CIRCLE_DIAMETER = params.CIRCLE_DIAMETER;
        }
        if (params.STROKE_WIDTH !== undefined) {
            this.STROKE_WIDTH = params.STROKE_WIDTH;
        }
        if (params.CIRCUMFERENCE !== undefined) {
            this.CIRCUMFERENCE = params.CIRCUMFERENCE;
        }
        if (params.TOTAL_ARC_LENGTH !== undefined) {
            this.TOTAL_ARC_LENGTH = params.TOTAL_ARC_LENGTH;
        }
    }
    updateStateVars(params: HealthScoreCard_Params) {
        this.__score.reset(params.score);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__score.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__score.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __score: SynchedPropertySimpleOneWayPU<number>;
    get score() {
        return this.__score.get();
    }
    set score(newValue: number) {
        this.__score.set(newValue);
    }
    // 缩小圆环尺寸，降低卡片高度
    private readonly CIRCLE_DIAMETER: number;
    private readonly STROKE_WIDTH: number;
    private readonly CIRCUMFERENCE: number;
    private readonly TOTAL_ARC_LENGTH: number; // 270°总弧长
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/common/components/HealthScoreCard.ets(32:5)", "entry");
            Column.width('100%');
            Column.padding({ left: 16, right: 16, top: 8, bottom: 10 });
            Column.backgroundColor('#FFFFFF');
            Column.borderRadius(24);
            Column.shadow({
                radius: 20,
                color: 'rgba(0, 0, 0, 0.04)',
                offsetY: 4
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create({ alignContent: Alignment.Center });
            Stack.debugLine("entry/src/main/ets/common/components/HealthScoreCard.ets(33:7)", "entry");
            Stack.width('100%');
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 底层灰色轨道
            Circle.create();
            Circle.debugLine("entry/src/main/ets/common/components/HealthScoreCard.ets(35:9)", "entry");
            // 底层灰色轨道
            Circle.width(this.CIRCLE_DIAMETER);
            // 底层灰色轨道
            Circle.height(this.CIRCLE_DIAMETER);
            // 底层灰色轨道
            Circle.fill(Color.Transparent);
            // 底层灰色轨道
            Circle.strokeWidth(this.STROKE_WIDTH);
            // 底层灰色轨道
            Circle.stroke(0xFFE8EAEB);
            // 底层灰色轨道
            Circle.strokeDashArray([this.TOTAL_ARC_LENGTH, this.CIRCUMFERENCE - this.TOTAL_ARC_LENGTH]);
            // 底层灰色轨道
            Circle.strokeLineCap(LineCapStyle.Round);
            // 底层灰色轨道
            Circle.rotate({ angle: 135 });
        }, Circle);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 上层绿色进度
            Circle.create();
            Circle.debugLine("entry/src/main/ets/common/components/HealthScoreCard.ets(46:9)", "entry");
            globalThis.Context.animation({
                duration: 1000,
                curve: Curve.EaseOut
            });
            // 上层绿色进度
            Circle.width(this.CIRCLE_DIAMETER);
            // 上层绿色进度
            Circle.height(this.CIRCLE_DIAMETER);
            // 上层绿色进度
            Circle.fill(Color.Transparent);
            // 上层绿色进度
            Circle.strokeWidth(this.STROKE_WIDTH);
            // 上层绿色进度
            Circle.stroke(this.levelColor);
            // 上层绿色进度
            Circle.strokeDashArray([this.progressArcLength, this.CIRCUMFERENCE]);
            // 上层绿色进度
            Circle.strokeLineCap(LineCapStyle.Round);
            // 上层绿色进度
            Circle.rotate({ angle: 135 });
            globalThis.Context.animation(null);
        }, Circle);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 中间文字
            Column.create({ space: 4 });
            Column.debugLine("entry/src/main/ets/common/components/HealthScoreCard.ets(61:9)", "entry");
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${this.score}`);
            Text.debugLine("entry/src/main/ets/common/components/HealthScoreCard.ets(62:11)", "entry");
            Text.fontSize(38);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor('#1A1A1A');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.levelText);
            Text.debugLine("entry/src/main/ets/common/components/HealthScoreCard.ets(67:11)", "entry");
            Text.fontSize(15);
            Text.fontColor(this.levelColor);
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('今日办公健康总分');
            Text.debugLine("entry/src/main/ets/common/components/HealthScoreCard.ets(72:11)", "entry");
            Text.fontSize(12);
            Text.fontColor('#666666');
            Text.margin({ top: 2 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 12 });
            Row.debugLine("entry/src/main/ets/common/components/HealthScoreCard.ets(77:11)", "entry");
            Row.margin({ top: 2 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('较上周 +5');
            Text.debugLine("entry/src/main/ets/common/components/HealthScoreCard.ets(78:13)", "entry");
            Text.fontSize(11);
            Text.fontColor('#999999');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('|');
            Text.debugLine("entry/src/main/ets/common/components/HealthScoreCard.ets(81:13)", "entry");
            Text.fontSize(11);
            Text.fontColor('#E0E0E0');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('较上月 +9');
            Text.debugLine("entry/src/main/ets/common/components/HealthScoreCard.ets(84:13)", "entry");
            Text.fontSize(11);
            Text.fontColor('#999999');
        }, Text);
        Text.pop();
        Row.pop();
        // 中间文字
        Column.pop();
        Stack.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
