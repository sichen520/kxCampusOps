import { RECRUITMENT_POSTS } from '../../../data/MockCampusData';
import {
  AccountRole,
  ApplicationState,
  DemoAccount,
  RecruitmentKind,
  RecruitmentPost
} from '../../../domain/WorkflowModels';
import {
  accountIdForDemoAccount,
  isRecruitmentCreator,
  roleForDemoAccount
} from '../../../domain/WorkflowRules';
import {
  discoverRecruitments,
  isRecruitmentExpired,
  RecruitmentScope
} from '../../home/domain/RecruitmentDiscovery';
import { RecruitmentCard } from '../../home/components/RecruitmentCard';
import { RecruitmentDetail } from '../../home/components/RecruitmentDetail';
import {
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  PAGE_MAX_WIDTH
} from '../../../shared/Theme';

@Component
export struct CompetitionFeed {
  @Prop query: string = '';
  @Prop isLoggedIn: boolean = false;
  @Prop isWide: boolean = false;
  @Prop demoAccount: DemoAccount = DemoAccount.STUDENT_APPLICANT;
  @Prop extraPosts: RecruitmentPost[] = [];
  @Prop applicationPostId: string = '';
  @Prop applicationState: ApplicationState = ApplicationState.NONE;
  @Prop applicationApplicantId: string = '';
  @Prop applicationApplicantName: string = '';
  @Prop applicationApplicantEvidence: string = '';
  @Prop acceptedAdvisorPostIds: string[] = [];
  @State selectedPostId: string = '';
  @State activeFilter: string = '全部';
  @State activeScope: RecruitmentScope = RecruitmentScope.ALL;
  onRequireLogin: () => void = () => {};
  onStartWorkflow: (title: string) => void = (_title: string) => {};
  onSubmitApplication: (postId: string) => void = (_postId: string) => {};
  onApproveApplication: () => void = () => {};

  private matchesFilter(post: RecruitmentPost): boolean {
    if (this.activeFilter === '全部') {
      return true;
    }
    if (this.activeFilter === '设计与产品') {
      return post.requiredRole.includes('产品') || post.requiredRole.includes('设计') || post.requiredRole.includes('交互');
    }
    if (this.activeFilter === '开发与测试') {
      return post.requiredRole.includes('测试') || post.requiredRole.includes('可视化') || post.summary.includes('开发');
    }
    return post.requiredRole.includes('研究') || post.requiredRole.includes('答辩') || post.summary.includes('路演');
  }

  private allPosts(): RecruitmentPost[] {
    return RECRUITMENT_POSTS.concat(this.extraPosts);
  }

  private relatedPostIds(): string[] {
    let result: string[] = this.acceptedAdvisorPostIds.slice();
    if (this.applicationPostId.length > 0 && this.isCurrentApplicant()) {
      result = result.concat([this.applicationPostId]);
    }
    return result;
  }

  private effectiveScope(): RecruitmentScope {
    return !this.isLoggedIn && this.activeScope === RecruitmentScope.RELATED ?
      RecruitmentScope.ALL : this.activeScope;
  }

  private posts(): RecruitmentPost[] {
    return discoverRecruitments(
      this.allPosts(),
      RecruitmentKind.COMPETITION,
      this.query,
      this.effectiveScope(),
      accountIdForDemoAccount(this.demoAccount),
      this.relatedPostIds(),
      Date.now()
    ).filter((post: RecruitmentPost) => this.matchesFilter(post));
  }

  private applicationMatches(postId: string): boolean {
    return this.applicationPostId === postId && this.applicationState !== ApplicationState.NONE;
  }

  private isCreatorOf(postId: string): boolean {
    if (roleForDemoAccount(this.demoAccount) !== AccountRole.STUDENT) {
      return false;
    }
    return this.allPosts().filter((post: RecruitmentPost) =>
      post.id === postId && isRecruitmentCreator(this.demoAccount, post)).length > 0;
  }

  private isCurrentApplicant(): boolean {
    return this.applicationApplicantId === accountIdForDemoAccount(this.demoAccount);
  }

