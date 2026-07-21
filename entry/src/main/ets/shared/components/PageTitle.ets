import { COLOR_MUTED, COLOR_PRIMARY, COLOR_TEXT } from '../Theme';

@Component
export struct PageTitle {
  @Prop eyebrow: string = '';
  @Prop title: string = '';
  @Prop description: string = '';

  build() {
    Column({ space: 7 }) {
      Row({ space: 9 }) {
        Text(this.eyebrow)
          .fontSize(12).fontWeight(FontWeight.Medium).fontColor(COLOR_PRIMARY)
        Column().width(28).height(1).backgroundColor(COLOR_PRIMARY)
      }
      Text(this.title)
        .fontSize(26).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      Text(this.description)
        .fontSize(14).lineHeight(21).fontColor(COLOR_MUTED)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
