import { AccountRole, ApplicationState, DemoAccount, RecruitmentKind, RecruitmentPost, WorkflowStep } from './WorkflowModels';

export function submitApplicationState(): ApplicationState {
  return ApplicationState.PENDING;
}

export function approveApplicationState(current: ApplicationState): ApplicationState {
  return current === ApplicationState.PENDING ? ApplicationState.APPROVED : current;
}

export function rejectApplicationState(current: ApplicationState): ApplicationState {
  return current === ApplicationState.PENDING ? ApplicationState.REJECTED : current;
}

export function roleForDemoAccount(account: DemoAccount): AccountRole {
  if (account === DemoAccount.TEACHER) {
    return AccountRole.TEACHER;
  }
  if (account === DemoAccount.ADMIN) {
    return AccountRole.ADMIN;
  }
  return AccountRole.STUDENT;
}

export function accountIdForDemoAccount(account: DemoAccount): string {
  if (account === DemoAccount.STUDENT_SECONDARY) {
    return 'wangchen';
  }
  if (account === DemoAccount.TEACHER) {
    return 'liuteacher';
  }
  if (account === DemoAccount.ADMIN) {
    return 'admin';
  }
  return 'liran';
}

export function defaultDisplayNameForDemoAccount(account: DemoAccount): string {
  if (account === DemoAccount.STUDENT_SECONDARY) {
    return '王晨';
  }
  if (account === DemoAccount.TEACHER) {
    return '刘老师';
  }
  if (account === DemoAccount.ADMIN) {
    return '平台管理员';
  }
  return '李然';
}

export function isRecruitmentCreator(account: DemoAccount, post: RecruitmentPost): boolean {
  return accountIdForDemoAccount(account) === post.createdBy;
}

export function canPublishRecruitment(role: AccountRole, kind: RecruitmentKind): boolean {
  return (role === AccountRole.STUDENT && kind === RecruitmentKind.COMPETITION) ||
    (role === AccountRole.TEACHER && kind === RecruitmentKind.ACTIVITY);
}

export function canApplyForRecruitment(role: AccountRole): boolean {
  return role === AccountRole.STUDENT;
}

export function canConfirmTeam(approvedMemberCount: number): boolean {
  return approvedMemberCount >= 1;
}

export function canConfirmTeamFormation(
  isTeamLeader: boolean,
  teamPostId: string,
  applicationPostId: string,
  applicationState: ApplicationState
): boolean {
  return isTeamLeader && teamPostId.length > 0 && teamPostId === applicationPostId &&
    applicationState === ApplicationState.APPROVED;
}

export function canCreateProject(teamConfirmed: boolean): boolean {
  return teamConfirmed;
}

export function canPublishTaskPlan(ownerConfirmed: boolean): boolean {
  return ownerConfirmed;
}

export function workflowProgress(step: WorkflowStep): number {
  const lastStep: number = WorkflowStep.BOARD;
  return Math.round((step + 1) * 100 / (lastStep + 1));
}

export function confidenceLabel(confidence: number): string {
  if (confidence >= 0.9) {
    return '高置信';
  }
  if (confidence >= 0.7) {
    return '待核对';
  }
  return '低置信';
}
