import { RecruitmentPost } from '../../../domain/WorkflowModels';
import { StatusPill } from '../../../shared/components/StatusPill';
import {
  COLOR_AMBER,
  COLOR_AMBER_SOFT,
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
export struct RecruitmentCard {
  @Prop post: RecruitmentPost;
  @Prop isWide: boolean = false;
  @Prop actionLabel: string = '';
  @Prop actionDisabled: boolean = false;
  onOpen: () => void = () => {};
  onAction: () => void = () => {};

  private defaultActionLabel(): string {
    return this.post.kind === '比赛招募' ? '申请加入' : '报名岗位';
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        StatusPill({
          text: this.post.kind,
          fillColor: this.post.kind === '比赛招募' ? COLOR_PRIMARY_SOFT : COLOR_BLUE_SOFT,
          textColor: this.post.kind === '比赛招募' ? COLOR_PRIMARY : COLOR_BLUE
        })
        Blank()
        Text(this.post.progress).fontSize(12).fontColor(COLOR_MUTED)
      }
      .width('100%')
      Text(this.post.title)
        .fontSize(19)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(this.post.summary)
        .fontSize(13)
        .lineHeight(20)
        .fontColor(COLOR_MUTED)
        .maxLines(this.isWide ? 2 : 3)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Row({ space: 8 }) {
        Text(this.post.publisher).fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        Text(this.post.publisherRole).fontSize(12).fontColor(COLOR_MUTED)
      }
      .width('100%')
      Text(this.post.organization).fontSize(11).fontColor(COLOR_BLUE)
      Text(`${this.post.requiredRole} · 截止 ${this.post.deadline}`)
        .fontSize(12)
        .fontColor(COLOR_AMBER)
      Row({ space: 8 }) {
        Button('查看详情')
          .layoutWeight(1)
          .height(38)
          .fontSize(13)
          .fontColor(COLOR_PRIMARY)
          .backgroundColor(COLOR_PRIMARY_SOFT)
          .borderRadius(4)
          .onClick(() => {
            this.onOpen();
          })
        Button(this.actionLabel.length > 0 ? this.actionLabel : this.defaultActionLabel())
          .layoutWeight(1)
          .height(38)
          .fontSize(13)
          .fontColor(this.actionDisabled ? COLOR_MUTED : '#FFFFFF')
          .backgroundColor(this.actionDisabled ? '#E8EBE8' : COLOR_PRIMARY)
          .borderRadius(4)
          .enabled(!this.actionDisabled)
          .onClick(() => {
            this.onAction();
          })
      }
      .width('100%')
    }
    .width(this.isWide ? '49%' : '100%')
    .constraintSize({ minHeight: 270 })
    .margin({ bottom: 12 })
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(8)
    .border({ width: 1, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }
}
