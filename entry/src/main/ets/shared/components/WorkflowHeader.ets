import { WorkflowStep } from '../../domain/WorkflowModels';
import { workflowProgress } from '../../domain/WorkflowRules';
import { COLOR_BORDER, COLOR_MUTED, COLOR_PRIMARY, COLOR_SURFACE, COLOR_TEXT } from '../Theme';

const WORKFLOW_STEP_INDICES: number[] = [0, 1, 2, 3, 4, 5];
const WORKFLOW_STEP_LABELS: string[] = ['导入机会', '核对信息', '判断条件', '组建队伍', '任务规划', '项目执行'];

@Component
export struct WorkflowHeader {
  @Prop step: WorkflowStep = WorkflowStep.IMPORT;
  @Prop title: string = '';
  @Prop description: string = '';
  @Prop isWide: boolean = false;

  private stepLabel(): string {
    return WORKFLOW_STEP_LABELS[this.step];
  }

  private stepNumber(): string {
    const value: number = this.step + 1;
    return value < 10 ? `0${value}` : `${value}`;
  }

  build() {
    Column({ space: 10 }) {
      if (this.isWide) {
        Row({ space: 0 }) {
          ForEach(WORKFLOW_STEP_INDICES, (index: number) => {
            Column({ space: 6 }) {
              Text((index + 1).toString())
                .width(24)
                .height(24)
                .padding({ top: 4 })
                .textAlign(TextAlign.Center)
                .fontSize(11)
                .fontWeight(FontWeight.Bold)
                .fontColor(index <= this.step ? '#FFFFFF' : COLOR_MUTED)
                .backgroundColor(index <= this.step ? COLOR_PRIMARY : COLOR_SURFACE)
                .border({ width: 1, color: index <= this.step ? COLOR_PRIMARY : COLOR_BORDER })
                .borderRadius(12)
              Text(WORKFLOW_STEP_LABELS[index])
                .fontSize(11)
                .fontWeight(index === this.step ? FontWeight.Bold : FontWeight.Medium)
                .fontColor(index === this.step ? COLOR_TEXT : COLOR_MUTED)
                .letterSpacing(0.3)
                .maxLines(1)
            }
            .layoutWeight(1)
          }, (index: number) => index.toString())
        }
        .width('100%')
      } else {
        Row({ space: 8 }) {
          Text(this.stepNumber())
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_PRIMARY)
          Text('/ 06')
            .fontSize(11)
            .fontColor(COLOR_MUTED)
          Column()
            .width(1)
            .height(12)
            .backgroundColor(COLOR_BORDER)
          Text(this.stepLabel())
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor(COLOR_TEXT)
          Blank()
          Text(`${workflowProgress(this.step)}%`)
            .fontSize(11)
            .fontColor(COLOR_MUTED)
        }
        .width('100%')
      }

      Row({ space: 4 }) {
        ForEach(WORKFLOW_STEP_INDICES, (index: number) => {
          Column()
            .layoutWeight(1)
            .height(3)
            .borderRadius(1)
            .backgroundColor(index <= this.step ? COLOR_PRIMARY : COLOR_BORDER)
        }, (index: number) => index.toString())
      }
      .width('100%')

      if (this.title.length > 0) {
        Text(this.title)
          .fontSize(22)
          .lineHeight(29)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      if (this.description.length > 0) {
        Text(this.description)
          .fontSize(13)
          .lineHeight(20)
          .fontColor(COLOR_MUTED)
          .constraintSize({ maxWidth: 760 })
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
