/** Mine 内部稳定的个人资料数据契约；头像仍由资源系统提供，不进入持久化模型。 */
export interface MineProfile {
  name: string
  signature: string
}

/** 每次返回新对象，避免调用方意外修改共享的默认值。 */
export function createDefaultMineProfile(): MineProfile {
  return {
    name: '张小悦',
    signature: '健康办公，高效生活'
  }
}

/** 昵称去除首尾空白后必须包含 1–20 个字符。 */
export function isMineProfileNameValid(name: string): boolean {
  const trimmedName: string = name.trim()
  return trimmedName.length >= 1 && trimmedName.length <= 20
}

/** 个性签名允许为空，但不能超过输入框约定的 40 个字符。 */
export function isMineProfileSignatureValid(signature: string): boolean {
  return signature.length <= 40
}

/** 保存前统一规范化，避免首页展示和本机存储保留无意义的昵称首尾空白。 */
export function normalizeMineProfile(profile: MineProfile): MineProfile {
  return {
    name: profile.name.trim(),
    signature: profile.signature
  }
}

/** Service 与 Repository 共用的完整资料校验，防止绕过页面按钮直接写入非法值。 */
export function isMineProfileValid(profile: MineProfile): boolean {
  return isMineProfileNameValid(profile.name) &&
    isMineProfileSignatureValid(profile.signature)
}
