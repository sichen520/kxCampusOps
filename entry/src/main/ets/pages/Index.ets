import { mediaquery } from '@kit.ArkUI';
import { DEFAULT_USER_PROFILES, defaultProfileForDemoAccount } from '../data/DemoProfiles';
import { RECRUITMENT_POSTS } from '../data/MockCampusData';
import {
  AccountRole,
  ApplicationState,
  DemoAccount,
  DiscussionPost,
  KnowledgeResource,
  ProjectTask,
  RecruitmentKind,
  RecruitmentPost,
  UserProfile,
  WorkflowStep
} from '../domain/WorkflowModels';
import {
  accountIdForDemoAccount,
  approveApplicationState,
  canConfirmTeamFormation,
  rejectApplicationState,
  roleForDemoAccount,
  submitApplicationState
} from '../domain/WorkflowRules';
import { AdminConsolePage } from '../features/admin/pages/AdminConsolePage';
import { LoginPage } from '../features/auth/pages/LoginPage';
import { HomePage } from '../features/home/pages/HomePage';
import { KnowledgePage } from '../features/knowledge/pages/KnowledgePage';
import { ProfilePage } from '../features/profile/pages/ProfilePage';
import { ProjectBoardPage } from '../features/project/pages/ProjectBoardPage';
import { ProjectPlanPage } from '../features/project/pages/ProjectPlanPage';
import { MyTeamPage } from '../features/team/pages/MyTeamPage';
import { WorkflowPage } from '../features/workflow/pages/WorkflowPage';
import { DesktopSidebar } from '../shared/components/DesktopSidebar';
import { MobileHeader } from '../shared/components/MobileHeader';
import { WorkspaceHeader } from '../shared/components/WorkspaceHeader';
import { COLOR_BACKGROUND, COLOR_MUTED, COLOR_PRIMARY, COLOR_SURFACE } from '../shared/Theme';

PersistentStorage.persistProp<RecruitmentPost[]>('xiaoHuiTong.recruitments', []);
PersistentStorage.persistProp<KnowledgeResource[]>('xiaoHuiTong.resources', []);
PersistentStorage.persistProp<DiscussionPost[]>('xiaoHuiTong.discussions', []);
PersistentStorage.persistProp<UserProfile[]>('xiaoHuiTong.profiles', DEFAULT_USER_PROFILES);
PersistentStorage.persistProp<string>('xiaoHuiTong.competitionApplicationPostId', '');
PersistentStorage.persistProp<string>('xiaoHuiTong.competitionApplicationState', ApplicationState.NONE);
PersistentStorage.persistProp<string>('xiaoHuiTong.competitionApplicantId', '');
PersistentStorage.persistProp<string>('xiaoHuiTong.competitionApplicantName', '');
PersistentStorage.persistProp<string>('xiaoHuiTong.competitionApplicantEvidence', '');
PersistentStorage.persistProp<string>('xiaoHuiTong.activityApplicationPostId', '');
PersistentStorage.persistProp<string>('xiaoHuiTong.activityApplicationState', ApplicationState.NONE);
PersistentStorage.persistProp<string>('xiaoHuiTong.activityApplicantId', '');
PersistentStorage.persistProp<string>('xiaoHuiTong.activityApplicantName', '');
PersistentStorage.persistProp<string[]>('xiaoHuiTong.acceptedAdvisorPostIds', []);
PersistentStorage.persistProp<string[]>('xiaoHuiTong.confirmedTeamPostIds.v3', []);
PersistentStorage.persistProp<boolean>('xiaoHuiTong.projectTaskPlanConfirmed.v3', false);
PersistentStorage.persistProp<boolean>('xiaoHuiTong.projectFirstTaskStarted.v3', false);
PersistentStorage.persistProp<string>('xiaoHuiTong.projectTeamPostId.v3', '');
PersistentStorage.persistProp<ProjectTask[]>('xiaoHuiTong.projectTasks.v3', []);
PersistentStorage.persistProp<string>('xiaoHuiTong.workflowOwnerAccountId', '');

