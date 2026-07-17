/** 昵称去除首尾空白后必须包含 1–20 个字符。 */
export function isMineProfileNameValid(name: string): boolean {
  const trimmedName: string = name.trim()
  return trimmedName.length >= 1 && trimmedName.length <= 20
}

/** 个性签名允许为空，但不能超过输入框约定的 40 个字符。 */
export function isMineProfileSignatureValid(signature: string): boolean {
  return signature.length <= 40
}
