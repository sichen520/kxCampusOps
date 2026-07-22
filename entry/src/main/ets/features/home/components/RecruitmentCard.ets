import { RecruitmentKind, RecruitmentPost } from '../../../domain/WorkflowModels';
import { StatusPill } from '../../../shared/components/StatusPill';
import {
  recruitmentDeadlineLabel,
  recruitmentDeadlineState,
  RecruitmentDeadlineState
} from '../domain/RecruitmentDiscovery';
import {
  COLOR_AMBER,
  COLOR_AMBER_SOFT,
  COLOR_BLUE,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_RED,
  COLOR_RED_SOFT,
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
    return this.post.kind === RecruitmentKind.COMPETITION ? '申请加入' : '报名岗位';
  }

  private accentColor(): string {
    return this.post.kind === RecruitmentKind.COMPETITION ? COLOR_PRIMARY : COLOR_BLUE;
  }

  private deadlineFillColor(): string {
    const state: RecruitmentDeadlineState = recruitmentDeadlineState(this.post.deadline, Date.now());
    if (state === RecruitmentDeadlineState.EXPIRED || state === RecruitmentDeadlineState.URGENT) {
      return COLOR_RED_SOFT;
    }
    if (state === RecruitmentDeadlineState.SOON) {
      return COLOR_AMBER_SOFT;
    }
    return COLOR_PRIMARY_SOFT;
  }

  private deadlineTextColor(): string {
    const state: RecruitmentDeadlineState = recruitmentDeadlineState(this.post.deadline, Date.now());
    if (state === RecruitmentDeadlineState.EXPIRED || state === RecruitmentDeadlineState.URGENT) {
      return COLOR_RED;
    }
    if (state === RecruitmentDeadlineState.SOON) {
      return COLOR_AMBER;
    }
    return COLOR_PRIMARY;
  }

  @Builder
  CompactAction() {
    Button(this.actionLabel.length > 0 ? this.actionLabel : this.defaultActionLabel())
      .height(36)
      .fontSize(12)
      .fontWeight(FontWeight.Medium)
      .fontColor(this.actionDisabled ? COLOR_MUTED : '#FFFFFF')
      .backgroundColor(this.actionDisabled ? '#E8ECEA' : COLOR_PRIMARY)
      .borderRadius(4)
      .enabled(!this.actionDisabled)
      .onClick(() => {
        this.onAction();
      })
  }

  @Builder
  DesktopRow() {
    Row() {
      Column({ space: 6 }) {
        Row({ space: 8 }) {
          Text(this.post.kind === RecruitmentKind.COMPETITION ? '比赛' : '活动')
            .fontSize(11)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.accentColor())
            .letterSpacing(0.6)
          Text(this.post.organization)
            .fontSize(11)
            .fontColor(COLOR_MUTED)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .width('100%')
        Text(this.post.title)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .onClick(() => {
            this.onOpen();
          })
        Text(this.post.summary)
          .fontSize(12)
          .lineHeight(18)
          .fontColor(COLOR_MUTED)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .padding({ right: 22 })
      .alignItems(HorizontalAlign.Start)

      Column({ space: 6 }) {
        Text('需要角色').fontSize(11).fontColor(COLOR_MUTED).letterSpacing(0.5)
        Text(this.post.requiredRole)
          .fontSize(13)
          .lineHeight(19)
          .fontWeight(FontWeight.Medium)
          .fontColor(COLOR_TEXT)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width(190)
      .padding({ right: 18 })
      .alignItems(HorizontalAlign.Start)

      Column({ space: 6 }) {
        Text(`${this.post.publisher} · ${this.post.publisherRole}`)
          .fontSize(12)
          .fontColor(COLOR_TEXT)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Row({ space: 6 }) {
          Text(`截止 ${this.post.deadline}`)
            .fontSize(12)
            .fontColor(COLOR_AMBER)
            .maxLines(1)
          StatusPill({
            text: recruitmentDeadlineLabel(this.post.deadline, Date.now()),
            fillColor: this.deadlineFillColor(),
            textColor: this.deadlineTextColor()
          })
        }
      }
      .width(190)
      .padding({ right: 18 })
      .alignItems(HorizontalAlign.Start)

      Column({ space: 10 }) {
        Text(this.post.progress)
          .width('100%')
          .fontSize(12)
          .fontColor(COLOR_MUTED)
          .textAlign(TextAlign.End)
        Row({ space: 8 }) {
          Button('详情')
            .layoutWeight(1)
            .height(36)
            .fontSize(12)
            .fontColor(COLOR_TEXT)
            .backgroundColor(COLOR_SURFACE)
            .border({ width: 1, color: COLOR_BORDER })
            .borderRadius(4)
            .onClick(() => {
              this.onOpen();
            })
          this.CompactAction()
        }
        .width('100%')
      }
      .width(210)
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding({ left: 14, right: 14, top: 16, bottom: 16 })
    .alignItems(VerticalAlign.Top)
  }

  @Builder
  MobileRow() {
    Column({ space: 10 }) {
      Row() {
        Text(this.post.kind === RecruitmentKind.COMPETITION ? '比赛组队' : '校园活动')
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.accentColor())
          .letterSpacing(0.6)
        Blank()
        StatusPill({
          text: recruitmentDeadlineLabel(this.post.deadline, Date.now()),
          fillColor: this.deadlineFillColor(),
          textColor: this.deadlineTextColor()
        })
        Text(this.post.progress).fontSize(11).fontColor(COLOR_MUTED)
      }
      .width('100%')
      Text(this.post.title)
        .width('100%')
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .onClick(() => {
          this.onOpen();
        })
      Text(this.post.summary)
        .width('100%')
        .fontSize(12)
        .lineHeight(18)
        .fontColor(COLOR_MUTED)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Row() {
        Column({ space: 4 }) {
          Text(this.post.requiredRole)
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor(COLOR_TEXT)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text(`${this.post.publisher} · 截止 ${this.post.deadline}`)
            .fontSize(11)
            .fontColor(COLOR_MUTED)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .layoutWeight(1)
        .padding({ right: 10 })
        .alignItems(HorizontalAlign.Start)
        Button('详情')
          .height(36)
          .fontSize(12)
          .fontColor(COLOR_TEXT)
          .backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER })
          .borderRadius(4)
          .margin({ right: 8 })
          .onClick(() => {
            this.onOpen();
          })
        this.CompactAction()
      }
      .width('100%')
      .alignItems(VerticalAlign.Bottom)
    }
    .width('100%')
    .padding({ left: 2, right: 2, top: 16, bottom: 16 })
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Column() {
      if (this.isWide) {
        this.DesktopRow()
      } else {
        this.MobileRow()
      }
      Divider().color(COLOR_BORDER)
    }
    .width('100%')
    .backgroundColor(COLOR_SURFACE)
  }
}
