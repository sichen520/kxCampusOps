import { KnowledgeResource } from '../../../domain/WorkflowModels';
import {
  COLOR_BLUE,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_SURFACE,
  COLOR_SURFACE_ALT,
  COLOR_TEXT
} from '../../../shared/Theme';

@Component
export struct ResourceCard {
  @Prop resource: KnowledgeResource;
  @Prop isWide: boolean = false;
  onOpen: () => void = () => {};

  @Builder
  DesktopRow() {
    Row() {
      Column({ space: 5 }) {
        Row({ space: 7 }) {
          Text(this.resource.resourceType)
            .fontSize(11)
            .fontWeight(FontWeight.Medium)
            .fontColor(COLOR_PRIMARY)
          Text(this.resource.category).fontSize(11).fontColor(COLOR_BLUE)
        }
        Text(this.resource.title)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.resource.summary)
          .fontSize(12)
          .lineHeight(18)
          .fontColor(COLOR_MUTED)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('48%')
      .padding({ right: 20 })
      .alignItems(HorizontalAlign.Start)

      Column({ space: 5 }) {
        Text(this.resource.courseName)
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor(COLOR_TEXT)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(`${this.resource.author} · ${this.resource.permission}`)
          .fontSize(11)
          .fontColor(COLOR_MUTED)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.resource.fileName)
          .fontSize(11)
          .fontColor(COLOR_BLUE)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('25%')
      .padding({ right: 16 })
      .alignItems(HorizontalAlign.Start)

      Column({ space: 5 }) {
        Text(`${this.resource.averageRating} 分 · ${this.resource.ratingCount} 人评价`)
          .fontSize(12)
          .fontColor(COLOR_TEXT)
        Text(`${this.resource.viewCount} 浏览 · ${this.resource.downloadCount} 下载`)
          .fontSize(11)
          .fontColor(COLOR_MUTED)
        Text(this.resource.createdAt).fontSize(11).fontColor(COLOR_MUTED)
      }
      .width('19%')
      .alignItems(HorizontalAlign.Start)

      Text('查看 →')
        .width('8%')
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor(COLOR_PRIMARY)
        .textAlign(TextAlign.End)
    }
    .width('100%')
    .constraintSize({ minHeight: 96 })
    .padding({ left: 16, right: 16, top: 13, bottom: 13 })
    .backgroundColor(COLOR_SURFACE)
    .border({ width: { bottom: 1 }, color: COLOR_BORDER })
    .alignItems(VerticalAlign.Center)
    .onClick(() => { this.onOpen(); })
  }

  @Builder
  MobileRow() {
    Column({ space: 8 }) {
      Row() {
        Row({ space: 7 }) {
          Text(this.resource.resourceType).fontSize(11).fontWeight(FontWeight.Medium).fontColor(COLOR_PRIMARY)
          Text(this.resource.category).fontSize(11).fontColor(COLOR_BLUE)
        }
        Blank()
        Text(this.resource.createdAt).fontSize(10).fontColor(COLOR_MUTED)
      }
      .width('100%')
      Text(this.resource.title)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(this.resource.summary)
        .fontSize(12)
        .lineHeight(18)
        .fontColor(COLOR_MUTED)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Row() {
        Text(this.resource.courseName)
          .layoutWeight(1)
          .fontSize(11)
          .fontColor(COLOR_MUTED)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(`${this.resource.downloadCount} 下载`).fontSize(11).fontColor(COLOR_MUTED)
        Text('查看 →').fontSize(12).fontWeight(FontWeight.Medium).fontColor(COLOR_PRIMARY).margin({ left: 12 })
      }
      .width('100%')
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .backgroundColor(COLOR_SURFACE_ALT)
    .border({ width: { bottom: 1 }, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
    .onClick(() => { this.onOpen(); })
  }

  build() {
    if (this.isWide) {
      this.DesktopRow()
    } else {
      this.MobileRow()
    }
  }
}
