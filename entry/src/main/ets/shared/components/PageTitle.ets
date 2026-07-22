import { COLOR_MUTED, COLOR_PRIMARY, COLOR_TEXT } from '../Theme';

@Component
export struct PageTitle {
  @Prop eyebrow: string = '';
  @Prop title: string = '';
  @Prop description: string = '';

  build() {
    Column({ space: 6 }) {
      if (this.eyebrow.length > 0) {
        Row({ space: 8 }) {
          Column()
            .width(3)
            .height(12)
            .borderRadius(1)
            .backgroundColor(COLOR_PRIMARY)
          Text(this.eyebrow)
            .fontSize(11)
            .fontWeight(FontWeight.Medium)
            .fontColor(COLOR_PRIMARY)
            .letterSpacing(0.6)
        }
      }
      if (this.title.length > 0) {
        Text(this.title)
          .fontSize(22)
          .lineHeight(30)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT)
          .letterSpacing(0.2)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      if (this.description.length > 0) {
        Text(this.description)
          .fontSize(13)
          .lineHeight(21)
          .fontColor(COLOR_MUTED)
          .constraintSize({ maxWidth: 760 })
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
