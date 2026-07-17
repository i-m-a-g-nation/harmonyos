/**
 * feature_focus 唯一公共出口
 * 严格遵循团队规范：仅暴露必要能力，隐藏内部实现
 */
export { FocusPage } from './src/main/ets/pages/FocusPage';
export { createFocusFeature } from './src/main/ets/state/focusViewModel';
export type { FocusFeature } from './src/main/ets/state/focusViewModel';
export { FocusPhase, FocusRule } from './src/main/ets/service/focusService';
export type { SessionSnapshot } from './src/main/ets/service/focusService';