@Entry
@Component
struct Index {
  @State selectedTab: number = 0;
  @State workflowStep: WorkflowStep = WorkflowStep.IMPORT;
  @State workflowOpportunityTitle: string = '2026 中国高校计算机大赛 · 鸿蒙高校创新赛';
  @State sourceSelected: boolean = false;
  @State personalPlanCreated: boolean = false;
  @State candidateApproved: boolean = false;
  @State workflowTeamConfirmed: boolean = false;
  @StorageLink('xiaoHuiTong.projectTaskPlanConfirmed.v3') projectTaskPlanConfirmed: boolean = false;
  @StorageLink('xiaoHuiTong.projectFirstTaskStarted.v3') projectFirstTaskStarted: boolean = false;
  @StorageLink('xiaoHuiTong.projectTeamPostId.v3') projectTeamPostId: string = '';
  @StorageLink('xiaoHuiTong.workflowOwnerAccountId') workflowOwnerAccountId: string = '';
  @State isWide: boolean = false;
  @State isLoggedIn: boolean = false;
  @State accountRole: AccountRole = AccountRole.STUDENT;
  @State demoAccount: DemoAccount = DemoAccount.STUDENT_APPLICANT;
  @StorageLink('xiaoHuiTong.recruitments') publishedRecruitments: RecruitmentPost[] = [];
  @StorageLink('xiaoHuiTong.resources') publishedResources: KnowledgeResource[] = [];
  @StorageLink('xiaoHuiTong.discussions') publishedDiscussions: DiscussionPost[] = [];
  @StorageLink('xiaoHuiTong.profiles') userProfiles: UserProfile[] = DEFAULT_USER_PROFILES;
  @StorageLink('xiaoHuiTong.competitionApplicationPostId') competitionApplicationPostId: string = '';
  @StorageLink('xiaoHuiTong.competitionApplicationState') competitionApplicationStateValue: string = ApplicationState.NONE;
  @StorageLink('xiaoHuiTong.competitionApplicantId') competitionApplicationApplicantId: string = '';
  @StorageLink('xiaoHuiTong.competitionApplicantName') competitionApplicationApplicantName: string = '';
  @StorageLink('xiaoHuiTong.competitionApplicantEvidence') competitionApplicationApplicantEvidence: string = '';
  @StorageLink('xiaoHuiTong.activityApplicationPostId') activityApplicationPostId: string = '';
  @StorageLink('xiaoHuiTong.activityApplicationState') activityApplicationStateValue: string = ApplicationState.NONE;
  @StorageLink('xiaoHuiTong.activityApplicantId') activityApplicationApplicantId: string = '';
  @StorageLink('xiaoHuiTong.activityApplicantName') activityApplicationApplicantName: string = '';
  @StorageLink('xiaoHuiTong.acceptedAdvisorPostIds') acceptedAdvisorPostIds: string[] = [];
  @StorageLink('xiaoHuiTong.confirmedTeamPostIds.v3') confirmedTeamPostIds: string[] = [];
  @StorageLink('xiaoHuiTong.projectTasks.v3') projectTasks: ProjectTask[] = [];
  @State showLogin: boolean = false;
  @State pendingTab: number = -1;
  @State pendingOpportunityTitle: string = '';

  private wideScreenQuery: mediaquery.MediaQueryListener | null = null;

  private competitionApplicationState(): ApplicationState {
    return this.competitionApplicationStateValue as ApplicationState;
  }

  private activityApplicationState(): ApplicationState {
    return this.activityApplicationStateValue as ApplicationState;
  }

  private currentProfile(): UserProfile {
    const accountId: string = accountIdForDemoAccount(this.demoAccount);
    const matched: UserProfile | undefined = this.userProfiles.find((profile: UserProfile) =>
      profile.accountId === accountId);
    return matched !== undefined ? matched : defaultProfileForDemoAccount(this.demoAccount);
  }

  private allRecruitmentPosts(): RecruitmentPost[] {
    return this.publishedRecruitments.concat(RECRUITMENT_POSTS);
  }

