import { WorkflowStep } from '../../../domain/WorkflowModels';
import { AiAssignmentPanel } from '../components/AiAssignmentPanel';
import { ManualAssignmentPanel } from '../components/ManualAssignmentPanel';
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
  COLOR_SURFACE,
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
  onPlanConfirmed: () => void = () => {};

  private confirmPlan(): void {
    this.taskPlanConfirmed = true;
    this.onPlanConfirmed();
    this.workflowStep = WorkflowStep.BOARD;
    this.selectedTab = 4;
  }

  @Builder
  ModeSwitch() {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
      Column({ space: 4 }) {
        Row({ space: 8 }) {
          Text('AI').fontSize(12).fontWeight(FontWeight.Bold)
            .fontColor(this.assignmentMode === 0 ? '#FFFFFF' : COLOR_BLUE)
            .backgroundColor(this.assignmentMode === 0 ? COLOR_BLUE : COLOR_BLUE_SOFT)
            .borderRadius(4).padding({ left: 7, right: 7, top: 4, bottom: 4 })
          Text('AI 辅助分工').fontSize(15).fontWeight(FontWeight.Bold)
            .fontColor(this.assignmentMode === 0 ? COLOR_TEXT : COLOR_MUTED)
        }
        Text('提交完整上下文，生成带匹配理由和风险说明的任务建议')
          .fontSize(11).fontColor(COLOR_MUTED).maxLines(2)
      }
      .width(this.isWide ? '49%' : '100%').height(72).padding(12).margin({ bottom: this.isWide ? 0 : 8 })
      .backgroundColor(this.assignmentMode === 0 ? COLOR_BLUE_SOFT : COLOR_SURFACE)
      .border({ width: 1, color: this.assignmentMode === 0 ? COLOR_BLUE : COLOR_BORDER })
      .borderRadius(7).alignItems(HorizontalAlign.Start)
      .onClick(() => { this.assignmentMode = 0; })
      Column({ space: 4 }) {
        Row({ space: 8 }) {
          Text('人').fontSize(12).fontWeight(FontWeight.Bold)
            .fontColor(this.assignmentMode === 1 ? '#FFFFFF' : COLOR_PRIMARY)
            .backgroundColor(this.assignmentMode === 1 ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
            .borderRadius(4).padding({ left: 7, right: 7, top: 4, bottom: 4 })
          Text('人工任务编排').fontSize(15).fontWeight(FontWeight.Bold)
            .fontColor(this.assignmentMode === 1 ? COLOR_TEXT : COLOR_MUTED)
        }
        Text('逐项创建和编辑任务，手动指定负责人、优先级与验收条件')
          .fontSize(11).fontColor(COLOR_MUTED).maxLines(2)
      }
      .width(this.isWide ? '49%' : '100%').height(72).padding(12)
      .backgroundColor(this.assignmentMode === 1 ? COLOR_PRIMARY_SOFT : COLOR_SURFACE)
      .border({ width: 1, color: this.assignmentMode === 1 ? COLOR_PRIMARY : COLOR_BORDER })
      .borderRadius(7).alignItems(HorizontalAlign.Start)
      .onClick(() => { this.assignmentMode = 1; })
    }
    .width('100%')
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 16 }) {
          WorkflowHeader({
            step: WorkflowStep.PROJECT_PLAN,
            title: '项目分工工作台',
            description: 'AI 模式负责生成可解释建议；人工模式提供完整任务编辑器。两种方式都必须由负责人确认后发布。'
          })
          if (this.opportunityTitle.length > 0) {
            Row({ space: 8 }) {
              Text('项目').fontSize(11).fontColor(COLOR_BLUE).backgroundColor(COLOR_BLUE_SOFT)
                .borderRadius(3).padding({ left: 7, right: 7, top: 4, bottom: 4 })
              Text(this.opportunityTitle).layoutWeight(1).fontSize(14).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
            }
            .width('100%')
          }
          Row({ space: 10 }) {
            StatusPill({ text: this.canManageProject ? '可编辑并发布' : '只读预览',
              fillColor: this.canManageProject ? COLOR_PRIMARY_SOFT : COLOR_AMBER_SOFT,
              textColor: this.canManageProject ? COLOR_PRIMARY : COLOR_AMBER })
            Text(this.canManageProject ? `当前负责人：${this.managerName}` :
              '只有本队队长或已接受邀请的指导老师可以修改和发布分工。')
              .layoutWeight(1).fontSize(13).fontColor(COLOR_TEXT)
          }
          .width('100%').padding(12)
          .backgroundColor(this.canManageProject ? '#F5FAF8' : COLOR_AMBER_SOFT).borderRadius(6)
          this.ModeSwitch()
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
              onConfirm: () => { this.confirmPlan(); }
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
              onConfirm: () => { this.confirmPlan(); }
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
