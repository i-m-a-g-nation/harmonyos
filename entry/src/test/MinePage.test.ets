import { describe, it, expect } from '@ohos/hypium'
import {
  createMineMenuGroups,
  getMineDestinationKind,
  getMineDetailTitle,
  getMineNavigationDepth,
  MineDestinationKind,
  MineDetailRoute,
  MineMenuGroup,
  MineMenuItem
} from '../main/ets/features/mine/model/MinePageModel'
import {
  createMineFeedbackCategoryOptions,
  createMineHelpFaqItems,
  isMineFeedbackContentValid,
  MineFeedbackCategory,
  MineFeedbackCategoryOption,
  MineHelpFaqItem
} from '../main/ets/features/mine/model/MineHelpModel'
import {
  createMinePrivacyControls,
  MinePrivacyControl,
  MinePrivacyControlKey
} from '../main/ets/features/mine/model/MinePrivacyModel'

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

    it('selects independent Help and About destinations without changing other routes', 0, () => {
      // 该测试保护渐进式开发策略：已完成页面使用独立目的地，未完成入口继续使用统一空壳。
      // 如果以后实现新的二级页，应在此增加对应断言，防止菜单可点击但仍错误进入占位页。
      expect(getMineDestinationKind(MineDetailRoute.ABOUT))
        .assertEqual(MineDestinationKind.ABOUT)
      expect(getMineDestinationKind(MineDetailRoute.HELP))
        .assertEqual(MineDestinationKind.HELP)
      expect(getMineDestinationKind(MineDetailRoute.PROFILE))
        .assertEqual(MineDestinationKind.PLACEHOLDER)
      expect(getMineDestinationKind(MineDetailRoute.HEALTH_SETTINGS))
        .assertEqual(MineDestinationKind.PLACEHOLDER)
      expect(getMineDestinationKind(MineDetailRoute.DATA_MANAGEMENT))
        .assertEqual(MineDestinationKind.PLACEHOLDER)
      expect(getMineDestinationKind(MineDetailRoute.DEVICE_MANAGEMENT))
        .assertEqual(MineDestinationKind.PLACEHOLDER)
      expect(getMineDestinationKind(MineDetailRoute.PRIVACY))
        .assertEqual(MineDestinationKind.PRIVACY)
    })

    it('provides privacy controls in the approved order', 0, () => {
      const controls: MinePrivacyControl[] = createMinePrivacyControls()

      expect(controls.length).assertEqual(3)
      expect(controls.map((control: MinePrivacyControl): string =>
        `${control.key}|${control.label}|${control.defaultEnabled}`).join('\n'))
        .assertEqual([
          `${MinePrivacyControlKey.HEALTH_PERSONALIZATION}|健康数据个性化|true`,
          `${MinePrivacyControlKey.DEVICE_SYNC}|设备数据同步|true`,
          `${MinePrivacyControlKey.EXPERIENCE_PROGRAM}|体验改进计划|false`
        ].join('\n'))
    })

    it('provides Help FAQ items in the approved order', 0, () => {
      const faqItems: MineHelpFaqItem[] = createMineHelpFaqItems()

      expect(faqItems.length).assertEqual(3)
      expect(faqItems.map((item: MineHelpFaqItem): string =>
        `${item.question}|${item.answer}`).join('\n'))
        .assertEqual([
          '设备连接异常怎么办？|检查设备电量、蓝牙状态和设备距离，然后重新进入设备详情检查连接状态。',
          '数据没有及时更新怎么办？|保持手机与设备连接，等待同步完成；仍未更新时可重新连接设备。',
          '如何提交意见反馈？|选择问题类型并填写具体情况；当前版本只提供表单体验，内容不会发送。'
        ].join('\n'))
    })

    it('provides feedback categories in the approved order', 0, () => {
      const categories: MineFeedbackCategoryOption[] = createMineFeedbackCategoryOptions()

      expect(categories.length).assertEqual(4)
      expect(categories.map((category: MineFeedbackCategoryOption): string =>
        `${category.value}|${category.label}`).join('\n'))
        .assertEqual([
          `${MineFeedbackCategory.FEATURE}|功能建议`,
          `${MineFeedbackCategory.USAGE}|使用问题`,
          `${MineFeedbackCategory.DEVICE}|设备问题`,
          `${MineFeedbackCategory.OTHER}|其他`
        ].join('\n'))
    })

    it('validates trimmed feedback content from 1 through 300 characters', 0, () => {
      expect(isMineFeedbackContentValid('')).assertFalse()
      expect(isMineFeedbackContentValid('   ')).assertFalse()
      expect(isMineFeedbackContentValid('a')).assertTrue()
      expect(isMineFeedbackContentValid('a'.repeat(300))).assertTrue()
      expect(isMineFeedbackContentValid('a'.repeat(301))).assertFalse()
    })
  })
}