  private currentTeamPost(): RecruitmentPost | undefined {
    const accountId: string = accountIdForDemoAccount(this.demoAccount);
    if (this.competitionApplicationState() === ApplicationState.APPROVED &&
      this.competitionApplicationApplicantId === accountId) {
      const joined: RecruitmentPost | undefined = this.allRecruitmentPosts().find((post: RecruitmentPost) =>
        post.id === this.competitionApplicationPostId);
      if (joined !== undefined) {
        return joined;
      }
    }
    const owned: RecruitmentPost | undefined = this.allRecruitmentPosts().find((post: RecruitmentPost) =>
      post.kind === RecruitmentKind.COMPETITION && post.createdBy === accountId);
    if (owned !== undefined) {
      return owned;
    }
    if (this.accountRole === AccountRole.TEACHER) {
      const advised: RecruitmentPost | undefined = this.allRecruitmentPosts().find((post: RecruitmentPost) =>
        post.kind === RecruitmentKind.COMPETITION && post.advisorId === accountId);
      if (advised !== undefined) {
        return advised;
      }
    }
    return undefined;
  }

  private teamOwnerName(post: RecruitmentPost | undefined): string {
    if (post === undefined) {
      return '';
    }
    return post.publisher;
  }

  private currentTeamExists(): boolean {
    return this.currentTeamPost() !== undefined;
  }

  private currentTeamTitle(): string {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    return post === undefined ? '' : post.title;
  }

  private currentTeamOwnerId(): string {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    return post === undefined ? '' : post.createdBy;
  }

  private currentTeamOwnerName(): string {
    return this.teamOwnerName(this.currentTeamPost());
  }

  private currentAdvisorId(): string {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    return post === undefined || post.advisorId === undefined ? '' : post.advisorId;
  }

  private currentAdvisorName(): string {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    return post === undefined || post.advisorName === undefined ? '' : post.advisorName;
  }

  private currentTaskOwnerName(): string {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    if (post === undefined) {
      return '';
    }
    const accountId: string = accountIdForDemoAccount(this.demoAccount);
    if (post.createdBy === accountId) {
      return post.publisher;
    }
    if (post.id === this.competitionApplicationPostId &&
      this.competitionApplicationApplicantId === accountId &&
      this.competitionApplicationState() === ApplicationState.APPROVED) {
      const applicantName: string = this.competitionApplicationApplicantName;
      const advisorName: string = post.advisorName === undefined ? '' : post.advisorName;
      if (applicantName.length > 0 && applicantName !== post.publisher && applicantName !== advisorName) {
        return applicantName;
      }
      return '';
    }
    if (post.advisorId === accountId && this.currentAdvisorAccepted()) {
      return post.advisorName === undefined ? '' : post.advisorName;
    }
    return '';
  }

  private currentTeamConfirmed(): boolean {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    return post !== undefined && this.confirmedTeamPostIds.indexOf(post.id) >= 0;
  }

  private currentTeamReadyToConfirm(): boolean {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    if (post === undefined) {
      return false;
    }
    return canConfirmTeamFormation(
      post.createdBy === accountIdForDemoAccount(this.demoAccount),
      post.id,
      this.competitionApplicationPostId,
      this.competitionApplicationState()
    );
  }

  private confirmCurrentTeam(): void {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    if (post !== undefined && this.currentTeamReadyToConfirm() &&
      this.confirmedTeamPostIds.indexOf(post.id) < 0) {
      this.confirmedTeamPostIds = this.confirmedTeamPostIds.concat([post.id]);
      this.workflowTeamConfirmed = true;
      this.workflowOwnerAccountId = post.createdBy;
    }
  }

  private currentTeamApplicationState(): ApplicationState {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    if (post === undefined || post.id !== this.competitionApplicationPostId) {
      return ApplicationState.NONE;
    }
    return this.competitionApplicationState();
  }

  private currentAdvisorAccepted(): boolean {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    return post !== undefined && this.acceptedAdvisorPostIds.indexOf(post.id) >= 0;
  }

  private currentCanManageTeam(): boolean {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    if (post === undefined) {
      return false;
    }
    const accountId: string = accountIdForDemoAccount(this.demoAccount);
    return post.createdBy === accountId || (post.advisorId === accountId && this.currentAdvisorAccepted());
  }

  private currentCanManageProject(): boolean {
    return (this.currentTeamConfirmed() && this.currentCanManageTeam()) || (this.workflowTeamConfirmed &&
      this.workflowOwnerAccountId === accountIdForDemoAccount(this.demoAccount));
  }

