import { mediaquery } from '@kit.ArkUI';
import { DEFAULT_USER_PROFILES, defaultProfileForDemoAccount } from '../data/DemoProfiles';
import { RECRUITMENT_POSTS } from '../data/MockCampusData';
import {
  AccountRole,
  ApplicationState,
  DemoAccount,
  DiscussionPost,
  KnowledgeResource,
  RecruitmentKind,
  RecruitmentPost,
  UserProfile,
  WorkflowStep
} from '../domain/WorkflowModels';
import {
  accountIdForDemoAccount,
  approveApplicationState,
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

PersistentStorage.persistProp<RecruitmentPost[]>('kxCampusOps.recruitments', []);
PersistentStorage.persistProp<KnowledgeResource[]>('kxCampusOps.resources', []);
PersistentStorage.persistProp<DiscussionPost[]>('kxCampusOps.discussions', []);
PersistentStorage.persistProp<UserProfile[]>('kxCampusOps.profiles', DEFAULT_USER_PROFILES);
PersistentStorage.persistProp<string>('kxCampusOps.competitionApplicationPostId', '');
PersistentStorage.persistProp<string>('kxCampusOps.competitionApplicationState', ApplicationState.NONE);
PersistentStorage.persistProp<string>('kxCampusOps.competitionApplicantId', '');
PersistentStorage.persistProp<string>('kxCampusOps.competitionApplicantName', '');
PersistentStorage.persistProp<string>('kxCampusOps.competitionApplicantEvidence', '');
PersistentStorage.persistProp<string>('kxCampusOps.activityApplicationPostId', '');
PersistentStorage.persistProp<string>('kxCampusOps.activityApplicationState', ApplicationState.NONE);
PersistentStorage.persistProp<string>('kxCampusOps.activityApplicantId', '');
PersistentStorage.persistProp<string>('kxCampusOps.activityApplicantName', '');
PersistentStorage.persistProp<string[]>('kxCampusOps.acceptedAdvisorPostIds', []);
PersistentStorage.persistProp<boolean>('kxCampusOps.projectTaskPlanConfirmed.v2', false);
PersistentStorage.persistProp<boolean>('kxCampusOps.projectFirstTaskStarted.v2', false);
PersistentStorage.persistProp<string>('kxCampusOps.projectTeamPostId.v2', '');
PersistentStorage.persistProp<string>('kxCampusOps.workflowOwnerAccountId', '');

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
  @State workflowTaskPlanConfirmed: boolean = false;
  @State workflowFirstTaskStarted: boolean = false;
  @StorageLink('kxCampusOps.projectTaskPlanConfirmed.v2') projectTaskPlanConfirmed: boolean = false;
  @StorageLink('kxCampusOps.projectFirstTaskStarted.v2') projectFirstTaskStarted: boolean = false;
  @StorageLink('kxCampusOps.projectTeamPostId.v2') projectTeamPostId: string = '';
  @StorageLink('kxCampusOps.workflowOwnerAccountId') workflowOwnerAccountId: string = '';
  @State isWide: boolean = false;
  @State isLoggedIn: boolean = false;
  @State accountRole: AccountRole = AccountRole.STUDENT;
  @State demoAccount: DemoAccount = DemoAccount.STUDENT_APPLICANT;
  @StorageLink('kxCampusOps.recruitments') publishedRecruitments: RecruitmentPost[] = [];
  @StorageLink('kxCampusOps.resources') publishedResources: KnowledgeResource[] = [];
  @StorageLink('kxCampusOps.discussions') publishedDiscussions: DiscussionPost[] = [];
  @StorageLink('kxCampusOps.profiles') userProfiles: UserProfile[] = DEFAULT_USER_PROFILES;
  @StorageLink('kxCampusOps.competitionApplicationPostId') competitionApplicationPostId: string = '';
  @StorageLink('kxCampusOps.competitionApplicationState') competitionApplicationStateValue: string = ApplicationState.NONE;
  @StorageLink('kxCampusOps.competitionApplicantId') competitionApplicationApplicantId: string = '';
  @StorageLink('kxCampusOps.competitionApplicantName') competitionApplicationApplicantName: string = '';
  @StorageLink('kxCampusOps.competitionApplicantEvidence') competitionApplicationApplicantEvidence: string = '';
  @StorageLink('kxCampusOps.activityApplicationPostId') activityApplicationPostId: string = '';
  @StorageLink('kxCampusOps.activityApplicationState') activityApplicationStateValue: string = ApplicationState.NONE;
  @StorageLink('kxCampusOps.activityApplicantId') activityApplicationApplicantId: string = '';
  @StorageLink('kxCampusOps.activityApplicantName') activityApplicationApplicantName: string = '';
  @StorageLink('kxCampusOps.acceptedAdvisorPostIds') acceptedAdvisorPostIds: string[] = [];
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
    return RECRUITMENT_POSTS.concat(this.publishedRecruitments);
  }

  private currentTeamPost(): RecruitmentPost | undefined {
    const accountId: string = accountIdForDemoAccount(this.demoAccount);
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
    if (this.competitionApplicationState() === ApplicationState.APPROVED &&
      this.competitionApplicationApplicantId === accountId) {
      return this.allRecruitmentPosts().find((post: RecruitmentPost) =>
        post.id === this.competitionApplicationPostId);
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

  private currentTeamConfirmed(): boolean {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    return post !== undefined && post.id === this.competitionApplicationPostId &&
      this.competitionApplicationState() === ApplicationState.APPROVED;
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
    return this.currentCanManageTeam() || (this.workflowTeamConfirmed &&
      this.workflowOwnerAccountId === accountIdForDemoAccount(this.demoAccount));
  }

  private currentProjectExists(): boolean {
    const post: RecruitmentPost | undefined = this.currentTeamPost();
    return post !== undefined && this.projectTaskPlanConfirmed && this.projectTeamPostId === post.id;
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
    this.projectTaskPlanConfirmed = false;
    this.projectFirstTaskStarted = false;
    this.projectTeamPostId = '';
    AppStorage.setOrCreate<boolean>('kxCampusOps.notifications.deadline', true);
    AppStorage.setOrCreate<boolean>('kxCampusOps.notifications.application', true);
    AppStorage.setOrCreate<boolean>('kxCampusOps.notifications.task', true);
    AppStorage.setOrCreate<boolean>('kxCampusOps.notifications.activity', true);
    AppStorage.setOrCreate<boolean>('kxCampusOps.privacy.evidence', true);
    AppStorage.setOrCreate<boolean>('kxCampusOps.privacy.contact', false);
    AppStorage.setOrCreate<boolean>('kxCampusOps.privacy.aiData', false);
    AppStorage.setOrCreate<boolean>('kxCampusOps.privacy.publicProfile', true);
    AppStorage.setOrCreate<boolean>('kxCampusOps.devices.phoneActive', true);
    AppStorage.setOrCreate<string>('kxCampusOps.feedback.lastReceipt', '');
    AppStorage.setOrCreate<string>('kxCampusOps.admin.resourceAuditStatus', '待审核');
    AppStorage.setOrCreate<string>('kxCampusOps.admin.reportStatus', '待处理');
    AppStorage.setOrCreate<string>('kxCampusOps.admin.identityStatus', '待认证');
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
        this.selectedTab = this.pendingTab;
      }
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
    this.workflowTaskPlanConfirmed = false;
    this.workflowFirstTaskStarted = false;
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
    this.workflowTaskPlanConfirmed = false;
    this.workflowFirstTaskStarted = false;
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
      taskPlanConfirmed: $workflowTaskPlanConfirmed,
      firstTaskStarted: $workflowFirstTaskStarted,
      isWide: this.isWide,
      canManageProject: this.currentCanManageProject(),
      managerName: this.currentProfile().displayName,
      leaderName: this.currentTeamOwnerName().length > 0 ? this.currentTeamOwnerName() : this.currentProfile().displayName,
      memberName: this.competitionApplicationApplicantName,
      advisorName: this.currentAdvisorAccepted() ? this.currentAdvisorName() : '',
      accountRole: this.accountRole,
      demoAccount: this.demoAccount,
      onTeamRecruitmentCreated: (post: RecruitmentPost) => {
        this.publishRecruitment(post);
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
    if (this.currentTeamExists() && !this.currentProjectExists()) {
      ProjectPlanPage({
        selectedTab: $selectedTab,
        workflowStep: $workflowStep,
        taskPlanConfirmed: $projectTaskPlanConfirmed,
        opportunityTitle: this.currentTeamTitle(),
        isWide: this.isWide,
        canManageProject: this.currentCanManageProject(),
        managerName: this.currentProfile().displayName,
        leaderName: this.currentTeamOwnerName(),
        memberName: this.competitionApplicationApplicantName,
        advisorName: this.currentAdvisorAccepted() ? this.currentAdvisorName() : '',
        onPlanConfirmed: () => {
          const post: RecruitmentPost | undefined = this.currentTeamPost();
          if (post !== undefined) {
            this.projectTeamPostId = post.id;
          }
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
    } else {
      this.AdminContent()
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
