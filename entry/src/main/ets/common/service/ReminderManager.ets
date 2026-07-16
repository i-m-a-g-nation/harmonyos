import { DataCenter } from '../../pages/DataCenter'

export class ReminderManager {

  private static sedentaryTimer: number = -1

  private static waterTimer: number = -1

  private static eyeTimer: number = -1

  // 是否正在启动（防止重复进入）
  private static starting: boolean = false

  // 当前是否已经启动
  private static started: boolean = false


  static stop() {

    if (ReminderManager.sedentaryTimer !== -1) {
      clearInterval(ReminderManager.sedentaryTimer)
      ReminderManager.sedentaryTimer = -1
    }

    if (ReminderManager.waterTimer !== -1) {
      clearInterval(ReminderManager.waterTimer)
      ReminderManager.waterTimer = -1
    }

    if (ReminderManager.eyeTimer !== -1) {
      clearInterval(ReminderManager.eyeTimer)
      ReminderManager.eyeTimer = -1
    }

    ReminderManager.started = false

    console.info("提醒服务已停止")
  }


  static async start() {

    // 已经有一个start正在执行，直接返回
    if (ReminderManager.starting) {

      console.info("ReminderManager正在启动，忽略本次调用")

      return
    }

    ReminderManager.starting = true

    try {

      console.info("======== ReminderManager.start ========")

      // 每次启动前先停止旧Timer
      ReminderManager.stop()

      const config =
        await DataCenter.getReminderConfig()

      console.info(
        "提醒配置：" +
          JSON.stringify(config)
      )

      if (config.sedentaryEnable) {

        console.info(
          "启动久坐提醒：" +
            config.sedentaryInterval +
            "分钟"
        )

        ReminderManager.startSedentary(
          config.sedentaryInterval
        )
      }

      if (config.waterEnable) {

        console.info(
          "启动喝水提醒：" +
            config.waterInterval +
            "分钟"
        )

        ReminderManager.startWater(
          config.waterInterval
        )
      }

      if (config.eyeEnable) {

        console.info(
          "启动远眺提醒：" +
            config.eyeInterval +
            "分钟"
        )

        ReminderManager.startEye(
          config.eyeInterval
        )
      }

      ReminderManager.started = true

      console.info("提醒服务启动完成")

    } finally {

      // 无论成功失败，都允许下一次start
      ReminderManager.starting = false

    }
  }


  private static startSedentary(
    minutes: number
  ) {

    ReminderManager.sedentaryTimer =
      setInterval(() => {

        console.info("久坐提醒触发")

      }, 10 * 1000)
  }


  private static startWater(
    minutes: number
  ) {

    ReminderManager.waterTimer =
      setInterval(() => {

        console.info("喝水提醒触发")

      }, 10 * 1000)
  }


  private static startEye(
    minutes: number
  ) {

    ReminderManager.eyeTimer =
      setInterval(() => {

        console.info("远眺提醒触发")

      }, 10 * 1000)
  }

}