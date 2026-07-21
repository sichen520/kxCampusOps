import { RecruitmentPost } from '../../../domain/WorkflowModels';
import { StatusPill } from '../../../shared/components/StatusPill';
import {
  COLOR_AMBER,
  COLOR_AMBER_SOFT,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
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
    return this.post.kind === '比赛招募' ? '申请加入队伍' : '报名活动岗位';
  }

  @Builder
  DetailRow(label: string, value: string) {
    Row() {
      Text(label).width(74).fontSize(13).fontColor(COLOR_MUTED)
      Text(value).layoutWeight(1).fontSize(13).fontColor(COLOR_TEXT)
    }
    .width('100%')
    .padding({ top: 7, bottom: 7 })
  }

  build() {
    Column({ space: 16 }) {
      Button('返回招募列表')
        .height(36)
        .fontSize(13)
        .fontColor(COLOR_PRIMARY)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.onBack();
        })
      Column({ space: 12 }) {
        Row() {
          StatusPill({
            text: this.post.kind,
            fillColor: COLOR_PRIMARY_SOFT,
            textColor: COLOR_PRIMARY
          })
          Blank()
          Text(this.post.progress).fontSize(13).fontColor(COLOR_MUTED)
        }
        .width('100%')
        Text(this.post.title).fontSize(this.isWide ? 28 : 23).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Text(this.post.summary).fontSize(14).lineHeight(22).fontColor(COLOR_MUTED)
        Divider().color(COLOR_BORDER)
        this.DetailRow('发布者', `${this.post.publisher} · ${this.post.publisherRole}`)
        this.DetailRow('组织', this.post.organization)
        this.DetailRow('招募岗位', this.post.requiredRole)
        this.DetailRow('时间', this.post.schedule)
        this.DetailRow('地点', this.post.location)
        this.DetailRow('截止', this.post.deadline)
        Row({ space: 8 }) {
          StatusPill({ text: this.post.approval, fillColor: COLOR_AMBER_SOFT, textColor: COLOR_AMBER })
          Text('申请记录会显示在“我的”中').fontSize(12).fontColor(COLOR_MUTED)
        }
        .width('100%')
      }
      .width('100%')
      .padding(20)
      .backgroundColor(COLOR_SURFACE)
      .borderRadius(6)
      .border({ width: 1, color: COLOR_BORDER })
      .alignItems(HorizontalAlign.Start)
      if (this.feedbackText.length > 0) {
        Row({ space: 8 }) {
          StatusPill({ text: this.feedbackLabel, fillColor: COLOR_AMBER_SOFT, textColor: COLOR_AMBER })
          Text(this.feedbackText).layoutWeight(1).fontSize(13).fontColor(COLOR_TEXT)
        }
        .width('100%')
        .padding(14)
        .backgroundColor(COLOR_AMBER_SOFT)
        .borderRadius(5)
      }
      Button(this.actionLabel.length > 0 ? this.actionLabel : this.defaultActionLabel())
        .width('100%')
        .height(48)
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.actionDisabled ? COLOR_MUTED : '#FFFFFF')
        .backgroundColor(this.actionDisabled ? '#E8EBE8' : COLOR_PRIMARY)
        .borderRadius(5)
        .enabled(!this.actionDisabled)
        .onClick(() => {
          this.onAction();
        })
      if (this.showSecondaryAction) {
        Button(this.secondaryLabel)
          .width('100%')
          .height(44)
          .fontSize(14)
          .fontColor(COLOR_PRIMARY)
          .backgroundColor(COLOR_PRIMARY_SOFT)
          .borderRadius(5)
          .onClick(() => {
            this.onSecondaryAction();
          })
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