  private currentProjectExists(): boolean {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    return post !== undefined && this.currentTeamConfirmed() && this.projectTaskPlanConfirmed &&
      this.projectTeamPostId === post.id && this.projectTasks.length > 0;
  }

  private publishCurrentProjectPlan(tasks: ProjectTask[]): void {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    if (post === undefined || !this.currentTeamConfirmed() || !this.currentCanManageTeam() || tasks.length === 0) {
      return;
    }
    this.projectTeamPostId = post.id;
    this.projectTasks = tasks.slice();
    this.projectTaskPlanConfirmed = true;
    this.projectFirstTaskStarted = false;
  }

  private acceptCurrentAdvisorInvitation(): void {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    if (post !== undefined && post.advisorId === accountIdForDemoAccount(this.demoAccount) &&
      this.acceptedAdvisorPostIds.indexOf(post.id) < 0) {
      this.acceptedAdvisorPostIds = this.acceptedAdvisorPostIds.concat([post.id]);
    }
  }

  private saveProfile(profile: UserProfile): void {
    this.userProfiles = this.userProfiles.filter((item: UserProfile) =>
      item.accountId !== profile.accountId).concat([profile]);
  }

  private publishRecruitment(post: RecruitmentPost): void {
    this.publishedRecruitments = [post].concat(this.publishedRecruitments);
  }

  private clearDemoData(): void {
    this.publishedRecruitments = [];
    this.publishedResources = [];
    this.publishedDiscussions = [];
    this.userProfiles = DEFAULT_USER_PROFILES;
    this.competitionApplicationPostId = '';
    this.competitionApplicationStateValue = ApplicationState.NONE;
    this.competitionApplicationApplicantId = '';
    this.competitionApplicationApplicantName = '';
    this.competitionApplicationApplicantEvidence = '';
    this.activityApplicationPostId = '';
    this.activityApplicationStateValue = ApplicationState.NONE;
    this.activityApplicationApplicantId = '';
    this.activityApplicationApplicantName = '';
    this.acceptedAdvisorPostIds = [];
    this.confirmedTeamPostIds = [];
    this.projectTaskPlanConfirmed = false;
    this.projectFirstTaskStarted = false;
    this.projectTeamPostId = '';
    this.projectTasks = [];
    AppStorage.setOrCreate<boolean>('xiaoHuiTong.notifications.deadline', true);
    AppStorage.setOrCreate<boolean>('xiaoHuiTong.notifications.application', true);
    AppStorage.setOrCreate<boolean>('xiaoHuiTong.notifications.task', true);
    AppStorage.setOrCreate<boolean>('xiaoHuiTong.notifications.activity', true);
    AppStorage.setOrCreate<boolean>('xiaoHuiTong.privacy.evidence', true);
    AppStorage.setOrCreate<boolean>('xiaoHuiTong.privacy.contact', false);
    AppStorage.setOrCreate<boolean>('xiaoHuiTong.privacy.aiData', false);
    AppStorage.setOrCreate<boolean>('xiaoHuiTong.privacy.publicProfile', true);
    AppStorage.setOrCreate<boolean>('xiaoHuiTong.devices.phoneActive', true);
    AppStorage.setOrCreate<string>('xiaoHuiTong.feedback.lastReceipt', '');
    AppStorage.setOrCreate<string>('xiaoHuiTong.admin.resourceAuditStatus', '待审核');
    AppStorage.setOrCreate<string>('xiaoHuiTong.admin.reportStatus', '待处理');
    AppStorage.setOrCreate<string>('xiaoHuiTong.admin.identityStatus', '待认证');
    this.resetWorkflow();
  }

  aboutToAppear(): void {
    this.wideScreenQuery = this.getUIContext().getMediaQuery().matchMediaSync('(min-width: 960vp)');
    this.isWide = this.wideScreenQuery.matches;
    this.wideScreenQuery.on('change', (result: mediaquery.MediaQueryResult) => {
      this.isWide = result.matches;
    });
  }

  aboutToDisappear(): void {
    if (this.wideScreenQuery !== null) {
      this.wideScreenQuery.off('change');
    }
  }

  private requiresLogin(index: number): boolean {
    return index === 1 || index === 3 || index === 4 || index === 5 || index === 6;
  }

