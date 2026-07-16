import { ReminderConfig } from '../model/ReminderConfig'


export class ReminderService {


  static saveConfig(
    config:ReminderConfig
  ){


    console.info(
      "ReminderConfig:",
      JSON.stringify(config)
    )


  }



  static sendToDevice(
    config:ReminderConfig
  ){


    let data =
      JSON.stringify(config)



    console.info(
      "Send BLE:",
      data
    )


    /*
      后续连接：

      BleService.sendPacket(data)

    */


  }


}