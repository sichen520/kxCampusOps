import { ProjectTask, WorkflowStep } from '../../../domain/WorkflowModels';
import { AiAssignmentPanel } from '../components/AiAssignmentPanel';
import { ManualAssignmentPanel } from '../components/ManualAssignmentPanel';
import { StatusPill } from '../../../shared/components/StatusPill';
import { WorkflowHeader } from '../../../shared/components/WorkflowHeader';
import {
  COLOR_AMBER,
  COLOR_AMBER_SOFT,
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
export struct ProjectPlanPage {
  @Link workflowStep: WorkflowStep;
  @Link taskPlanConfirmed: boolean;
  @Link selectedTab: number;
  @Prop opportunityTitle: string = '';
  @Prop isWide: boolean = false;
  @Prop canManageProject: boolean = false;
  @Prop managerName: string = '';
  @Prop leaderName: string = '';
  @Prop memberName: string = '';
  @Prop advisorName: string = '';
  @State assignmentMode: number = 0;
  @State projectGoal: string = '';
  @State deliverable: string = '';
  @State memberDetails: string = '';
  @State constraints: string = '';
  @State aiDraftGenerated: boolean = false;
  @State firstOwner: string = '';
  @State secondOwner: string = '';
  @State thirdOwner: string = '';
  onPlanConfirmed: (tasks: ProjectTask[]) => void = (_tasks: ProjectTask[]) => {};

  private confirmPlan(tasks: ProjectTask[]): void {
    if (!this.canManageProject || tasks.length === 0) {
      return;
    }
    this.taskPlanConfirmed = true;
    this.onPlanConfirmed(tasks);
    this.workflowStep = WorkflowStep.BOARD;
    this.selectedTab = 4;
  }

  @Builder
  ProjectIdentity() {
    Column({ space: 3 }) {
      Text(this.opportunityTitle.length > 0 ? this.opportunityTitle : '校汇通项目')
        .fontSize(14).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT).maxLines(1)
      Text(this.canManageProject ? `负责人  ${this.managerName}` : '当前账号为只读成员')
        .fontSize(12).fontColor(COLOR_MUTED)
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  ModeSwitch() {
    Row({ space: 0 }) {
      Button('AI 辅助草案')
        .layoutWeight(1).height(38).fontSize(13).fontWeight(FontWeight.Medium)
        .fontColor(this.assignmentMode === 0 ? COLOR_TEXT : COLOR_MUTED)
        .backgroundColor(this.assignmentMode === 0 ? COLOR_SURFACE : Color.Transparent)
        .border({ width: this.assignmentMode === 0 ? 1 : 0, color: COLOR_BORDER })
        .borderRadius(4)
        .onClick(() => { this.assignmentMode = 0; })
      Button('手动分工')
        .layoutWeight(1).height(38).fontSize(13).fontWeight(FontWeight.Medium)
        .fontColor(this.assignmentMode === 1 ? COLOR_TEXT : COLOR_MUTED)
        .backgroundColor(this.assignmentMode === 1 ? COLOR_SURFACE : Color.Transparent)
        .border({ width: this.assignmentMode === 1 ? 1 : 0, color: COLOR_BORDER })
        .borderRadius(4)
        .onClick(() => { this.assignmentMode = 1; })
    }
    .width(this.isWide ? 300 : '100%')
    .padding(3)
    .backgroundColor(COLOR_SURFACE_ALT)
    .borderRadius(6)
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 16 }) {
          WorkflowHeader({
            step: WorkflowStep.PROJECT_PLAN,
            title: '任务分工',
            description: '确认项目边界、负责人和验收条件后发布任务。',
            isWide: this.isWide
          })
          if (this.isWide) {
            Row({ space: 14 }) {
              Column() { this.ProjectIdentity() }.layoutWeight(1)
              StatusPill({
                text: this.canManageProject ? '可发布' : '只读',
                fillColor: this.canManageProject ? COLOR_PRIMARY_SOFT : COLOR_AMBER_SOFT,
                textColor: this.canManageProject ? COLOR_PRIMARY : COLOR_AMBER
              })
              this.ModeSwitch()
            }
            .width('100%').padding({ left: 14, right: 14, top: 10, bottom: 10 })
            .backgroundColor(COLOR_SURFACE)
            .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
          } else {
            Column({ space: 10 }) {
              Row({ space: 10 }) {
                Column() { this.ProjectIdentity() }.layoutWeight(1)
                StatusPill({
                  text: this.canManageProject ? '可发布' : '只读',
                  fillColor: this.canManageProject ? COLOR_PRIMARY_SOFT : COLOR_AMBER_SOFT,
                  textColor: this.canManageProject ? COLOR_PRIMARY : COLOR_AMBER
                })
              }
              .width('100%')
              this.ModeSwitch()
            }
            .width('100%').padding(12)
            .backgroundColor(COLOR_SURFACE)
            .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
          }
          if (this.assignmentMode === 0) {
            AiAssignmentPanel({
              isWide: this.isWide,
              canManageProject: this.canManageProject,
              leaderName: this.leaderName,
              memberName: this.memberName,
              advisorName: this.advisorName,
              projectGoal: $projectGoal,
              deliverable: $deliverable,
              memberDetails: $memberDetails,
              constraints: $constraints,
              aiDraftGenerated: $aiDraftGenerated,
              firstOwner: $firstOwner,
              secondOwner: $secondOwner,
              thirdOwner: $thirdOwner,
              onConfirm: (tasks: ProjectTask[]) => { this.confirmPlan(tasks); }
            })
          } else {
            ManualAssignmentPanel({
              isWide: this.isWide,
              canManageProject: this.canManageProject,
              leaderName: this.leaderName,
              memberName: this.memberName,
              advisorName: this.advisorName,
              projectGoal: $projectGoal,
              deliverable: $deliverable,
              memberDetails: $memberDetails,
              constraints: $constraints,
              firstOwner: $firstOwner,
              secondOwner: $secondOwner,
              thirdOwner: $thirdOwner,
              onConfirm: (tasks: ProjectTask[]) => { this.confirmPlan(tasks); }
            })
          }
        }
        .width('100%')
        .constraintSize({ maxWidth: PAGE_MAX_WIDTH })
        .padding({ left: this.isWide ? 30 : 18, right: this.isWide ? 30 : 18, top: 18, bottom: 34 })
      }
      .width('100%').justifyContent(FlexAlign.Center).alignItems(VerticalAlign.Top)
    }
    .width('100%').height('100%').scrollBar(BarState.Off)
  }
}
