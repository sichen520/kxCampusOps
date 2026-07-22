import { RecruitmentKind, RecruitmentPost } from '../../../domain/WorkflowModels';
import {
  COLOR_AMBER,
  COLOR_AMBER_SOFT,
  COLOR_BLUE,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_SURFACE,
  COLOR_TEXT
} from '../../../shared/Theme';

@Component
export struct RecruitmentDetail {
  @Prop post: RecruitmentPost;
  @Prop isWide: boolean = false;
  @Prop actionLabel: string = '';
  @Prop actionDisabled: boolean = false;
  @Prop feedbackText: string = '';
  @Prop feedbackLabel: string = '状态';
  @Prop showSecondaryAction: boolean = false;
  @Prop secondaryLabel: string = '';
  onBack: () => void = () => {};
  onAction: () => void = () => {};
  onSecondaryAction: () => void = () => {};

  private defaultActionLabel(): string {
    return this.post.kind === RecruitmentKind.COMPETITION ? '申请加入队伍' : '报名活动岗位';
  }

  private accentColor(): string {
    return this.post.kind === RecruitmentKind.COMPETITION ? COLOR_PRIMARY : COLOR_BLUE;
  }

  @Builder
  DetailRow(label: string, value: string) {
    Row() {
      Text(label)
        .width(this.isWide ? 92 : 76)
        .fontSize(12)
        .fontColor(COLOR_MUTED)
      Text(value)
        .layoutWeight(1)
        .fontSize(13)
        .lineHeight(20)
        .fontColor(COLOR_TEXT)
    }
    .width('100%')
    .padding({ top: 11, bottom: 11 })
    .alignItems(VerticalAlign.Top)
    .border({ width: { bottom: 1 }, color: COLOR_BORDER })
  }

  @Builder
  OpportunitySummary() {
    Column({ space: 10 }) {
      Row() {
        Text(this.post.kind)
          .fontSize(11)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.accentColor())
        Blank()
        Text(this.post.progress).fontSize(12).fontColor(COLOR_MUTED)
      }
      .width('100%')
      Text(this.post.title)
        .width('100%')
        .fontSize(this.isWide ? 26 : 22)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT)
        .maxLines(3)
      Text(this.post.summary)
        .width('100%')
        .fontSize(14)
        .lineHeight(22)
        .fontColor(COLOR_MUTED)
    }
    .width('100%')
    .padding({ bottom: 14 })
    .alignItems(HorizontalAlign.Start)
    .border({ width: { bottom: 1 }, color: COLOR_BORDER })
  }

  @Builder
  Metadata() {
    Column() {
      this.DetailRow('发布者', `${this.post.publisher} · ${this.post.publisherRole}`)
      this.DetailRow('组织', this.post.organization)
      this.DetailRow('需要角色', this.post.requiredRole)
      this.DetailRow('参与时间', this.post.schedule)
      this.DetailRow('地点', this.post.location)
      this.DetailRow('报名截止', this.post.deadline)
    }
    .width('100%')
  }

  @Builder
  Feedback() {
    if (this.feedbackText.length > 0) {
      Column({ space: 6 }) {
        Text(this.feedbackLabel)
          .fontSize(11)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_AMBER)
        Text(this.feedbackText)
          .width('100%')
          .fontSize(13)
          .lineHeight(20)
          .fontColor(COLOR_TEXT)
      }
      .width('100%')
      .margin({ top: 14 })
      .padding({ left: 12, right: 12, top: 11, bottom: 11 })
      .backgroundColor(COLOR_AMBER_SOFT)
      .border({ width: { left: 3 }, color: COLOR_AMBER })
      .alignItems(HorizontalAlign.Start)
    }
  }

  @Builder
  ActionPanel() {
    Column({ space: 12 }) {
      Text('参与这项机会')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT)
      Divider().color(COLOR_BORDER)
      Column({ space: 5 }) {
        Text('报名截止').fontSize(11).fontColor(COLOR_MUTED)
        Text(this.post.deadline)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(COLOR_AMBER)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      Column({ space: 5 }) {
        Text('审批方式').fontSize(11).fontColor(COLOR_MUTED)
        Text(this.post.approval).fontSize(13).lineHeight(19).fontColor(COLOR_TEXT)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      Button(this.actionLabel.length > 0 ? this.actionLabel : this.defaultActionLabel())
        .width('100%')
        .height(44)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.actionDisabled ? COLOR_MUTED : '#FFFFFF')
        .backgroundColor(this.actionDisabled ? '#E8ECEA' : COLOR_PRIMARY)
        .borderRadius(4)
        .enabled(!this.actionDisabled)
        .onClick(() => {
          this.onAction();
        })
      if (this.showSecondaryAction) {
        Button(this.secondaryLabel)
          .width('100%')
          .height(42)
          .fontSize(13)
          .fontColor(COLOR_PRIMARY)
          .backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_PRIMARY })
          .borderRadius(4)
          .onClick(() => {
            this.onSecondaryAction();
          })
      }
      Text('申请记录会同步到“我的”')
        .width('100%')
        .fontSize(11)
        .fontColor(COLOR_MUTED)
        .textAlign(TextAlign.Center)
    }
    .width(this.isWide ? 286 : '100%')
    .padding(this.isWide ? { left: 22, bottom: 8 } : { top: 16, bottom: 4 })
    .alignItems(HorizontalAlign.Start)
    .border(this.isWide ? { width: { left: 1 }, color: COLOR_BORDER } :
      { width: { top: 1 }, color: COLOR_BORDER })
  }

  build() {
    Column({ space: 16 }) {
      Text('返回机会列表')
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
        .fontColor(COLOR_PRIMARY)
        .onClick(() => {
          this.onBack();
        })

      if (this.isWide) {
        Row() {
          Column() {
            this.OpportunitySummary()
            this.Metadata()
            this.Feedback()
          }
          .layoutWeight(1)
          .padding({ right: 22 })
          .alignItems(HorizontalAlign.Start)
          this.ActionPanel()
        }
        .width('100%')
        .alignItems(VerticalAlign.Top)
      } else {
        Column() {
          this.OpportunitySummary()
          this.Metadata()
          this.Feedback()
          this.ActionPanel()
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }
    }
    .width('100%')
    .padding({ top: 16 })
    .alignItems(HorizontalAlign.Start)
  }
}
