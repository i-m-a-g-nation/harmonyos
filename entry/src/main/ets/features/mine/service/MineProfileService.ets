import {
  isMineProfileValid,
  MineProfile,
  normalizeMineProfile
} from '../model/MineProfileModel'
import { MineProfileRepository } from '../repository/MineProfileRepository'

/** UI 无关的个人资料业务层：负责规范化、校验和持久化协调。 */
export class MineProfileService {
  private readonly repository: MineProfileRepository

  constructor(repository: MineProfileRepository) {
    this.repository = repository
  }

  /** 返回值副本，避免页面直接修改 Repository 持有的对象。 */
  async loadProfile(): Promise<MineProfile> {
    const profile: MineProfile = await this.repository.loadProfile()
    return {
      name: profile.name,
      signature: profile.signature
    }
  }

  /**
   * 只有完整有效的资料才允许写入；持久化失败会继续向上传递，
   * 由页面保留草稿并展示失败状态。
   */
  async saveProfile(profile: MineProfile): Promise<MineProfile> {
    const normalizedProfile: MineProfile = normalizeMineProfile(profile)
    if (!isMineProfileValid(normalizedProfile)) {
      throw new Error('Invalid Mine profile')
    }

    await this.repository.saveProfile(normalizedProfile)
    return {
      name: normalizedProfile.name,
      signature: normalizedProfile.signature
    }
  }
}
