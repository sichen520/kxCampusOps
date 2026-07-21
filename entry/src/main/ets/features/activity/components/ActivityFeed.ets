import { RECRUITMENT_POSTS } from '../../../data/MockCampusData';
import {
  AccountRole,
  ApplicationState,
  DemoAccount,
  RecruitmentKind,
  RecruitmentPost
} from '../../../domain/WorkflowModels';
import { accountIdForDemoAccount, roleForDemoAccount } from '../../../domain/WorkflowRules';
import {
  discoverRecruitments,
  isRecruitmentExpired,
  RecruitmentScope
} from '../../home/domain/RecruitmentDiscovery';
import { RecruitmentCard } from '../../home/components/RecruitmentCard';
import { RecruitmentDetail } from '../../home/components/RecruitmentDetail';
import {
  COLOR_BLUE,
  COLOR_BLUE_SOFT,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_SURFACE,
  PAGE_MAX_WIDTH
} from '../../../shared/Theme';

@Component
export struct ActivityFeed {
  @Prop query: string = '';
  @Prop isLoggedIn: boolean = false;
  @Prop isWide: boolean = false;
  @Prop demoAccount: DemoAccount = DemoAccount.STUDENT_APPLICANT;
  @Prop extraPosts: RecruitmentPost[] = [];
  @Prop applicationPostId: string = '';
  @Prop applicationState: ApplicationState = ApplicationState.NONE;
  @Prop applicationApplicantId: string = '';
  @Prop applicationApplicantName: string = '';
  @State selectedPostId: string = '';
  @State activeFilter: string = '全部';
  @State activeScope: RecruitmentScope = RecruitmentScope.ALL;
  onRequireLogin: () => void = () => {};
  onSubmitApplication: (postId: string) => void = (_postId: string) => {};
  onApproveApplication: () => void = () => {};

  private matchesFilter(post: RecruitmentPost): boolean {
    if (this.activeFilter === '全部') {
      return true;
    }
    if (this.activeFilter === '技术活动') {
      return post.title.includes('开发') || post.requiredRole.includes('技术');
    }
    if (this.activeFilter === '志愿服务') {
      return post.tags.indexOf('志愿服务') >= 0 || post.requiredRole.includes('签到');
    }
    return post.requiredRole.includes('协调') || post.requiredRole.includes('引导');
  }

  private allPosts(): RecruitmentPost[] {
    return RECRUITMENT_POSTS.concat(this.extraPosts);
  }

  private relatedPostIds(): string[] {
    if (this.applicationPostId.length > 0 && this.isCurrentApplicant()) {
      return [this.applicationPostId];
    }
    return [];
  }

  private effectiveScope(): RecruitmentScope {
    return !this.isLoggedIn && this.activeScope === RecruitmentScope.RELATED ?
      RecruitmentScope.ALL : this.activeScope;
  }