  private requestLogin(targetTab: number, opportunityTitle: string = ''): void {
    this.pendingTab = targetTab;
    this.pendingOpportunityTitle = opportunityTitle;
    this.showLogin = true;
  }

  private closeLogin(): void {
    this.showLogin = false;
    if (this.isLoggedIn && this.accountRole === AccountRole.ADMIN) {
      this.selectedTab = 6;
    } else if (this.isLoggedIn && this.pendingTab >= 0) {
      if (this.pendingOpportunityTitle.length > 0) {
        this.startWorkflow(this.pendingOpportunityTitle);
      } else {
        this.selectedTab = this.pendingTab === 6 ? 0 : this.pendingTab;
      }
    } else if (this.accountRole !== AccountRole.ADMIN && this.selectedTab === 6) {
      this.selectedTab = 0;
    }
    this.pendingTab = -1;
    this.pendingOpportunityTitle = '';
  }

  private logout(): void {
    this.isLoggedIn = false;
    this.accountRole = AccountRole.STUDENT;
    this.demoAccount = DemoAccount.STUDENT_APPLICANT;
    this.selectedTab = 0;
  }

  private switchAccount(): void {
    this.isLoggedIn = false;
    this.selectedTab = 0;
    this.pendingTab = -1;
    this.pendingOpportunityTitle = '';
    this.showLogin = true;
  }

  private loginAs(account: DemoAccount): void {
    this.demoAccount = account;
    this.accountRole = roleForDemoAccount(account);
  }

  private submitCompetitionApplication(postId: string): void {
    this.competitionApplicationPostId = postId;
    this.competitionApplicationStateValue = submitApplicationState();
    this.competitionApplicationApplicantId = accountIdForDemoAccount(this.demoAccount);
    this.competitionApplicationApplicantName = this.currentProfile().displayName;
    this.competitionApplicationApplicantEvidence =
      `${this.currentProfile().major} · 可投入时间：${this.currentProfile().availability}`;
  }

  private approveCompetitionApplication(): void {
    this.competitionApplicationStateValue = approveApplicationState(this.competitionApplicationState());
  }

  private rejectCompetitionApplication(): void {
    this.competitionApplicationStateValue = rejectApplicationState(this.competitionApplicationState());
  }

  private submitActivityApplication(postId: string): void {
    this.activityApplicationPostId = postId;
    this.activityApplicationStateValue = submitApplicationState();
    this.activityApplicationApplicantId = accountIdForDemoAccount(this.demoAccount);
    this.activityApplicationApplicantName = this.currentProfile().displayName;
  }

  private approveActivityApplication(): void {
    this.activityApplicationStateValue = approveApplicationState(this.activityApplicationState());
  }

  private resetWorkflow(): void {
    this.workflowStep = WorkflowStep.IMPORT;
    this.sourceSelected = false;
    this.personalPlanCreated = false;
    this.candidateApproved = false;
    this.workflowTeamConfirmed = false;
    this.workflowOwnerAccountId = '';
    this.selectedTab = 1;
  }

  private startWorkflow(title: string): void {
    this.workflowOpportunityTitle = title.trim().length > 0 ? title : '2026 中国高校计算机大赛 · 鸿蒙高校创新赛';
    this.workflowStep = WorkflowStep.IMPORT;
    this.sourceSelected = false;
    this.personalPlanCreated = false;
    this.candidateApproved = false;
    this.workflowTeamConfirmed = false;
    this.workflowOwnerAccountId = this.accountRole === AccountRole.STUDENT ?
      accountIdForDemoAccount(this.demoAccount) : '';
    this.selectedTab = 1;
  }

