import { ApplicationState } from '../../../domain/WorkflowModels';
import { StatusPill } from '../../../shared/components/StatusPill';
import {
  COLOR_AMBER,
  COLOR_AMBER_SOFT,
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
export struct ProfileApplicationsPanel {
  @Prop competitionState: ApplicationState = ApplicationState.NONE;
  @Prop activityState: ApplicationState = ApplicationState.NONE;
  onBack: () => void = () => {};
  onBrowse: () => void = () => {};

  private stateColor(state: ApplicationState): string {
    if (state === ApplicationState.APPROVED) {
      return COLOR_PRIMARY;
    }
    if (state === ApplicationState.REJECTED) {
      return COLOR_RED;
    }
    return COLOR_AMBER;
  }

  private stateFill(state: ApplicationState): string {
    if (state === ApplicationState.APPROVED) {
      return COLOR_PRIMARY_SOFT;
    }
    if (state === ApplicationState.REJECTED) {
      return COLOR_RED_SOFT;
    }
    return COLOR_AMBER_SOFT;
  }

  @Builder
  ApplicationRow(kind: string, title: string, state: ApplicationState) {
    Row({ space: 14 }) {
      Column({ space: 5 }) {
        Text(kind).fontSize(12).fontColor(COLOR_MUTED)
        Text(title).fontSize(16).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        Text(state === ApplicationState.NONE ? '尚未提交申请' : '申请状态已同步到对应负责人')
          .fontSize(12).fontColor(COLOR_MUTED)
      }
      .layoutWeight(1).alignItems(HorizontalAlign.Start)
      StatusPill({ text: state, fillColor: this.stateFill(state), textColor: this.stateColor(state) })
    }
    .width('100%').padding(16).backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER }).borderRadius(7)
  }

  build() {
    Column({ space: 16 }) {
      Button('返回个人中心').height(36).fontSize(13).fontColor(COLOR_PRIMARY).backgroundColor(Color.Transparent)
        .onClick(() => { this.onBack(); })
      Column({ space: 5 }) {
        Text('我的申请').fontSize(24).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Text('比赛组队和活动岗位使用独立审批状态。').fontSize(13).fontColor(COLOR_MUTED)
      }
      .width('100%').alignItems(HorizontalAlign.Start)
      this.ApplicationRow('比赛组队', '最近一次队伍加入申请', this.competitionState)
      this.ApplicationRow('校园活动', '最近一次活动岗位报名', this.activityState)
      Button('继续浏览比赛与活动')
        .width('100%').height(44).fontSize(14).fontColor('#FFFFFF')
        .backgroundColor(COLOR_PRIMARY).borderRadius(5)
        .onClick(() => { this.onBrowse(); })
    }
    .width('100%').alignItems(HorizontalAlign.Start)
  }
}
