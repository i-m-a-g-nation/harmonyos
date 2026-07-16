import { describe, it, expect } from '@ohos/hypium'
import {
  createMineMenuGroups,
  getMineDetailTitle,
  getMineNavigationDepth,
  MineDetailRoute,
  MineMenuGroup,
  MineMenuItem
} from '../main/ets/features/mine/model/MinePageModel'

/**
 * Mine 纯模型契约测试：保护菜单分组、内部路由、标题映射和壳层深度语义。
 * UI 样式不在主机单元测试中验证，仍需通过 ArkTS 编译和实机验收。
 */
export default function minePageTest() {
  describe('MinePageModel', () => {
    it('provides the approved grouped menu items', 0, () => {
      const groups: MineMenuGroup[] = createMineMenuGroups()
      const labels: string[] = []

      groups.forEach((group: MineMenuGroup) => {
        group.items.forEach((item: MineMenuItem) => {
          labels.push(item.label)
        })
      })

      expect(groups.length).assertEqual(2)
      expect(groups[0].items.length).assertEqual(4)
      expect(groups[1].items.length).assertEqual(2)
      expect(labels.join(',')).assertEqual('健康设置,数据管理,设备管理,系统与隐私,帮助与反馈,关于我们')
    })

    it('maps every secondary entry to a stable route and title', 0, () => {
      const groups: MineMenuGroup[] = createMineMenuGroups()
      const menuRoutes: MineDetailRoute[] = []

      groups.forEach((group: MineMenuGroup) => {
        group.items.forEach((item: MineMenuItem) => {
          menuRoutes.push(item.route)
        })
      })

      expect(menuRoutes.join(',')).assertEqual([
        MineDetailRoute.HEALTH_SETTINGS,
        MineDetailRoute.DATA_MANAGEMENT,
        MineDetailRoute.DEVICE_MANAGEMENT,
        MineDetailRoute.PRIVACY,
        MineDetailRoute.HELP,
        MineDetailRoute.ABOUT
      ].join(','))

      expect(getMineDetailTitle(MineDetailRoute.PROFILE)).assertEqual('个人资料')
      expect(getMineDetailTitle(MineDetailRoute.HEALTH_SETTINGS)).assertEqual('健康设置')
      expect(getMineDetailTitle(MineDetailRoute.DATA_MANAGEMENT)).assertEqual('数据管理')
      expect(getMineDetailTitle(MineDetailRoute.DEVICE_MANAGEMENT)).assertEqual('设备管理')
      expect(getMineDetailTitle(MineDetailRoute.PRIVACY)).assertEqual('系统与隐私')
      expect(getMineDetailTitle(MineDetailRoute.HELP)).assertEqual('帮助与反馈')
      expect(getMineDetailTitle(MineDetailRoute.ABOUT)).assertEqual('关于我们')
      expect(getMineDetailTitle(MineDetailRoute.NONE)).assertEqual('')
    })

    it('exposes only generic navigation depth to the app shell', 0, () => {
      expect(getMineNavigationDepth(true, 0)).assertEqual(0)
      expect(getMineNavigationDepth(false, 1)).assertEqual(1)
      expect(getMineNavigationDepth(false, 2)).assertEqual(2)
    })
  })
}