  @Builder
  HomeContent() {
    HomePage({
      isLoggedIn: this.isLoggedIn,
      isWide: this.isWide,
      accountRole: this.accountRole,
      demoAccount: this.demoAccount,
      competitionApplicationPostId: this.competitionApplicationPostId,
      competitionApplicationState: this.competitionApplicationState(),
      competitionApplicationApplicantId: this.competitionApplicationApplicantId,
      competitionApplicationApplicantName: this.competitionApplicationApplicantName,
      competitionApplicationApplicantEvidence: this.competitionApplicationApplicantEvidence,
      activityApplicationPostId: this.activityApplicationPostId,
      activityApplicationState: this.activityApplicationState(),
      activityApplicationApplicantId: this.activityApplicationApplicantId,
      activityApplicationApplicantName: this.activityApplicationApplicantName,
      publishedPosts: this.publishedRecruitments,
      acceptedAdvisorPostIds: this.acceptedAdvisorPostIds,
      onRequireLogin: () => {
        this.requestLogin(-1);
      },
      onStartWorkflow: (title: string) => {
        if (this.isLoggedIn) {
          this.startWorkflow(title);
        } else {
          this.requestLogin(1, title);
        }
      },
      onSubmitCompetitionApplication: (postId: string) => {
        this.submitCompetitionApplication(postId);
      },
      onApproveCompetitionApplication: () => {
        this.approveCompetitionApplication();
      },
      onSubmitActivityApplication: (postId: string) => {
        this.submitActivityApplication(postId);
      },
      onApproveActivityApplication: () => {
        this.approveActivityApplication();
      },
      onRecruitmentPublished: (post: RecruitmentPost) => {
        this.publishRecruitment(post);
      }
    })
  }

  @Builder
  WorkflowContent() {
    WorkflowPage({
      selectedTab: $selectedTab,
      workflowStep: $workflowStep,
      opportunityTitle: this.workflowOpportunityTitle,
      sourceSelected: $sourceSelected,
      personalPlanCreated: $personalPlanCreated,
      candidateApproved: $candidateApproved,
      teamConfirmed: $workflowTeamConfirmed,
      taskPlanConfirmed: $projectTaskPlanConfirmed,
      firstTaskStarted: $projectFirstTaskStarted,
      isWide: this.isWide,
      canManageProject: this.currentCanManageProject(),
      managerName: this.currentProfile().displayName,
      leaderName: this.currentTeamOwnerName().length > 0 ? this.currentTeamOwnerName() : this.currentProfile().displayName,
      memberName: this.competitionApplicationApplicantName,
      advisorName: this.currentAdvisorAccepted() ? this.currentAdvisorName() : '',
      projectTasks: this.projectTasks,
      currentTaskOwnerName: this.currentTaskOwnerName(),
      accountRole: this.accountRole,
      demoAccount: this.demoAccount,
      onTeamRecruitmentCreated: (post: RecruitmentPost) => {
        this.publishRecruitment(post);
      },
      onPlanConfirmed: (tasks: ProjectTask[]) => {
        this.publishCurrentProjectPlan(tasks);
      }
    })
  }

  @Builder
  TeamContent() {
    MyTeamPage({
      accountRole: this.accountRole,
      demoAccount: this.demoAccount,
      teamExists: this.currentTeamExists(),
      teamConfirmed: this.currentTeamConfirmed(),
      teamReadyToConfirm: this.currentTeamReadyToConfirm(),
      isWide: this.isWide,
      teamTitle: this.currentTeamTitle(),
      opportunityTitle: this.currentTeamTitle(),
      currentAccountId: accountIdForDemoAccount(this.demoAccount),
      currentDisplayName: this.currentProfile().displayName,
      teamOwnerId: this.currentTeamOwnerId(),
      teamOwnerName: this.currentTeamOwnerName(),
      applicantId: this.competitionApplicationApplicantId,
      applicantName: this.competitionApplicationApplicantName,
      applicantEvidence: this.competitionApplicationApplicantEvidence,
      applicationState: this.currentTeamApplicationState(),
      advisorId: this.currentAdvisorId(),
      advisorName: this.currentAdvisorName(),
      advisorAccepted: this.currentAdvisorAccepted(),
      canManageTeam: this.currentCanManageTeam(),
      onCreateTeam: (post: RecruitmentPost) => {
        this.publishRecruitment(post);
      },
      onAcceptAdvisor: () => {
        this.acceptCurrentAdvisorInvitation();
      },
      onApproveApplicant: () => {
        this.approveCompetitionApplication();
      },
      onRejectApplicant: () => {
        this.rejectCompetitionApplication();
      },
      onConfirmTeam: () => {
        this.confirmCurrentTeam();
      },
      onOpenProject: () => {
        this.selectedTab = 4;
      },
      onOpenFeasibility: () => {
        this.workflowStep = WorkflowStep.FEASIBILITY;
        this.selectedTab = 1;
      },
      onOpenHome: () => {
        this.selectedTab = 0;
      }
    })
  }