  private posts(): RecruitmentPost[] {
    return discoverRecruitments(
      this.allPosts(),
      RecruitmentKind.ACTIVITY,
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

  private isCurrentApplicant(): boolean {
    return this.applicationApplicantId === accountIdForDemoAccount(this.demoAccount);
  }

  private isResponsibleTeacher(postId: string): boolean {
    if (this.demoAccount !== DemoAccount.TEACHER) {
      return false;
    }
    return this.allPosts().filter((post: RecruitmentPost) =>
      post.id === postId && post.createdBy === accountIdForDemoAccount(this.demoAccount)).length > 0;
  }

  private isExpired(postId: string): boolean {
    const matched: RecruitmentPost[] = this.allPosts().filter((post: RecruitmentPost) => post.id === postId);
    return matched.length > 0 && isRecruitmentExpired(matched[0].deadline, Date.now());
  }

  private isStudentAccount(): boolean {
    return roleForDemoAccount(this.demoAccount) === AccountRole.STUDENT;
  }

  private actionLabel(postId: string): string {
    if (this.isExpired(postId) && !this.applicationMatches(postId)) {
      return '报名已截止';
    }
    if (!this.isLoggedIn) {
      return '报名岗位';
    }
    if (this.isStudentAccount()) {
      if (this.applicationMatches(postId) && this.isCurrentApplicant() && this.applicationState === ApplicationState.PENDING) {
        return '待老师审批';
      }
      if (this.applicationMatches(postId) && this.isCurrentApplicant() && this.applicationState === ApplicationState.APPROVED) {
        return '报名已通过';
      }
      return '报名岗位';
    }
    if (this.demoAccount === DemoAccount.TEACHER && this.isResponsibleTeacher(postId)) {
      if (this.applicationMatches(postId) && this.applicationState === ApplicationState.PENDING) {
        return '审核报名';
      }
      if (this.applicationMatches(postId) && this.applicationState === ApplicationState.APPROVED) {
        return '已批准';
      }
      return '本活动报名';
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
    if (this.isStudentAccount()) {
      return this.applicationMatches(postId) && this.isCurrentApplicant();
    }
    if (this.demoAccount === DemoAccount.TEACHER && this.isResponsibleTeacher(postId)) {
      return !this.applicationMatches(postId) || this.applicationState !== ApplicationState.PENDING;
    }
    return true;
  }

  private feedbackText(postId: string): string {
    if (!this.applicationMatches(postId) || (!this.isResponsibleTeacher(postId) && !this.isCurrentApplicant())) {
      return '';
    }
    if (this.demoAccount === DemoAccount.TEACHER && this.isResponsibleTeacher(postId)) {
      return this.applicationState === ApplicationState.PENDING ?
        `${this.applicationApplicantName}报名现场协助岗位，可投入活动完整时段。老师确认后学生才会进入活动执行名单。` :
        `已批准${this.applicationApplicantName}参加活动，学生账号会收到报名通过状态。`;
    }
    return this.applicationState === ApplicationState.PENDING ?
      '报名已提交给负责老师。切换到“刘老师 · 指导老师”账号可以继续演示审批。' :
      '负责老师已批准报名，你已进入活动名单。';
  }

  private handleAction(post: RecruitmentPost): void {
    if (!this.isLoggedIn) {
      this.onRequireLogin();
      return;
    }
    if (this.isStudentAccount() && !this.isExpired(post.id)) {
      this.onSubmitApplication(post.id);
      this.selectedPostId = post.id;
    } else if (this.demoAccount === DemoAccount.TEACHER && this.isResponsibleTeacher(post.id) &&
      this.applicationMatches(post.id) && this.applicationState === ApplicationState.PENDING) {
      this.onApproveApplication();
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
          .fontColor(this.effectiveScope() === scope ? '#FFFFFF' : COLOR_BLUE)
          .backgroundColor(this.effectiveScope() === scope ? COLOR_BLUE : COLOR_BLUE_SOFT)
          .borderRadius(4)
          .onClick(() => {
            this.activeScope = scope;
          })
      }, (scope: RecruitmentScope) => scope)
    }
    .width('100%')
  }

  @Builder
  FilterBar() {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
      ForEach(['全部', '技术活动', '志愿服务', '现场协同'], (filter: string) => {
        Button(filter)
          .height(34)
          .fontSize(12)
          .fontColor(this.activeFilter === filter ? COLOR_BLUE : COLOR_MUTED)
          .backgroundColor(this.activeFilter === filter ? COLOR_BLUE_SOFT : COLOR_SURFACE)
          .border({ width: 1, color: this.activeFilter === filter ? COLOR_BLUE : COLOR_BORDER })
          .borderRadius(4)
          .margin({ right: 8, bottom: 8 })
          .onClick(() => {
            this.activeFilter = filter;
          })
      }, (filter: string) => filter)
    }
    .width('100%')
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
          feedbackLabel: this.isResponsibleTeacher(post.id) ? '报名审核' : '报名状态',
          feedbackText: this.feedbackText(post.id),
          onBack: () => {
            this.selectedPostId = '';
          },
          onAction: () => {
            this.handleAction(post);
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
          Text('校园活动岗位').fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_BLUE)
          Blank()
          Text(`${this.posts().length} 条`).fontSize(12).fontColor(COLOR_MUTED)
        }
        .width('100%')
        this.ScopeBar()
        this.FilterBar()
        if (this.posts().length === 0) {
          Text('没有匹配的校园活动').width('100%').padding(28).textAlign(TextAlign.Center).fontSize(14).fontColor(COLOR_MUTED)
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
    }
    .width('100%')
    .constraintSize({ maxWidth: PAGE_MAX_WIDTH })
    .padding({ left: this.isWide ? 28 : 18, right: this.isWide ? 28 : 18 })
  }
}
