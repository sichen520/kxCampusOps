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
  ImportControls() {
    Column({ space: 12 }) {
      Text('选择采集方式')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT)
      Row({ space: 10 }) {
        Button('扫描海报')
          .layoutWeight(1)
          .height(44)
          .fontSize(14)
          .fontColor(COLOR_PRIMARY)
          .backgroundColor(COLOR_PRIMARY_SOFT)
          .borderRadius(5)
          .onClick(() => {
            this.sourceSelected = true;
          })
        Button('导入演示资料')
          .layoutWeight(1)
          .height(44)
          .fontSize(14)
          .fontColor(COLOR_BLUE)
          .backgroundColor(COLOR_BLUE_SOFT)
          .borderRadius(5)
          .onClick(() => {
            this.sourceSelected = true;
          })
      }
      .width('100%')
    }
    .width('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(6)
    .border({ width: 1, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  SourcePreview() {
    Column({ space: 10 }) {
      Row() {
        StatusPill({ text: '已导入', fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
        Blank()
        Text('PDF · 12 页').fontSize(12).fontColor(COLOR_MUTED)
      }
      .width('100%')
      Text(this.opportunityTitle.length > 0 ? this.opportunityTitle : '2026 鸿蒙高校创新赛竞赛规程.pdf')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(COLOR_TEXT)
      Text('原始文件、采集时间和内容指纹会随解析结果一起保存。')
        .fontSize(13)
        .fontColor(COLOR_MUTED)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(6)
    .border({ width: 1, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 18 }) {
          WorkflowHeader({
            step: this.workflowStep,
            title: '导入机会材料',
            description: '支持海报、截图、PDF、链接和手动录入。当前先用本地演示资料验证完整流程。'
          })
          if (this.isWide) {
            Row({ space: 16 }) {
              Column() { this.ImportControls() }.layoutWeight(1)
              Column() {
                if (this.sourceSelected) {
                  this.SourcePreview()
                } else {
                  Column({ space: 8 }) {
                    Text('等待导入资料').fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
                    Text('PC 端可以从文件系统选择 PDF 或图片。').fontSize(13).fontColor(COLOR_MUTED)
                  }
                  .width('100%')
                  .padding(24)
                  .backgroundColor(COLOR_SURFACE)
                  .borderRadius(6)
                  .border({ width: 1, color: COLOR_BORDER })
                  .alignItems(HorizontalAlign.Start)
                }
              }
              .layoutWeight(1)
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)
          } else {
            this.ImportControls()
            if (this.sourceSelected) {
              this.SourcePreview()
            }
          }
          Button('解析材料')
            .width('100%')
            .height(48)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF')
            .backgroundColor(this.sourceSelected ? COLOR_PRIMARY : '#AAB2AD')
            .borderRadius(5)
            .enabled(this.sourceSelected)
            .onClick(() => {
              this.workflowStep = WorkflowStep.REVIEW;
            })
          Text('解析结果会保留原始材料，发现不准确时可以回到人工核对。')
            .width('100%')
            .textAlign(TextAlign.Center)
            .fontSize(12)
            .fontColor(COLOR_MUTED)
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
