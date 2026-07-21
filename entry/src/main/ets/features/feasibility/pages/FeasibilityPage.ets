import { FEASIBILITY_ITEMS } from '../../../data/MockCampusData';
import { AccountRole, FeasibilityItem, FeasibilityState, WorkflowStep } from '../../../domain/WorkflowModels';
import { StatusPill } from '../../../shared/components/StatusPill';
import { WorkflowHeader } from '../../../shared/components/WorkflowHeader';
import {
  COLOR_AMBER,
  COLOR_AMBER_SOFT,
  COLOR_BLUE,
  COLOR_BLUE_SOFT,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_RED,
  COLOR_RED_SOFT,
  COLOR_SURFACE,
  COLOR_TEXT,
  PAGE_MAX_WIDTH
} from '../../../shared/Theme';

@Component
export struct FeasibilityPage {
  @Link workflowStep: WorkflowStep;
  @Link personalPlanCreated: boolean;
  @Prop opportunityTitle: string = '';
  @Prop isWide: boolean = false;
  @Prop accountRole: AccountRole = AccountRole.STUDENT;

  private stateBackground(state: FeasibilityState): string {
    if (state === FeasibilityState.MET) {
      return COLOR_PRIMARY_SOFT;
    }
    if (state === FeasibilityState.MISSING) {
      return COLOR_RED_SOFT;
    }
    if (state === FeasibilityState.RISK) {
      return COLOR_AMBER_SOFT;
    }
    return COLOR_BLUE_SOFT;
  }

  private stateColor(state: FeasibilityState): string {
    if (state === FeasibilityState.MET) {
      return COLOR_PRIMARY;
    }
    if (state === FeasibilityState.MISSING) {
      return COLOR_RED;
    }
    if (state === FeasibilityState.RISK) {
      return COLOR_AMBER;
    }
    return COLOR_BLUE;
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 16 }) {
          WorkflowHeader({
            step: this.workflowStep,
            title: '个人可行性报告',
            description: '逐条展示结论和依据，不用无法解释的“成功率”代替判断。'
          })
          if (this.opportunityTitle.length > 0) {
            Text(`当前机会：${this.opportunityTitle}`)
              .width('100%')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor(COLOR_TEXT)
              .padding({ top: 4, bottom: 4 })
          }
          if (this.personalPlanCreated) {
            Row({ space: 10 }) {
              StatusPill({ text: '已生成', fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
              Text('个人行动清单已加入首页；是否组队仍由你决定。')
                .layoutWeight(1)
                .fontSize(13)
                .fontColor(COLOR_TEXT)
            }
            .width('100%')
            .padding(14)
            .backgroundColor(COLOR_PRIMARY_SOFT)
            .borderRadius(6)
          }
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
            ForEach(FEASIBILITY_ITEMS, (item: FeasibilityItem) => {
              Column({ space: 8 }) {
                Row() {
                  Text(item.title)
                    .layoutWeight(1)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(COLOR_TEXT)
                  StatusPill({
                    text: item.state,
                    fillColor: this.stateBackground(item.state),
                    textColor: this.stateColor(item.state)
                  })
                }
                .width('100%')
                Text(`依据：${item.evidence}`).fontSize(13).lineHeight(19).fontColor(COLOR_MUTED)
                Text(`下一步：${item.action}`).fontSize(13).lineHeight(19).fontColor(COLOR_BLUE)
              }
              .width(this.isWide ? '49%' : '100%')
              .margin({ bottom: 12 })
              .padding(16)
              .backgroundColor(COLOR_SURFACE)
              .borderRadius(6)
              .border({ width: 1, color: COLOR_BORDER })
              .alignItems(HorizontalAlign.Start)
            }, (item: FeasibilityItem) => item.id)
          }
          .width('100%')
          if (this.isWide) {
            Row({ space: 12 }) {
              Button('生成个人行动清单')
                .layoutWeight(1)
                .height(46)
                .fontSize(15)
                .fontColor(COLOR_PRIMARY)
                .backgroundColor(COLOR_PRIMARY_SOFT)
                .borderRadius(5)
                .onClick(() => {
                  this.personalPlanCreated = true;
                })
              Button('根据分析结果创建组队招募')
                .layoutWeight(1)
                .height(46)
                .fontSize(15)
                .fontColor('#FFFFFF')
                .backgroundColor(this.accountRole === AccountRole.STUDENT ? COLOR_PRIMARY : '#E4E8E5')
                .borderRadius(5)
                .enabled(this.accountRole === AccountRole.STUDENT)
                .onClick(() => {
                  this.workflowStep = WorkflowStep.TEAM;
                })
            }
            .width('100%')
          } else {
            Button('生成个人行动清单')
              .width('100%')
              .height(46)
              .fontSize(15)
              .fontColor(COLOR_PRIMARY)
              .backgroundColor(COLOR_PRIMARY_SOFT)
              .borderRadius(5)
              .onClick(() => {
                this.personalPlanCreated = true;
              })
            Button('根据分析结果创建组队招募')
              .width('100%')
              .height(48)
              .fontSize(15)
              .fontColor('#FFFFFF')
              .backgroundColor(this.accountRole === AccountRole.STUDENT ? COLOR_PRIMARY : '#E4E8E5')
              .borderRadius(5)
              .enabled(this.accountRole === AccountRole.STUDENT)
              .onClick(() => {
                this.workflowStep = WorkflowStep.TEAM;
              })
          }
        }
        .width('100%')
        .constraintSize({ maxWidth: PAGE_MAX_WIDTH })
        .padding({ left: this.isWide ? 28 : 18, right: this.isWide ? 28 : 18, top: 18, bottom: 28 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
  }
}
