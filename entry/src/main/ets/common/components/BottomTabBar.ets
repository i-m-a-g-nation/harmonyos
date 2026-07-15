// 先显式声明 Tab 项的数据接口
interface TabItem {
  name: string
  normalIcon: Resource
  activeIcon: Resource
  isCenter: boolean
}

@Component
export struct BottomTabBar {
  @Link currentIndex: number
  onTabChange?: (index: number) => void

  // 指定数组的明确类型，避免类型推断失败
  private readonly tabList: TabItem[] = [
    {
      name: '首页',
      normalIcon: $r('app.media.home_normal'),
      activeIcon: $r('app.media.home_active'),
      isCenter: false
    },
    {
      name: '洞察',
      normalIcon: $r('app.media.insight_normal'),
      activeIcon: $r('app.media.insight_active'),
      isCenter: false
    },
    {
      name: '专注',
      normalIcon: $r('app.media.focus_normal'),
      activeIcon: $r('app.media.focus_active'),
      isCenter: true
    },
    {
      name: '我的',
      normalIcon: $r('app.media.mine_normal'),
      activeIcon: $r('app.media.mine_active'),
      isCenter: false
    }
  ]

  build() {
    Row() {
      ForEach(this.tabList, (item: TabItem, index: number) => {
        Column({ space: 4 }) {
          Image(this.currentIndex === index ? item.activeIcon : item.normalIcon)
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)

          Text(item.name)
            .fontSize(12)
            .fontColor(this.currentIndex === index ? '#3A8F7E' : '#999999')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .margin({ top: 0 })
        .onClick(() => {
          this.currentIndex = index
          this.onTabChange?.(index)
        })
      })
    }
    .width('100%')
    .height(56)
    .backgroundColor('#FFFFFF')
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.03)',
      offsetY: -2
    })
  }
}