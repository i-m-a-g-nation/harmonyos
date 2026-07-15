/**
 * 蓝牙连接状态枚举
 * 统一管理所有蓝牙状态，后续对接真实蓝牙逻辑时直接赋值即可
 */
export enum BluetoothStatus {
  OFF = 'off',                // 手机蓝牙未开启
  DISCONNECTED = 'disconnected', // 蓝牙已开启，但未连接工位终端
  CONNECTING = 'connecting',     // 正在连接中
  CONNECTED = 'connected'        // 已成功连接
}

// WiFi信号等级 0-4格
export enum WifiSignalLevel {
  NONE = 0,
  WEAK = 1,
  FAIR = 2,
  GOOD = 3,
  FULL = 4
}