import { preferences } from '@kit.ArkData'
import { common } from '@kit.AbilityKit'
import {
  createDefaultMineProfile,
  isMineProfileValid,
  MineProfile,
  normalizeMineProfile
} from '../model/MineProfileModel'
import { MineProfileRepository } from './MineProfileRepository'

const MINE_PROFILE_STORE_NAME: string = 'mine_profile'
const PROFILE_NAME_KEY: string = 'profile_name'
const PROFILE_SIGNATURE_KEY: string = 'profile_signature'

/** 使用 HarmonyOS Preferences 保存 Mine 个人资料的本机实现。 */
export class PreferencesMineProfileRepository implements MineProfileRepository {
  private readonly context: common.Context
  private storePromise: Promise<preferences.Preferences> | null = null

  constructor(context: common.Context) {
    this.context = context
  }

  private async getStore(): Promise<preferences.Preferences> {
    if (this.storePromise === null) {
      try {
        this.storePromise = preferences.getPreferences(this.context, {
          name: MINE_PROFILE_STORE_NAME
        })
      } catch {
        throw new Error('Mine profile store initialization failed')
      }
    }

    try {
      return await this.storePromise
    } catch {
      // 初始化失败后允许下一次操作重新获取 Preferences，而不是永久缓存拒绝状态。
      this.storePromise = null
      throw new Error('Mine profile store initialization failed')
    }
  }

  /**
   * 读取到缺失、错误类型或非法组合时返回完整默认资料，
   * 避免将部分损坏的本机状态传播到 UI。
   */
  async loadProfile(): Promise<MineProfile> {
    const defaultProfile: MineProfile = createDefaultMineProfile()
    let nameValue: preferences.ValueType
    let signatureValue: preferences.ValueType
    try {
      const store: preferences.Preferences = await this.getStore()
      nameValue = await store.get(PROFILE_NAME_KEY, defaultProfile.name)
      signatureValue = await store.get(PROFILE_SIGNATURE_KEY, defaultProfile.signature)
    } catch {
      throw new Error('Mine profile read failed')
    }

    if (typeof nameValue !== 'string' || typeof signatureValue !== 'string') {
      return defaultProfile
    }

    const profile: MineProfile = normalizeMineProfile({
      name: nameValue,
      signature: signatureValue
    })
    return isMineProfileValid(profile) ? profile : defaultProfile
  }

  /** 写入两个字段后等待 flush 完成；异常不吞掉，由上层决定 UI 状态。 */
  async saveProfile(profile: MineProfile): Promise<void> {
    try {
      const store: preferences.Preferences = await this.getStore()
      await store.put(PROFILE_NAME_KEY, profile.name)
      await store.put(PROFILE_SIGNATURE_KEY, profile.signature)
      await store.flush()
    } catch {
      throw new Error('Mine profile write failed')
    }
  }
}
