@Component
export struct DeviceMenuCard {
  // 预留点击回调，后续绑定跳转直接传参即可
  onInfoClick?: () => void
  onUpgradeClick?: () => void
  onSyncClick?: () => void
  onDiagnoseClick?: () => void

  // 通用菜单项构建器
  @Builder MenuItem(
    icon: Resource,
    title: string,
    subTitle: string,
    isRoundBg: boolean,
    onClick?: () => void
  ) {
    Row() {
      // 左侧：图标 + 浅绿背景
      Row() {
        Image(icon)
          .width(20)
          .height(20)
          .objectFit(ImageFit.Contain)
      }
      .width(36)
      .height(36)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('rgba(58, 143, 126, 0.1)')
      .borderRadius(isRoundBg ? 18 : 8)

      // 中间：标题 + 副标题
      Column({ space: 4 }) {
        Text(title)
          .fontSize(17)
          .fontColor('#1A1A1A')
          .fontWeight(FontWeight.Medium)

        if (subTitle.length > 0) {
          Text(subTitle)
            .fontSize(14)
            .fontColor('#999999')
        }
      }
      .margin({ left: 14 })
      .alignItems(HorizontalAlign.Start)

      Blank()

      // 右侧：箭头
      Image($r('app.media.ic_chevron_right'))
        .width(18)
        .height(18)
        .objectFit(ImageFit.Contain)
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .onClick(() => {
      onClick?.()
    })
  }

  build() {
    Column() {
      this.MenuItem(
        $r('app.media.ic_device_info'),
        '设备信息',
        '',
        false,
        this.onInfoClick
      )

      Divider().color('#F0F0F0')

      this.MenuItem(
        $r('app.media.ic_firmware_upgrade'),
        '固件升级',
        '当前已是最新版本 1.2.3',
        true,
        this.onUpgradeClick
      )

      Divider().color('#F0F0F0')

      this.MenuItem(
        $r('app.media.ic_data_sync'),
        '数据同步',
        '上次同步：今天 09:30',
        true,
        this.onSyncClick
      )

      Divider().color('#F0F0F0')

      this.MenuItem(
        $r('app.media.ic_connection_diagnose'),
        '连接诊断',
        '',
        true,
        this.onDiagnoseClick
      )
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }
}