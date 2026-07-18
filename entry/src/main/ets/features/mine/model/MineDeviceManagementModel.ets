/** Mine 设备管理页展示的设备快照；不包含页面 URL 或系统设备句柄。 */
export interface MineManagedDevice {
  id: string
  name: string
  connected: boolean
  batteryLevel: number
  firmwareVersion: string
  lastSync: string
}

/** 当前原型只有一台静态演示设备，每次调用返回独立数组。 */
export function createMineManagedDevices(): MineManagedDevice[] {
  return [
    {
      id: 'office-terminal-pro',
      name: '办公健康终端 Pro',
      connected: true,
      batteryLevel: 78,
      firmwareVersion: '1.2.3',
      lastSync: '今天 09:30'
    }
  ]
}
