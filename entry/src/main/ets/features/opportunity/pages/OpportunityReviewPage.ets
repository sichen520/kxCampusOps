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
  COLOR_SURFACE_ALT,
  COLOR_TEXT,
  PAGE_MAX_WIDTH
} from '../../../shared/Theme';

@Component
export struct OpportunityReviewPage {
  @Link workflowStep: WorkflowStep;
  @Prop opportunityTitle: string = '';
  @Prop isWide: boolean = false;

  private fieldValue(field: OpportunityField): string {
    return field.id === 'name' && this.opportunityTitle.length > 0 ? this.opportunityTitle : field.value;
  }

  private fieldSource(field: OpportunityField): string {
    return field.id === 'name' && this.opportunityTitle.length > 0 ? '首页招募详情' : field.source;
  }

  private confidenceFill(field: OpportunityField): string {
    return field.confidence >= 0.9 ? COLOR_PRIMARY_SOFT : COLOR_AMBER_SOFT;
  }

  private confidenceColor(field: OpportunityField): string {
    return field.confidence >= 0.9 ? COLOR_PRIMARY : COLOR_AMBER;
  }

  @Builder
  DesktopHeader() {
    Row() {
      Text('字段').width('17%').fontSize(12).fontColor(COLOR_MUTED)
      Text('解析结果').width('39%').fontSize(12).fontColor(COLOR_MUTED)
      Text('原文位置').width('29%').fontSize(12).fontColor(COLOR_MUTED)
      Text('置信度').width('15%').fontSize(12).fontColor(COLOR_MUTED)
    }
    .width('100%')
    .height(42)
    .padding({ left: 16, right: 16 })
    .backgroundColor(COLOR_SURFACE_ALT)
    .border({ width: { top: 1, bottom: 1 }, color: COLOR_BORDER })
  }

  @Builder
  DesktopRow(field: OpportunityField) {
    Row() {
      Column({ space: 3 }) {
        Text(field.label).fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        Text(field.id.toUpperCase()).fontSize(10).fontColor(COLOR_MUTED)
      }
      .width('17%')
      .alignItems(HorizontalAlign.Start)

      Text(this.fieldValue(field))
        .width('39%')
        .padding({ right: 22 })
        .fontSize(14)
        .lineHeight(20)
        .fontColor(COLOR_TEXT)

      Column({ space: 4 }) {
        Text(this.fieldSource(field)).fontSize(12).lineHeight(18).fontColor(COLOR_BLUE)
        Text('原文证据已关联').fontSize(11).fontColor(COLOR_MUTED)
      }
      .width('29%')
      .padding({ right: 16 })
      .alignItems(HorizontalAlign.Start)

      Row() {
        StatusPill({
          text: confidenceLabel(field.confidence),
          fillColor: this.confidenceFill(field),
          textColor: this.confidenceColor(field)
        })
      }
      .width('15%')
    }
    .width('100%')
    .constraintSize({ minHeight: 76 })
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor(COLOR_SURFACE)
    .border({ width: { bottom: 1 }, color: COLOR_BORDER })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  MobileRow(field: OpportunityField) {
    Column({ space: 9 }) {
      Row() {
        Text(field.label).fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        Blank()
        StatusPill({
          text: confidenceLabel(field.confidence),
          fillColor: this.confidenceFill(field),
          textColor: this.confidenceColor(field)
        })
      }
      .width('100%')
      Text(this.fieldValue(field)).fontSize(15).lineHeight(21).fontColor(COLOR_TEXT)
      Row({ space: 8 }) {
        Text('证据').fontSize(11).fontColor(COLOR_MUTED)
        Text(this.fieldSource(field)).layoutWeight(1).fontSize(12).fontColor(COLOR_BLUE)
      }
      .width('100%')
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .border({ width: { bottom: 1 }, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  FieldLedger() {
    Column() {
      Row() {
        Column({ space: 3 }) {
          Text('证据字段台账').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('每个结论都能回到原文位置。').fontSize(12).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        Text(`${OPPORTUNITY_FIELDS.length} 项字段`)
          .fontSize(11)
          .fontColor(COLOR_PRIMARY)
      }
      .width('100%')
      .padding({ top: 14, bottom: 14 })

      if (this.isWide) {
        this.DesktopHeader()
        ForEach(OPPORTUNITY_FIELDS, (field: OpportunityField) => {
          this.DesktopRow(field)
        }, (field: OpportunityField) => field.id)
      } else {
        Divider().color(COLOR_BORDER)
        ForEach(OPPORTUNITY_FIELDS, (field: OpportunityField) => {
          this.MobileRow(field)
        }, (field: OpportunityField) => field.id)
      }
    }
    .width('100%')
    .padding({ left: this.isWide ? 0 : 2, right: this.isWide ? 0 : 2 })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  ActionBar() {
    if (this.isWide) {
      Row({ space: 12 }) {
        Column({ space: 3 }) {
          Text('字段已具备生成判断的条件').fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
          Text('确认后进入资格、能力、时间与指导条件判断。').fontSize(12).fontColor(COLOR_MUTED)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        Button('返回导入')
          .width(132).height(42).fontSize(13).fontColor(COLOR_PRIMARY)
          .backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER })
          .borderRadius(4)
          .onClick(() => {
            this.workflowStep = WorkflowStep.IMPORT;
          })
        Button('确认并生成报告')
          .width(184).height(42).fontSize(13).fontColor('#FFFFFF')
          .backgroundColor(COLOR_PRIMARY).borderRadius(4)
          .onClick(() => {
            this.workflowStep = WorkflowStep.FEASIBILITY;
          })
      }
      .width('100%')
      .padding({ top: 16, bottom: 4 })
      .border({ width: { top: 1 }, color: COLOR_BORDER })
    } else {
      Button('确认字段并生成报告')
        .width('100%').height(48).fontSize(15).fontColor('#FFFFFF')
        .backgroundColor(COLOR_PRIMARY).borderRadius(4)
        .onClick(() => {
          this.workflowStep = WorkflowStep.FEASIBILITY;
        })
      Button('返回重新导入')
        .width('100%').height(42).fontSize(14).fontColor(COLOR_PRIMARY)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.workflowStep = WorkflowStep.IMPORT;
        })
    }
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 18 }) {
          WorkflowHeader({
            step: this.workflowStep,
            title: '核对材料信息',
            description: '确认解析字段与原文证据，再生成个人可行性报告。',
            isWide: this.isWide
          })

          Row({ space: 10 }) {
            StatusPill({ text: '当前机会', fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
            Text(this.opportunityTitle.length > 0 ? this.opportunityTitle : '2026 中国高校计算机大赛 · 鸿蒙高校创新赛')
              .layoutWeight(1)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor(COLOR_TEXT)
          }
          .width('100%')
          .padding({ top: 11, bottom: 11 })
          .border({ width: { top: 1, bottom: 1 }, color: COLOR_BORDER })

          this.FieldLedger()
          this.ActionBar()
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
