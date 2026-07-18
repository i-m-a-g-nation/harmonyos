import { describe, expect, it } from '@ohos/hypium';
import { FocusSummary } from '../main/ets/model/FocusSummary';

/**
 * shared 模块的主机单元测试入口。
 *
 * Hvigor 会在执行全工程 test 任务时固定加载每个模块的
 * src/test/List.test.ets，因此即使模块只有公共类型，也必须保留此入口。
 */
export default function testsuite(): void {
  describe('SharedModule', () => {
    it('keepsFocusSummaryContract', 0, () => {
      // 用真实对象保护跨模块共享的数据契约，避免测试入口退化为空壳。
      const summary: FocusSummary = {
        focusedMinutes: 25,
        completedPomodoros: 1
      };

      expect(summary.focusedMinutes).assertEqual(25);
      expect(summary.completedPomodoros).assertEqual(1);
    });
  });
}
