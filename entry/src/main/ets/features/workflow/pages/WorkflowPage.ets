import { AccountRole, DemoAccount, ProjectTask, RecruitmentPost, WorkflowStep } from '../../../domain/WorkflowModels';
import { FeasibilityPage } from '../../feasibility/pages/FeasibilityPage';
import { OpportunityImportPage } from '../../opportunity/pages/OpportunityImportPage';
import { OpportunityReviewPage } from '../../opportunity/pages/OpportunityReviewPage';
import { ProjectPlanPage } from '../../project/pages/ProjectPlanPage';
import { ProjectBoardPage } from '../../project/pages/ProjectBoardPage';
import { TeamCreatePage } from '../../team/pages/TeamCreatePage';

@Component
export struct WorkflowPage {
  @Link selectedTab: number;
  @Link workflowStep: WorkflowStep;
  @Link sourceSelected: boolean;
  @Link personalPlanCreated: boolean;
  @Link candidateApproved: boolean;
  @Link teamConfirmed: boolean;
  @Link taskPlanConfirmed: boolean;
  @Link firstTaskStarted: boolean;
  @Prop isWide: boolean = false;
  @Prop opportunityTitle: string = '';
  @Prop canManageProject: boolean = false;
  @Prop managerName: string = '';
  @Prop leaderName: string = '';
  @Prop memberName: string = '';
  @Prop advisorName: string = '';
  @Prop projectTasks: ProjectTask[] = [];
  @Prop currentTaskOwnerName: string = '';
  @Prop accountRole: AccountRole = AccountRole.STUDENT;
  @Prop demoAccount: DemoAccount = DemoAccount.STUDENT_APPLICANT;
  onTeamRecruitmentCreated: (post: RecruitmentPost) => void = (_post: RecruitmentPost) => {};
  onPlanConfirmed: (tasks: ProjectTask[]) => void = (_tasks: ProjectTask[]) => {};

  build() {
    if (this.workflowStep === WorkflowStep.IMPORT) {
      OpportunityImportPage({
        sourceSelected: $sourceSelected,
        workflowStep: $workflowStep,
        opportunityTitle: this.opportunityTitle,
        isWide: this.isWide
      })
    } else if (this.workflowStep === WorkflowStep.REVIEW) {
      OpportunityReviewPage({
        workflowStep: $workflowStep,
        opportunityTitle: this.opportunityTitle,
        isWide: this.isWide
      })
    } else if (this.workflowStep === WorkflowStep.FEASIBILITY) {
      FeasibilityPage({
        workflowStep: $workflowStep,
        personalPlanCreated: $personalPlanCreated,
        opportunityTitle: this.opportunityTitle,
        isWide: this.isWide,
        accountRole: this.accountRole
      })
    } else if (this.workflowStep === WorkflowStep.TEAM) {
      TeamCreatePage({
        accountRole: this.accountRole,
        demoAccount: this.demoAccount,
        isWide: this.isWide,
        suggestedTitle: this.opportunityTitle,
        onClose: () => {
          this.workflowStep = WorkflowStep.FEASIBILITY;
        },
        onCreated: (post: RecruitmentPost) => {
          this.onTeamRecruitmentCreated(post);
          this.selectedTab = 3;
        }
      })
    } else if (this.workflowStep === WorkflowStep.PROJECT_PLAN) {
      ProjectPlanPage({
        workflowStep: $workflowStep,
        taskPlanConfirmed: $taskPlanConfirmed,
        selectedTab: $selectedTab,
        opportunityTitle: this.opportunityTitle,
        isWide: this.isWide,
        canManageProject: this.canManageProject,
        managerName: this.managerName,
        leaderName: this.leaderName,
        memberName: this.memberName,
        advisorName: this.advisorName,
        onPlanConfirmed: (tasks: ProjectTask[]) => {
          this.onPlanConfirmed(tasks);
        }
      })
    } else {
      ProjectBoardPage({
        selectedTab: $selectedTab,
        workflowStep: $workflowStep,
        taskPlanConfirmed: $taskPlanConfirmed,
        firstTaskStarted: $firstTaskStarted,
        opportunityTitle: this.opportunityTitle,
        isWide: this.isWide,
        canManageProject: this.canManageProject,
        currentTaskOwnerName: this.currentTaskOwnerName,
        hasTeam: this.teamConfirmed,
        teamConfirmed: this.teamConfirmed,
        tasks: this.projectTasks,
        hasProject: this.teamConfirmed && this.taskPlanConfirmed && this.projectTasks.length > 0
      })
    }
  }
}
