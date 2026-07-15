import { BluetoothStatus } from '../constants/StatusEnum'

@Component
export struct BluetoothStatusIcon {
  /**
   * 外部传入的蓝牙状态，默认未连接
   */
  @Prop status: BluetoothStatus = BluetoothStatus.DISCONNECTED

  /**
   * 图标尺寸，外部可自定义大小，默认16vp
   */
  @Prop iconSize: number = 16

  /**
   * 根据状态返回对应图标颜色
   * 已连接：主题绿；连接中：警示橙；未连接/关闭：中性灰
   */
  private getStatusColor(): ResourceColor {
    switch (this.status) {
      case BluetoothStatus.CONNECTED:
        return '#3A8F7E'  // 莫兰迪低饱和绿，贴合你的设计风格
      case BluetoothStatus.CONNECTING:
        return '#E2A75C'  // 低饱和橙
      case BluetoothStatus.OFF:
        return '#B0B3B8'  // 浅灰
      default:
        return '#B0B3B8'  // 默认未连接灰色
    }
  }

  build() {
    // 用Stack堆叠：底层蓝牙图标 + 连接中动画圆环
    Stack({ alignContent: Alignment.Center }) {
      // 1. 基础蓝牙图标，通过fillColor统一改色
      Image($r('app.media.bluetooth'))
        .width(this.iconSize)
        .height(this.iconSize)
        .fillColor(this.getStatusColor())
        .objectFit(ImageFit.Contain)

      // 2. 连接中状态：叠加旋转虚线圆环（纯代码实现，无需额外素材）
      if (this.status === BluetoothStatus.CONNECTING) {
        Circle()
          .width(this.iconSize + 6)
          .height(this.iconSize + 6)
          .strokeWidth(1.5)
          .stroke('#E2A75C')
          .strokeDashArray([4, 4]) // 虚线样式
          .rotate({ angle: 360 })
          .animation({
            duration: 1500,        // 一圈1.5秒
            iterations: -1,        // 无限循环
            curve: Curve.Linear     // 匀速旋转
          })
      }
    }
    .width(this.iconSize)
    .height(this.iconSize)
  }
}