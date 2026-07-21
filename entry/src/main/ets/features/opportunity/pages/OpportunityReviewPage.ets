import { OpportunityField, WorkflowStep } from '../../../domain/WorkflowModels';
import { OPPORTUNITY_FIELDS } from '../../../data/MockCampusData';
import { confidenceLabel } from '../../../domain/WorkflowRules';
import { StatusPill } from '../../../shared/components/StatusPill';
import { WorkflowHeader } from '../../../shared/components/WorkflowHeader';
import {
  COLOR_AMBER,
  COLOR_AMBER_SOFT,
  COLOR_BLUE,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  COLOR_TEXT,
  PAGE_MAX_WIDTH
} from '../../../shared/Theme';

@Component
export struct OpportunityReviewPage {
  @Link workflowStep: WorkflowStep;
  @Prop opportunityTitle: string = '';
  @Prop isWide: boolean = false;

  build() {
    Scroll() {
      Row() {
        Column({ space: 16 }) {
          WorkflowHeader({
            step: this.workflowStep,
            title: '核对材料信息',
            description: '逐项确认报名条件、时间和材料要求；确认后才会进入资格判断。'
          })
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
            ForEach(OPPORTUNITY_FIELDS, (field: OpportunityField) => {
              Column({ space: 9 }) {
                Row() {
                  Text(field.label).fontSize(13).fontColor(COLOR_MUTED)
                  Blank()
                  StatusPill({
                    text: confidenceLabel(field.confidence),
                    fillColor: field.confidence >= 0.9 ? COLOR_PRIMARY_SOFT : COLOR_AMBER_SOFT,
                    textColor: field.confidence >= 0.9 ? COLOR_PRIMARY : COLOR_AMBER
                  })
                }
                .width('100%')
                Text(field.id === 'name' && this.opportunityTitle.length > 0 ? this.opportunityTitle : field.value)
                  .fontSize(16).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
                Text(field.id === 'name' && this.opportunityTitle.length > 0 ? '原文依据：首页招募详情' : `原文依据：${field.source}`)
                  .fontSize(12).fontColor(COLOR_BLUE)
              }
              .width(this.isWide ? '49%' : '100%')
              .margin({ bottom: 12 })
              .padding(16)
              .backgroundColor(COLOR_SURFACE)
              .borderRadius(6)
              .border({ width: 1, color: COLOR_BORDER })
              .alignItems(HorizontalAlign.Start)
            }, (field: OpportunityField) => field.id)
          }
          .width('100%')
          Button('确认字段并生成报告')
            .width('100%')
            .height(48)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF')
            .backgroundColor(COLOR_PRIMARY)
            .borderRadius(5)
            .onClick(() => {
              this.workflowStep = WorkflowStep.FEASIBILITY;
            })
          Button('返回重新导入')
            .width('100%')
            .height(42)
            .fontSize(14)
            .fontColor(COLOR_PRIMARY)
            .backgroundColor(Color.Transparent)
            .onClick(() => {
              this.workflowStep = WorkflowStep.IMPORT;
            })
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
