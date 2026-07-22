import { COLOR_MUTED, COLOR_PRIMARY, COLOR_TEXT } from '../Theme';

@Component
export struct PageTitle {
  @Prop eyebrow: string = '';
  @Prop title: string = '';
  @Prop description: string = '';
  @Prop compact: boolean = false;

  build() {
    Column({ space: this.compact ? 5 : 7 }) {
      Row({ space: 9 }) {
        Text(this.eyebrow)
          .fontSize(12).fontWeight(FontWeight.Medium).fontColor(COLOR_PRIMARY)
        Column().width(this.compact ? 20 : 28).height(1).backgroundColor(COLOR_PRIMARY)
      }
      Text(this.title)
        .fontSize(this.compact ? 22 : 26).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      Text(this.description)
        .fontSize(this.compact ? 13 : 14).lineHeight(this.compact ? 19 : 21).fontColor(COLOR_MUTED)
        .maxLines(this.compact ? 2 : 4)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
