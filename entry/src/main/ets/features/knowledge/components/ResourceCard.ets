import { KnowledgeResource } from '../../../domain/WorkflowModels';
import { StatusPill } from '../../../shared/components/StatusPill';
import {
  COLOR_BLUE,
  COLOR_BLUE_SOFT,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  COLOR_TEXT
} from '../../../shared/Theme';

@Component
export struct ResourceCard {
  @Prop resource: KnowledgeResource;
  @Prop isWide: boolean = false;
  onOpen: () => void = () => {};

  build() {
    Column({ space: 10 }) {
      Row() {
        StatusPill({ text: this.resource.resourceType, fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
        Blank()
        Text(this.resource.createdAt).fontSize(11).fontColor(COLOR_MUTED)
      }
      .width('100%')
      Text(this.resource.category).fontSize(12).fontColor(COLOR_BLUE)
      Text(this.resource.title)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(this.resource.summary)
        .fontSize(13)
        .lineHeight(19)
        .fontColor(COLOR_MUTED)
        .maxLines(3)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Row({ space: 6 }) {
        ForEach(this.resource.tags.slice(0, 2), (tag: string) => {
          Text(tag)
            .fontSize(11)
            .fontColor(COLOR_BLUE)
            .padding({ left: 6, right: 6, top: 3, bottom: 3 })
            .backgroundColor(COLOR_BLUE_SOFT)
            .borderRadius(3)
        }, (tag: string) => tag)
      }
      .width('100%')
      Row({ space: 14 }) {
        Text(`${this.resource.viewCount} 浏览`).fontSize(11).fontColor(COLOR_MUTED)
        Text(`${this.resource.downloadCount} 下载`).fontSize(11).fontColor(COLOR_MUTED)
        Text(`${this.resource.averageRating} 分`).fontSize(11).fontColor(COLOR_MUTED)
        Blank()
        Text('查看详情').fontSize(12).fontWeight(FontWeight.Medium).fontColor(COLOR_PRIMARY)
      }
      .width('100%')
    }
    .width(this.isWide ? '49%' : '100%')
    .constraintSize({ minHeight: 218 })
    .margin({ bottom: 16 })
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER })
    .borderRadius(8)
    .alignItems(HorizontalAlign.Start)
    .onClick(() => {
      this.onOpen();
    })
  }
}