  private isAcceptedAdvisorOf(postId: string): boolean {
    if (roleForDemoAccount(this.demoAccount) !== AccountRole.TEACHER ||
      this.acceptedAdvisorPostIds.indexOf(postId) < 0) {
      return false;
    }
    return this.allPosts().filter((post: RecruitmentPost) => post.id === postId &&
      post.advisorId === accountIdForDemoAccount(this.demoAccount)).length > 0;
  }

  private isExpired(postId: string): boolean {
    const matched: RecruitmentPost[] = this.allPosts().filter((post: RecruitmentPost) => post.id === postId);
    return matched.length > 0 && isRecruitmentExpired(matched[0].deadline, Date.now());
  }

  private canManagePost(postId: string): boolean {
    return this.isCreatorOf(postId) || this.isAcceptedAdvisorOf(postId);
  }

  private actionLabel(postId: string): string {
    if (this.isExpired(postId) && !this.applicationMatches(postId)) {
      return '申请已截止';
    }
    if (!this.isLoggedIn) {
      return '申请加入';
    }
    if (this.canManagePost(postId)) {
      if (this.applicationMatches(postId) && this.applicationState === ApplicationState.PENDING) {
        return '审核申请';
      }
      if (this.applicationMatches(postId) && this.applicationState === ApplicationState.APPROVED) {
        return '已批准';
      }
      if (this.applicationMatches(postId) && this.applicationState === ApplicationState.REJECTED) {
        return '已拒绝';
      }
      return '本队申请';
    }
    if (roleForDemoAccount(this.demoAccount) === AccountRole.STUDENT) {
      if (this.applicationMatches(postId) && this.isCurrentApplicant() &&
        this.applicationState === ApplicationState.PENDING) {
        return '待队长审批';
      }
      if (this.applicationMatches(postId) && this.isCurrentApplicant() &&
        this.applicationState === ApplicationState.APPROVED) {
        return '已加入队伍';
      }
      if (this.applicationMatches(postId) && this.isCurrentApplicant() &&
        this.applicationState === ApplicationState.REJECTED) {
        return '重新申请';
      }
      return '申请加入';
    }
    return '仅学生参与';
  }

  private actionDisabled(postId: string): boolean {
    if (this.isExpired(postId) && !this.applicationMatches(postId)) {
      return true;
    }
    if (!this.isLoggedIn) {
      return false;
    }
    if (this.canManagePost(postId)) {
      return !this.applicationMatches(postId) || this.applicationState !== ApplicationState.PENDING;
    }
    if (roleForDemoAccount(this.demoAccount) === AccountRole.STUDENT) {
      return this.applicationMatches(postId) && this.isCurrentApplicant() &&
        this.applicationState !== ApplicationState.REJECTED;
    }
    return true;
  }

  private feedbackText(postId: string): string {
    if (!this.applicationMatches(postId) || (!this.canManagePost(postId) && !this.isCurrentApplicant())) {
      return '';
    }
    if (this.canManagePost(postId)) {
      if (this.applicationState === ApplicationState.PENDING) {
        return `${this.applicationApplicantName}申请加入队伍；${this.applicationApplicantEvidence}。队长或已确认指导老师可以审批。`;
      }
      return this.applicationState === ApplicationState.APPROVED ?
        `已批准${this.applicationApplicantName}加入队伍。申请人再次登录后会看到“已加入队伍”。` :
        `已拒绝${this.applicationApplicantName}的申请，申请人可以完善资料后重新提交。`;
    }
    if (this.applicationState === ApplicationState.PENDING) {
      return '申请已经提交给队伍创建者，当前为待审批状态。切换到对应创建者账号可以继续演示审批。';
    }
    return this.applicationState === ApplicationState.APPROVED ?
      '队伍创建者已批准申请，你已经成为该队伍成员，可以在“队伍”中查看成员关系。' :
      '本次申请未通过，你可以补充能力信息后重新申请。';
  }

  private handleAction(post: RecruitmentPost): void {
    if (!this.isLoggedIn) {
      this.onRequireLogin();
      return;
    }
    if (this.canManagePost(post.id) &&
      this.applicationMatches(post.id) && this.applicationState === ApplicationState.PENDING) {
      this.onApproveApplication();
      this.selectedPostId = post.id;
    } else if (roleForDemoAccount(this.demoAccount) === AccountRole.STUDENT && !this.canManagePost(post.id) &&
      !this.isExpired(post.id)) {
      this.onSubmitApplication(post.id);
      this.selectedPostId = post.id;
    }
  }

