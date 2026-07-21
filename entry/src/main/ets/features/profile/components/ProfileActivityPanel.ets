import { ApplicationState } from '../../../domain/WorkflowModels';
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
export struct ProfileActivityPanel {
  @Prop activityState: ApplicationState = ApplicationState.NONE;
  onBack: () => void = () => {};
  onBrowse: () => void = () => {};

  build() {
    Column({ space: 16 }) {
      Button('返回个人中心').height(36).fontSize(13).fontColor(COLOR_PRIMARY).backgroundColor(Color.Transparent)
        .onClick(() => { this.onBack(); })
      Column({ space: 5 }) {
        Text('活动记录').fontSize(24).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Text('集中查看报名、岗位、签到和服务时长。').fontSize(13).fontColor(COLOR_MUTED)
      }
      .width('100%').alignItems(HorizontalAlign.Start)
      if (this.activityState === ApplicationState.NONE) {
        Column({ space: 10 }) {
          Text('暂无活动记录').fontSize(18).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('报名并通过老师审批后，岗位、活动时间和签到状态会显示在这里。')
            .fontSize(13).lineHeight(20).fontColor(COLOR_MUTED)
        }
        .width('100%').padding(24).backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_BORDER }).borderRadius(8).alignItems(HorizontalAlign.Start)
      } else {
        Column({ space: 12 }) {
          Row() {
            Column({ space: 4 }) {
              Text('HarmonyOS 校园开发工作坊').fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
              Text('现场协助 / 技术答疑').fontSize(12).fontColor(COLOR_MUTED)
            }
            .layoutWeight(1).alignItems(HorizontalAlign.Start)
            StatusPill({ text: this.activityState,
              fillColor: this.activityState === ApplicationState.APPROVED ? COLOR_PRIMARY_SOFT : COLOR_AMBER_SOFT,
              textColor: this.activityState === ApplicationState.APPROVED ? COLOR_PRIMARY : COLOR_AMBER })
          }
          .width('100%')
          Divider().color(COLOR_BORDER)
          Text('时间：2026-07-25 09:00 - 17:00').fontSize(13).fontColor(COLOR_TEXT)
          Text(this.activityState === ApplicationState.APPROVED ? '签到状态：待活动开始' : '通过审批后开放签到')
            .fontSize(13).fontColor(COLOR_MUTED)
          Text('累计服务时长：0 小时').fontSize(13).fontColor(COLOR_MUTED)
        }
        .width('100%').padding(18).backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_BORDER }).borderRadius(8).alignItems(HorizontalAlign.Start)
      }
      Button('浏览校园活动').width('100%').height(44).fontSize(14)
        .fontColor(COLOR_PRIMARY).backgroundColor(COLOR_PRIMARY_SOFT).borderRadius(5)
        .onClick(() => { this.onBrowse(); })
    }
    .width('100%').alignItems(HorizontalAlign.Start)
  }
}