  @Builder
  ProjectContent() {
    if (this.currentTeamConfirmed() && !this.currentProjectExists()) {
      ProjectPlanPage({
        selectedTab: $selectedTab,
        workflowStep: $workflowStep,
        taskPlanConfirmed: $projectTaskPlanConfirmed,
        opportunityTitle: this.currentTeamTitle(),
        isWide: this.isWide,
        canManageProject: this.currentCanManageTeam(),
        managerName: this.currentProfile().displayName,
        leaderName: this.currentTeamOwnerName(),
        memberName: this.competitionApplicationApplicantName,
        advisorName: this.currentAdvisorAccepted() ? this.currentAdvisorName() : '',
        onPlanConfirmed: (tasks: ProjectTask[]) => {
          this.publishCurrentProjectPlan(tasks);
        }
      })
    } else {
      ProjectBoardPage({
        selectedTab: $selectedTab,
        workflowStep: $workflowStep,
        taskPlanConfirmed: $projectTaskPlanConfirmed,
        firstTaskStarted: $projectFirstTaskStarted,
        opportunityTitle: this.currentTeamTitle(),
        isWide: this.isWide,
        canManageProject: this.currentCanManageProject(),
        currentTaskOwnerName: this.currentTaskOwnerName(),
        hasTeam: this.currentTeamExists(),
        teamConfirmed: this.currentTeamConfirmed(),
        tasks: this.projectTasks,
        hasProject: this.currentProjectExists()
      })
    }
  }

  @Builder
  ProfileContent() {
    ProfilePage({
      isWide: this.isWide,
      accountRole: this.accountRole,
      demoAccount: this.demoAccount,
      accountId: this.currentProfile().accountId,
      displayName: this.currentProfile().displayName,
      college: this.currentProfile().college,
      grade: this.currentProfile().grade,
      major: this.currentProfile().major,
      availability: this.currentProfile().availability,
      teamExists: this.currentTeamExists(),
      projectExists: this.currentProjectExists(),
      knowledgeContributionCount: this.publishedResources.length,
      competitionApplicationState: this.competitionApplicationState(),
      activityApplicationState: this.activityApplicationState(),
      onSaveProfile: (profile: UserProfile) => {
        this.saveProfile(profile);
      },
      onResetDemoData: () => {
        this.clearDemoData();
      },
      onOpenTeam: () => {
        this.selectedTab = 3;
      },
      onOpenProject: () => {
        this.selectedTab = 4;
      },
      onOpenHome: () => {
        this.selectedTab = 0;
      },
      onOpenAdmin: () => {
        this.selectedTab = 6;
      },
      onLogout: () => {
        this.logout();
      }
    })
  }

  @Builder
  AdminContent() {
    AdminConsolePage({ isWide: this.isWide })
  }

  @Builder
  CurrentDesktopPage() {
    if (this.selectedTab === 0) {
      this.HomeContent()
    } else if (this.selectedTab === 1) {
      this.WorkflowContent()
    } else if (this.selectedTab === 2) {
      KnowledgePage({
        isWide: true,
        isLoggedIn: this.isLoggedIn,
        extraResources: this.publishedResources,
        extraDiscussions: this.publishedDiscussions,
        onRequireLogin: () => {
          this.requestLogin(-1);
        },
        onResourcePublished: (resource: KnowledgeResource) => {
          this.publishedResources = [resource].concat(this.publishedResources);
        },
        onDiscussionPublished: (post: DiscussionPost) => {
          this.publishedDiscussions = [post].concat(this.publishedDiscussions);
        }
      })
    } else if (this.selectedTab === 3) {
      this.TeamContent()
    } else if (this.selectedTab === 4) {
      this.ProjectContent()
    } else if (this.selectedTab === 5) {
      this.ProfileContent()
    } else if (this.selectedTab === 6 && this.isLoggedIn && this.accountRole === AccountRole.ADMIN) {
      this.AdminContent()
    } else {
      this.HomeContent()
    }
  }

