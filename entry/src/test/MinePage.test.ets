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
import {
  createMineManagedDevices,
  MineManagedDevice
} from '../main/ets/features/mine/model/MineDeviceManagementModel'
import {
  createMineDataSummaryItems,
  MineDataSummaryItem
} from '../main/ets/features/mine/model/MineDataManagementModel'
import {
  adjustMineHealthGoal,
  createMineHealthGoals,
  MineHealthGoal,
  MineHealthGoalKey
} from '../main/ets/features/mine/model/MineHealthSettingsModel'
import {
  createDefaultMineProfile,
  isMineProfileNameValid,
  isMineProfileSignatureValid,
  MineProfile
} from '../main/ets/features/mine/model/MineProfileModel'
import { MineProfileRepository } from
  '../main/ets/features/mine/repository/MineProfileRepository'
import { MineProfileService } from
  '../main/ets/features/mine/service/MineProfileService'

/** 仅供主机单元测试使用的内存仓库，用真实 Service 验证业务边界。 */
class MemoryMineProfileRepository implements MineProfileRepository {
  profile: MineProfile = createDefaultMineProfile()
  saveCount: number = 0
  shouldFailSave: boolean = false

  async loadProfile(): Promise<MineProfile> {
    return {
      name: this.profile.name,
      signature: this.profile.signature
    }
  }

  async saveProfile(profile: MineProfile): Promise<void> {
    this.saveCount += 1
    if (this.shouldFailSave) {
      throw new Error('save failed')
    }
    this.profile = {
      name: profile.name,
      signature: profile.signature
    }
  }
}

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

    it('selects an independent destination for every normal secondary route', 0, () => {
      // NONE 仍作为防御性回退；所有用户可见入口必须拥有独立目的地。
      expect(getMineDestinationKind(MineDetailRoute.ABOUT))
        .assertEqual(MineDestinationKind.ABOUT)
      expect(getMineDestinationKind(MineDetailRoute.HELP))
        .assertEqual(MineDestinationKind.HELP)
      expect(getMineDestinationKind(MineDetailRoute.PROFILE))
        .assertEqual(MineDestinationKind.PROFILE)
      expect(getMineDestinationKind(MineDetailRoute.HEALTH_SETTINGS))
        .assertEqual(MineDestinationKind.HEALTH_SETTINGS)
      expect(getMineDestinationKind(MineDetailRoute.DATA_MANAGEMENT))
        .assertEqual(MineDestinationKind.DATA_MANAGEMENT)
      expect(getMineDestinationKind(MineDetailRoute.DEVICE_MANAGEMENT))
        .assertEqual(MineDestinationKind.DEVICE_MANAGEMENT)
      expect(getMineDestinationKind(MineDetailRoute.PRIVACY))
        .assertEqual(MineDestinationKind.PRIVACY)
      expect(getMineDestinationKind(MineDetailRoute.NONE))
        .assertEqual(MineDestinationKind.PLACEHOLDER)
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

    it('provides the managed device snapshot without application routing data', 0, () => {
      const devices: MineManagedDevice[] = createMineManagedDevices()

      expect(devices.length).assertEqual(1)
      expect(`${devices[0].id}|${devices[0].name}|${devices[0].connected}|` +
        `${devices[0].batteryLevel}|${devices[0].firmwareVersion}|${devices[0].lastSync}`)
        .assertEqual('office-terminal-pro|办公健康终端 Pro|true|78|1.2.3|今天 09:30')
    })

    it('provides data summary items in the approved order', 0, () => {
      const items: MineDataSummaryItem[] = createMineDataSummaryItems()

      expect(items.length).assertEqual(3)
      expect(items.map((item: MineDataSummaryItem): string =>
        `${item.id}|${item.label}|${item.value}`).join('\n'))
        .assertEqual([
          'health-records|健康记录|128 条',
          'device-records|设备记录|36 条',
          'last-sync|最近同步|今天 09:30'
        ].join('\n'))
    })

    it('provides health goals and clamps adjustments to their limits', 0, () => {
      const goals: MineHealthGoal[] = createMineHealthGoals()

      expect(goals.length).assertEqual(3)
      expect(goals.map((goal: MineHealthGoal): string =>
        `${goal.key}|${goal.defaultValue}|${goal.minimum}|${goal.maximum}|${goal.step}`).join('\n'))
        .assertEqual([
          `${MineHealthGoalKey.STEPS}|8000|1000|30000|1000`,
          `${MineHealthGoalKey.FOCUS}|60|15|240|15`,
          `${MineHealthGoalKey.WATER}|8|1|20|1`
        ].join('\n'))
      expect(adjustMineHealthGoal(1000, -1000, 1000, 30000)).assertEqual(1000)
      expect(adjustMineHealthGoal(30000, 1000, 1000, 30000)).assertEqual(30000)
      expect(adjustMineHealthGoal(8000, 1000, 1000, 30000)).assertEqual(9000)
    })

    it('validates profile name and signature boundaries', 0, () => {
      expect(isMineProfileNameValid('')).assertFalse()
      expect(isMineProfileNameValid('   ')).assertFalse()
      expect(isMineProfileNameValid('张')).assertTrue()
      expect(isMineProfileNameValid('a'.repeat(20))).assertTrue()
      expect(isMineProfileNameValid('a'.repeat(21))).assertFalse()
      expect(isMineProfileSignatureValid('')).assertTrue()
      expect(isMineProfileSignatureValid('a'.repeat(40))).assertTrue()
      expect(isMineProfileSignatureValid('a'.repeat(41))).assertFalse()
    })

    it('provides the approved default profile', 0, () => {
      const profile: MineProfile = createDefaultMineProfile()

      expect(profile.name).assertEqual('张小悦')
      expect(profile.signature).assertEqual('健康办公，高效生活')
    })

    it('loads profile data through the repository port', 0, async () => {
      const repository = new MemoryMineProfileRepository()
      repository.profile = { name: '林小满', signature: '专注当下' }
      const service = new MineProfileService(repository)

      const profile: MineProfile = await service.loadProfile()

      expect(profile.name).assertEqual('林小满')
      expect(profile.signature).assertEqual('专注当下')
    })

    it('normalizes and persists a valid profile', 0, async () => {
      const repository = new MemoryMineProfileRepository()
      const service = new MineProfileService(repository)

      const profile: MineProfile = await service.saveProfile({
        name: '  张小悦  ',
        signature: '保持节奏'
      })

      expect(profile.name).assertEqual('张小悦')
      expect(repository.profile.name).assertEqual('张小悦')
      expect(repository.profile.signature).assertEqual('保持节奏')
      expect(repository.saveCount).assertEqual(1)
    })

    it('rejects invalid profiles before repository access', 0, async () => {
      const repository = new MemoryMineProfileRepository()
      const service = new MineProfileService(repository)
      let rejectedCount: number = 0

      try {
        await service.saveProfile({ name: '   ', signature: '' })
      } catch {
        rejectedCount += 1
      }
      try {
        await service.saveProfile({ name: '张小悦', signature: 'a'.repeat(41) })
      } catch {
        rejectedCount += 1
      }

      expect(rejectedCount).assertEqual(2)
      expect(repository.saveCount).assertEqual(0)
    })

    it('propagates repository save failures', 0, async () => {
      const repository = new MemoryMineProfileRepository()
      repository.shouldFailSave = true
      const service = new MineProfileService(repository)
      let rejected: boolean = false

      try {
        await service.saveProfile({ name: '张小悦', signature: '保持节奏' })
      } catch {
        rejected = true
      }

      expect(rejected).assertTrue()
      expect(repository.saveCount).assertEqual(1)
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
