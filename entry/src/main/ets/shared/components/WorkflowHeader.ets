import { WorkflowStep } from '../../domain/WorkflowModels';
import { workflowProgress } from '../../domain/WorkflowRules';
import { COLOR_MUTED, COLOR_PRIMARY, COLOR_PRIMARY_SOFT, COLOR_TEXT } from '../Theme';

@Component
export struct WorkflowHeader {
  @Prop step: WorkflowStep = WorkflowStep.IMPORT;
  @Prop title: string = '';
  @Prop description: string = '';

  private stepLabel(): string {
    const labels: string[] = ['导入材料', '核对信息', '判断条件', '组建队伍', '确认任务', '执行项目'];
    return labels[this.step];
  }

  build() {
    Column({ space: 12 }) {
      Row({ space: 12 }) {
        Text(`${this.step + 1}`)
          .width(34)
          .height(34)
          .textAlign(TextAlign.Center)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .backgroundColor(COLOR_PRIMARY)
          .borderRadius(17)
          .padding({ top: 7 })
        Column({ space: 3 }) {
          Text(`机会推进 · ${this.stepLabel()}`)
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor(COLOR_PRIMARY)
          Text(`${workflowProgress(this.step)}% 已完成`)
            .fontSize(12)
            .fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
      }
      .width('100%')

      Progress({ value: workflowProgress(this.step), total: 100, type: ProgressType.Linear })
        .width('100%')
        .height(6)
        .color(COLOR_PRIMARY)
        .backgroundColor(COLOR_PRIMARY_SOFT)

      Text(this.title)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT)
      Text(this.description)
        .fontSize(13)
        .lineHeight(20)
        .fontColor(COLOR_MUTED)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