  @Builder
  MobileTabBarItem(label: string, index: number) {
    Column({ space: 5 }) {
      Text(label)
        .fontSize(12)
        .fontWeight(this.selectedTab === index ? FontWeight.Bold : FontWeight.Medium)
        .fontColor(this.selectedTab === index ? COLOR_PRIMARY : COLOR_MUTED)
      Column()
        .width(this.selectedTab === index ? 18 : 4)
        .height(3)
        .borderRadius(2)
        .backgroundColor(this.selectedTab === index ? COLOR_PRIMARY : '#00000000')
        .animation({ duration: 180, curve: Curve.EaseOut })
    }
    .width('100%')
    .height(58)
    .justifyContent(FlexAlign.Center)
    .animation({ duration: 180, curve: Curve.EaseOut })
  }

  @Builder
  MobileWorkspace() {
    Column() {
      MobileHeader({
        selectedTab: this.selectedTab,
        isLoggedIn: this.isLoggedIn,
        demoAccount: this.demoAccount,
        accountDisplayName: this.currentProfile().displayName,
        onReset: () => {
          this.resetWorkflow();
        },
        onLogin: () => {
          this.requestLogin(-1);
        },
        onSwitchAccount: () => {
          this.switchAccount();
        }
      })
      Tabs({ barPosition: BarPosition.End, index: this.selectedTab }) {
        TabContent() { this.HomeContent() }.tabBar(this.MobileTabBarItem('首页', 0))
        TabContent() { this.WorkflowContent() }.tabBar(this.MobileTabBarItem('可行', 1))
        TabContent() {
          KnowledgePage({
            isWide: false,
            isLoggedIn: this.isLoggedIn,
            extraResources: this.publishedResources,
            extraDiscussions: this.publishedDiscussions,
            onRequireLogin: () => {
              this.requestLogin(-1);
            },
            onResourcePublished: (resource: KnowledgeResource) => {
              this.publishedResources = [resource].concat(this.publishedResources);
            },
            onDiscussionPublished: (post: DiscussionPost) => {
              this.publishedDiscussions = [post].concat(this.publishedDiscussions);
            }
          })
        }.tabBar(this.MobileTabBarItem('知享', 2))
        TabContent() { this.TeamContent() }.tabBar(this.MobileTabBarItem('队伍', 3))
        TabContent() { this.ProjectContent() }.tabBar(this.MobileTabBarItem('执行', 4))
        TabContent() { this.ProfileContent() }.tabBar(this.MobileTabBarItem('我的', 5))
        if (this.accountRole === AccountRole.ADMIN) {
          TabContent() { this.AdminContent() }.tabBar(this.MobileTabBarItem('管理', 6))
        }
      }
      .layoutWeight(1)
      .barHeight(62)
      .barBackgroundColor(COLOR_SURFACE)
      .scrollable(false)
      .onChange((index: number) => {
        if (!this.isLoggedIn && this.requiresLogin(index)) {
          this.selectedTab = 0;
          this.requestLogin(index);
        } else {
          this.selectedTab = index;
        }
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  DesktopWorkspace() {
    Row() {
      DesktopSidebar({
        selectedTab: $selectedTab,
        isLoggedIn: this.isLoggedIn,
        accountRole: this.accountRole,
        demoAccount: this.demoAccount,
        accountDisplayName: this.currentProfile().displayName,
        onRequireLogin: (index: number) => {
          this.requestLogin(index);
        }
      })
      Column() {
        WorkspaceHeader({
          selectedTab: this.selectedTab,
          isLoggedIn: this.isLoggedIn,
          accountRole: this.accountRole,
          demoAccount: this.demoAccount,
          accountDisplayName: this.currentProfile().displayName,
          onReset: () => {
            this.resetWorkflow();
          },
          onLogin: () => {
            this.requestLogin(-1);
          },
          onSwitchAccount: () => {
            this.switchAccount();
          }
        })
        this.CurrentDesktopPage()
      }
      .layoutWeight(1)
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }

  build() {
    Column() {
      if (this.showLogin) {
        LoginPage({
          isLoggedIn: $isLoggedIn,
          isWide: this.isWide,
          onClose: () => {
            this.closeLogin();
          },
          onLogin: (account: DemoAccount) => {
            this.loginAs(account);
          }
        })
      } else if (this.isWide) {
        this.DesktopWorkspace()
      } else {
        this.MobileWorkspace()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLOR_BACKGROUND)
  }
}
