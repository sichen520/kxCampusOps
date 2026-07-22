import { WorkflowStep } from '../../../domain/WorkflowModels';
import { StatusPill } from '../../../shared/components/StatusPill';
import { WorkflowHeader } from '../../../shared/components/WorkflowHeader';
import {
  COLOR_BLUE,
  COLOR_BLUE_SOFT,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  COLOR_TEXT,
  PAGE_MAX_WIDTH
} from '../../../shared/Theme';

@Component
export struct OpportunityImportPage {
  @Link sourceSelected: boolean;
  @Link workflowStep: WorkflowStep;
  @Prop opportunityTitle: string = '';
  @Prop isWide: boolean = false;

  @Builder
  SourceRow(index: string, title: string, detail: string, action: string, primary: boolean) {
    Row({ space: 14 }) {
      Text(index)
        .width(28)
        .fontSize(11)
        .fontWeight(FontWeight.Medium)
        .fontColor(primary ? COLOR_PRIMARY : COLOR_BLUE)
      Column({ space: 3 }) {
        Text(title).fontSize(15).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        Text(detail).fontSize(12).fontColor(COLOR_MUTED)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      Button(action)
        .height(34)
        .fontSize(12)
        .fontColor(primary ? COLOR_PRIMARY : COLOR_BLUE)
        .backgroundColor(primary ? COLOR_PRIMARY_SOFT : COLOR_BLUE_SOFT)
        .borderRadius(4)
        .onClick(() => {
          this.sourceSelected = true;
        })
    }
    .width('100%')
    .padding({ top: 15, bottom: 15 })
  }

  @Builder
  SourcePanel() {
    Column() {
      Row() {
        Column({ space: 3 }) {
          Text('材料来源').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('选择一种来源建立原文证据。').fontSize(12).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        StatusPill({
          text: this.sourceSelected ? '已选择' : '待选择',
          fillColor: this.sourceSelected ? COLOR_PRIMARY_SOFT : COLOR_BLUE_SOFT,
          textColor: this.sourceSelected ? COLOR_PRIMARY : COLOR_BLUE
        })
      }
      .width('100%')
      .padding({ top: 14, bottom: 14 })
      .border({ width: { bottom: 1 }, color: COLOR_BORDER })

      this.SourceRow('01', '扫描海报', '调用相机采集比赛海报或通知截图', '扫描', true)
      Divider().color(COLOR_BORDER)
      this.SourceRow('02', '导入演示资料', '本地 PDF · 12 页 · 已包含竞赛规程', '导入', false)
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor(COLOR_SURFACE)
    .border({ width: { top: 1, bottom: 1 }, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  EvidenceRow(label: string, value: string, accent: boolean = false) {
    Row({ space: 14 }) {
      Text(label).width(this.isWide ? 82 : 72).fontSize(12).fontColor(COLOR_MUTED)
      Text(value)
        .layoutWeight(1)
        .fontSize(13)
        .fontColor(accent ? COLOR_BLUE : COLOR_TEXT)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .padding({ top: 10, bottom: 10 })
    .border({ width: { bottom: 1 }, color: COLOR_BORDER })
  }

  @Builder
  SourceEvidence() {
    Column() {
      Row() {
        Column({ space: 3 }) {
          Text('原文记录').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('解析前先固定文件与采集信息。').fontSize(12).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        StatusPill({ text: 'PDF · 12 页', fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
      }
      .width('100%')
      .padding({ top: 14, bottom: 14 })
      .border({ width: { bottom: 1 }, color: COLOR_BORDER })

      Column({ space: 7 }) {
        Text('已导入材料').fontSize(11).fontColor(COLOR_BLUE)
        Text(this.opportunityTitle.length > 0 ? this.opportunityTitle : '2026 鸿蒙高校创新赛竞赛规程.pdf')
          .fontSize(this.isWide ? 19 : 17)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT)
        Text('竞赛规程与报名要求').fontSize(12).fontColor(COLOR_MUTED)
      }
      .width('100%')
      .padding({ top: 16, bottom: 12 })
      .alignItems(HorizontalAlign.Start)

      this.EvidenceRow('文件名', 'harmonyos_competition_rules_2026.pdf', true)
      this.EvidenceRow('采集方式', '本地文件导入')
      this.EvidenceRow('内容指纹', 'SHA-256 · 7C9A…42E1')
      this.EvidenceRow('处理状态', '原文已固定，等待解析')
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor(COLOR_SURFACE)
    .border({ width: { top: 1, bottom: 1 }, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  EmptyEvidence() {
    Column({ space: 8 }) {
      Text('尚未建立原文记录').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      Text('选择左侧来源后，这里显示文件、页数和内容指纹。')
        .fontSize(13).lineHeight(20).fontColor(COLOR_MUTED)
    }
    .width('100%')
    .constraintSize({ minHeight: 190 })
    .padding(18)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor(COLOR_SURFACE)
    .border({ width: { top: 1, bottom: 1 }, color: COLOR_BORDER })
  }

  @Builder
  ActionBar() {
    if (this.isWide) {
      Row({ space: 16 }) {
        Column({ space: 3 }) {
          Text(this.sourceSelected ? '材料已就绪' : '等待材料来源')
            .fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
          Text('下一步会提取字段，并保留每项原文位置。').fontSize(12).fontColor(COLOR_MUTED)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        Button('解析材料')
          .width(184)
          .height(44)
          .fontSize(14)
          .fontColor('#FFFFFF')
          .backgroundColor(this.sourceSelected ? COLOR_PRIMARY : '#AAB2AD')
          .borderRadius(4)
          .enabled(this.sourceSelected)
          .onClick(() => {
            this.workflowStep = WorkflowStep.REVIEW;
          })
      }
      .width('100%')
      .padding({ top: 16, bottom: 4 })
      .border({ width: { top: 1 }, color: COLOR_BORDER })
    } else {
      Button('解析材料')
        .width('100%')
        .height(48)
        .fontSize(15)
        .fontColor('#FFFFFF')
        .backgroundColor(this.sourceSelected ? COLOR_PRIMARY : '#AAB2AD')
        .borderRadius(4)
        .enabled(this.sourceSelected)
        .onClick(() => {
          this.workflowStep = WorkflowStep.REVIEW;
        })
    }
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 18 }) {
          WorkflowHeader({
            step: this.workflowStep,
            title: '导入机会材料',
            description: '选择来源并固定原文，解析结果将逐项关联证据。',
            isWide: this.isWide
          })

          if (this.isWide) {
            Row({ space: 24 }) {
              Column() { this.SourcePanel() }.width('38%')
              Column() {
                if (this.sourceSelected) {
                  this.SourceEvidence()
                } else {
                  this.EmptyEvidence()
                }
              }
              .layoutWeight(1)
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)
          } else {
            this.SourcePanel()
            if (this.sourceSelected) {
              this.SourceEvidence()
            } else {
              this.EmptyEvidence()
            }
          }

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
