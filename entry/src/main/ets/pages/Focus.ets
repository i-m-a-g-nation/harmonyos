/**
 * 专注页面入口（entry层包装）
 * 从 feature_focus HAR 中导入 FocusPage 组件
 */
import { FocusPage as FocusPageContent } from 'feature_focus';

@Entry
@Component
struct FocusPage {
  build() {
    Column() {
      FocusPageContent()
    }
    .width('100%').height('100%')
  }
}