  @Builder
  ScopeBar() {
    Row({ space: 8 }) {
      ForEach(this.isLoggedIn ?
        [RecruitmentScope.ALL, RecruitmentScope.APPROACHING, RecruitmentScope.RELATED] :
        [RecruitmentScope.ALL, RecruitmentScope.APPROACHING], (scope: RecruitmentScope) => {
        Button(scope)
          .height(32)
          .fontSize(12)
          .fontWeight(this.effectiveScope() === scope ? FontWeight.Bold : FontWeight.Medium)
          .fontColor(this.effectiveScope() === scope ? '#FFFFFF' : COLOR_PRIMARY)
          .backgroundColor(this.effectiveScope() === scope ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
          .borderRadius(6)
          .animation({ duration: 180, curve: Curve.EaseOut })
          .onClick(() => {
            this.getUIContext().animateTo({ duration: 180, curve: Curve.EaseOut }, () => {
              this.activeScope = scope;
            });
          })
      }, (scope: RecruitmentScope) => scope)
    }
    .width('100%')
  }

  @Builder
  FilterBar() {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
      ForEach(['全部', '设计与产品', '开发与测试', '研究与路演'], (filter: string) => {
        Button(filter)
          .height(34)
          .fontSize(12)
          .fontColor(this.activeFilter === filter ? COLOR_PRIMARY : COLOR_MUTED)
          .backgroundColor(this.activeFilter === filter ? COLOR_PRIMARY_SOFT : COLOR_SURFACE)
          .border({ width: 1, color: this.activeFilter === filter ? COLOR_PRIMARY : COLOR_BORDER })
          .borderRadius(6)
          .margin({ right: 8, bottom: 8 })
          .animation({ duration: 160, curve: Curve.EaseOut })
          .onClick(() => {
            this.getUIContext().animateTo({ duration: 160, curve: Curve.EaseOut }, () => {
              this.activeFilter = filter;
            });
          })
      }, (filter: string) => filter)
    }
    .width('100%')
  }

  @Builder
  List() {
    if (this.posts().length === 0) {
      Text('没有匹配的比赛组队信息')
        .width('100%').padding(28).textAlign(TextAlign.Center).fontSize(14).fontColor(COLOR_MUTED)
    } else {
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.posts(), (post: RecruitmentPost) => {
          RecruitmentCard({
            post: post,
            isWide: this.isWide,
            actionLabel: this.actionLabel(post.id),
            actionDisabled: this.actionDisabled(post.id),
            onOpen: () => {
              this.selectedPostId = post.id;
            },
            onAction: () => {
              this.handleAction(post);
            }
          })
        }, (post: RecruitmentPost) => post.id)
      }
      .width('100%')
    }
  }

  @Builder
  Detail() {
    ForEach(this.posts(), (post: RecruitmentPost) => {
      if (post.id === this.selectedPostId) {
        RecruitmentDetail({
          post: post,
          isWide: this.isWide,
          actionLabel: this.actionLabel(post.id),
          actionDisabled: this.actionDisabled(post.id),
          feedbackLabel: this.canManagePost(post.id) ? '队伍管理审核' : '申请状态',
          feedbackText: this.feedbackText(post.id),
          showSecondaryAction: true,
          secondaryLabel: '用“可行”评估这个比赛',
          onBack: () => {
            this.selectedPostId = '';
          },
          onAction: () => {
            this.handleAction(post);
          },
          onSecondaryAction: () => {
            this.onStartWorkflow(post.title);
          }
        })
      }
    }, (post: RecruitmentPost) => post.id)
  }

  build() {
    Column({ space: 12 }) {
      if (this.selectedPostId.length > 0) {
        this.Detail()
      } else {
        Row() {
          Text('比赛组队').fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_PRIMARY)
          Blank()
          Text(`${this.posts().length} 条`).fontSize(12).fontColor(COLOR_MUTED)
        }
        .width('100%')
        this.ScopeBar()
        this.FilterBar()
        this.List()
      }
    }
    .width('100%')
    .constraintSize({ maxWidth: PAGE_MAX_WIDTH })
    .padding({ left: 0, right: 0 })
  }
}
