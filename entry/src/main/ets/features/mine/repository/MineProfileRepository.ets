import { MineProfile } from '../model/MineProfileModel'

/**
 * Mine 个人资料持久化端口。
 *
 * Service 只依赖这个接口，不感知 Preferences；未来接入账号或云端时可以替换实现，
 * 无需修改页面和业务规则。
 */
export interface MineProfileRepository {
  loadProfile(): Promise<MineProfile>
  saveProfile(profile: MineProfile): Promise<void>
}
