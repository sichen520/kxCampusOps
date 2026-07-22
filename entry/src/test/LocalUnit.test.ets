import { describe, expect, it } from '@ohos/hypium';
import { AccountRole, ApplicationState, DemoAccount, RecruitmentKind, WorkflowStep } from '../main/ets/domain/WorkflowModels';
import { RECRUITMENT_POSTS } from '../main/ets/data/MockCampusData';
import {
  accountIdForDemoAccount,
  approveApplicationState,
  canApplyForRecruitment,
  canConfirmTeam,
  canConfirmTeamFormation,
  canCreateProject,
  canPublishRecruitment,
  canPublishTaskPlan,
  confidenceLabel,
  isRecruitmentCreator,
  roleForDemoAccount,
  rejectApplicationState,
  submitApplicationState,
  workflowProgress
} from '../main/ets/domain/WorkflowRules';

export default function localUnitTest() {
  describe('workflowRules', () => {
    it('requiresLeaderApprovalBeforeTeamConfirmation', 0, () => {
      expect(canConfirmTeam(0)).assertEqual(false);
      expect(canConfirmTeam(1)).assertEqual(true);
    });

    it('separatesStudentAndTeacherPublishingPermissions', 0, () => {
      expect(canPublishRecruitment(AccountRole.STUDENT, RecruitmentKind.COMPETITION)).assertEqual(true);
      expect(canPublishRecruitment(AccountRole.STUDENT, RecruitmentKind.ACTIVITY)).assertEqual(false);
      expect(canPublishRecruitment(AccountRole.TEACHER, RecruitmentKind.COMPETITION)).assertEqual(false);
      expect(canPublishRecruitment(AccountRole.TEACHER, RecruitmentKind.ACTIVITY)).assertEqual(true);
    });

    it('onlyAllowsStudentsToSubmitParticipationApplications', 0, () => {
      expect(canApplyForRecruitment(AccountRole.STUDENT)).assertEqual(true);
      expect(canApplyForRecruitment(AccountRole.TEACHER)).assertEqual(false);
      expect(canApplyForRecruitment(AccountRole.ADMIN)).assertEqual(false);
    });

    it('mapsDemoAccountsToPermissionRoles', 0, () => {
      expect(roleForDemoAccount(DemoAccount.STUDENT_APPLICANT)).assertEqual(AccountRole.STUDENT);
      expect(roleForDemoAccount(DemoAccount.STUDENT_SECONDARY)).assertEqual(AccountRole.STUDENT);
      expect(roleForDemoAccount(DemoAccount.TEACHER)).assertEqual(AccountRole.TEACHER);
      expect(roleForDemoAccount(DemoAccount.ADMIN)).assertEqual(AccountRole.ADMIN);
    });

    it('derivesLeaderPermissionFromRecruitmentCreatorInsteadOfAccountRole', 0, () => {
      expect(accountIdForDemoAccount(DemoAccount.STUDENT_APPLICANT)).assertEqual('liran');
      expect(accountIdForDemoAccount(DemoAccount.STUDENT_SECONDARY)).assertEqual('wangchen');
      expect(isRecruitmentCreator(DemoAccount.STUDENT_SECONDARY, RECRUITMENT_POSTS[0])).assertEqual(true);
      expect(isRecruitmentCreator(DemoAccount.STUDENT_APPLICANT, RECRUITMENT_POSTS[0])).assertEqual(false);
    });

    it('requiresPendingStateBeforeApplicationApproval', 0, () => {
      expect(submitApplicationState()).assertEqual(ApplicationState.PENDING);
      expect(approveApplicationState(ApplicationState.PENDING)).assertEqual(ApplicationState.APPROVED);
      expect(approveApplicationState(ApplicationState.NONE)).assertEqual(ApplicationState.NONE);
      expect(rejectApplicationState(ApplicationState.PENDING)).assertEqual(ApplicationState.REJECTED);
      expect(rejectApplicationState(ApplicationState.APPROVED)).assertEqual(ApplicationState.APPROVED);
    });

    it('requiresConfirmedTeamBeforeProjectCreation', 0, () => {
      expect(canCreateProject(false)).assertEqual(false);
      expect(canCreateProject(true)).assertEqual(true);
    });

    it('requiresLeaderApprovalBeforeFormalTeamConfirmation', 0, () => {
      expect(canConfirmTeamFormation(true, 'team-1', 'team-1', ApplicationState.APPROVED)).assertEqual(true);
      expect(canConfirmTeamFormation(false, 'team-1', 'team-1', ApplicationState.APPROVED)).assertEqual(false);
      expect(canConfirmTeamFormation(true, 'team-1', 'team-2', ApplicationState.APPROVED)).assertEqual(false);
      expect(canConfirmTeamFormation(true, 'team-1', 'team-1', ApplicationState.PENDING)).assertEqual(false);
    });

    it('requiresOwnerConfirmationBeforePublishingTasks', 0, () => {
      expect(canPublishTaskPlan(false)).assertEqual(false);
      expect(canPublishTaskPlan(true)).assertEqual(true);
    });

    it('calculatesWorkflowProgress', 0, () => {
      expect(workflowProgress(WorkflowStep.IMPORT)).assertEqual(17);
      expect(workflowProgress(WorkflowStep.BOARD)).assertEqual(100);
    });

    it('labelsConfidenceForManualReview', 0, () => {
      expect(confidenceLabel(0.95)).assertEqual('高置信');
      expect(confidenceLabel(0.75)).assertEqual('待核对');
      expect(confidenceLabel(0.5)).assertEqual('低置信');
    });
  });
}
