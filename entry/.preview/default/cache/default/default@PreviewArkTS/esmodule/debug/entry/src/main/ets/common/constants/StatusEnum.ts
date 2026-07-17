/**
 * 蓝牙连接状态枚举
 * 统一管理所有蓝牙状态，后续对接真实蓝牙逻辑时直接赋值即可
 */
export enum BluetoothStatus {
    OFF = "off",
    DISCONNECTED = "disconnected",
    CONNECTING = "connecting",
    CONNECTED = "connected" // 已成功连接
}
// WiFi信号等级 0-4格
export enum WifiSignalLevel {
    NONE = 0,
    WEAK = 1,
    FAIR = 2,
    GOOD = 3,
    FULL = 4
}
