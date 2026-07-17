/**
 * 会话记录条形图组件
 * 展示今日专注和休息记录，绿色=专注，蓝色=休息
 */
import { SessionRecord } from '../service/focusService';

@Component
export struct SessionBarChart {
  @Link records: SessionRecord[];
  @Prop maxMinutes: number = 25;

  build() {
    Column() {
      // 标题行 + 图例
      Row() {
        Text('今日记录')
          .fontSize(16).fontWeight(FontWeight.Medium).fontColor('#333333')
        Blank()
        Row({ space: 12 }) {
          Row({ space: 4 }) {
            Circle({ width: 8, height: 8 }).fill('#5B9184')
            Text('专注').fontSize(12).fontColor('#999999')
          }
          Row({ space: 4 }) {
            Circle({ width: 8, height: 8 }).fill('#5B9BD5')
            Text('休息').fontSize(12).fontColor('#999999')
          }
        }
      }
      .width('100%')
      .padding({ bottom: 12 })

      // 空状态
      if (this.records.length === 0) {
        Text('暂无记录，开始你的第一次专注吧')
          .fontSize(14).fontColor('#CCCCCC')
          .width('100%').textAlign(TextAlign.Center)
          .padding({ top: 16, bottom: 16 })
      }

      // 记录列表
      if (this.records.length > 0) {
        List({ space: 10 }) {
          ForEach(this.records, (record: SessionRecord, index: number) => {
            ListItem() {
              this.buildBarRow(record)
            }
          }, (record: SessionRecord) => `${record.timestamp}_${record.type}`)
        }
        .width('100%')
        .height(this.records.length * 50)
        .scrollBar(BarState.Off)
        .divider({ strokeWidth: 0 })
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor("#FEFEFE")
    .borderRadius(16)
    .shadow({ radius: 8, color: "rgba(0, 0, 0, 0.04)", offsetY: 2 })
  }

  @Builder
  buildBarRow(record: SessionRecord) {
    Row() {
      // 时间标签
      Text(record.startTime)
        .fontSize(13).fontColor('#888888')
        .width(48)

      // 条形图
      Row() {
        Text(`${record.durationMin}分钟`)
          .fontSize(13).fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .padding({ left: 10, right: 10 })
      }
      .height(32)
      .borderRadius(6)
      .backgroundColor(record.type === 'focus' ? '#5B9184' : '#5B9BD5')
      .width(this.calcBarWidth(record))
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)

      Blank()
    }
    .width('100%')
    .height(40)
    .alignItems(VerticalAlign.Center)
  }

  private calcBarWidth(record: SessionRecord): string {
    const ratio: number = this.maxMinutes > 0 ? record.durationMin / this.maxMinutes : 0;
    const pct: number = Math.max(ratio * 70, 15); // 最少15%，最多70%
    return `${Math.round(pct)}%`;
  }
}