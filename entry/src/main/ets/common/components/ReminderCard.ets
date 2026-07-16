import router from '@ohos.router'

@Component
export struct ReminderCard {

  build() {

    Row() {

      Text('🔔')
        .fontSize(32)
        .margin({ right: 15 })


      Column() {

        Text('提醒设置')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)


        Text('管理办公健康提醒')
          .fontSize(13)
          .fontColor('#999999')
          .margin({ top: 5 })

      }

      .alignItems(HorizontalAlign.Start)

      .layoutWeight(1)


      Text('>')
        .fontSize(24)
        .fontColor('#999999')


    }

    .padding(20)

    .backgroundColor(Color.White)

    .borderRadius(18)

    .shadow({
      radius: 10,
      color: '#20000000',
      offsetX: 0,
      offsetY: 5
    })

    .onClick(()=>{

      router.pushUrl({

        url:'pages/ReminderSetting'

      })

    })

  }
}