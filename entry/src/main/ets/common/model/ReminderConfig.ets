export class ReminderConfig {


  // 久坐提醒
  sedentaryEnable:boolean = true

  sedentaryInterval:number = 0.1

  // 喝水提醒
  waterEnable:boolean = true

  waterInterval:number = 0.2

  // 远眺提醒
  eyeEnable:boolean = true

  eyeInterval:number = 0.3

  // 通风提醒
  ventilationEnable:boolean = true

  co2Limit:number = 1000

  // 勿扰时间
  quietStart:string = "22:00"

  quietEnd:string = "07:00"

  // 提醒强度
  // 1轻柔 2适中 3强力

  level:number = 2


}