import { ActivityFeed } from '../../activity/components/ActivityFeed';
import { CompetitionFeed } from '../../competition/components/CompetitionFeed';
import {
  AccountRole,
  ApplicationState,
  DemoAccount,
  RecruitmentKind,
  RecruitmentPost
} from '../../../domain/WorkflowModels';
import { RecruitmentComposer } from '../components/RecruitmentComposer';
import {
  COLOR_BLUE,
  COLOR_BLUE_SOFT,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_SURFACE,
  COLOR_SURFACE_ALT,
  COLOR_TEXT,
  PAGE_MAX_WIDTH
} from '../../../shared/Theme';

@Component
export struct HomePage {
  @Prop isLoggedIn: boolean = false;
  @Prop isWide: boolean = false;
  @Prop accountRole: AccountRole = AccountRole.STUDENT;
  @Prop demoAccount: DemoAccount = DemoAccount.STUDENT_APPLICANT;
  @Prop competitionApplicationPostId: string = '';
  @Prop competitionApplicationState: ApplicationState = ApplicationState.NONE;
  @Prop activityApplicationPostId: string = '';
  @Prop activityApplicationState: ApplicationState = ApplicationState.NONE;
  @Prop competitionApplicationApplicantId: string = '';
  @Prop competitionApplicationApplicantName: string = '';
  @Prop competitionApplicationApplicantEvidence: string = '';
  @Prop activityApplicationApplicantId: string = '';
  @Prop activityApplicationApplicantName: string = '';
  @Prop publishedPosts: RecruitmentPost[] = [];
  @Prop acceptedAdvisorPostIds: string[] = [];
  @State activeSection: number = 0;
  @State searchText: string = '';
  @State showComposer: boolean = false;
  onRequireLogin: () => void = () => {};
  onStartWorkflow: (title: string) => void = (_title: string) => {};
  onSubmitCompetitionApplication: (postId: string) => void = (_postId: string) => {};
  onApproveCompetitionApplication: () => void = () => {};
  onSubmitActivityApplication: (postId: string) => void = (_postId: string) => {};
  onApproveActivityApplication: () => void = () => {};
  onRecruitmentPublished: (post: RecruitmentPost) => void = (_post: RecruitmentPost) => {};

  private openComposer(): void {
    if (this.isLoggedIn) {
      this.showComposer = true;
    } else {
      this.onRequireLogin();
    }
  }

  @Builder
  PublishButton() {
    Button(this.activeSection === 0 ? '发布组队招募' : '发布活动岗位')
      .height(42)
      .fontSize(13)
      .fontWeight(FontWeight.Medium)
      .fontColor('#FFFFFF')
      .backgroundColor(COLOR_PRIMARY)
      .borderRadius(4)
      .onClick(() => {
        this.openComposer();
      })
  }

  @Builder
  SectionTabs() {
    Row() {
      Column({ space: 10 }) {
        Text('比赛组队')
          .fontSize(14)
          .fontWeight(this.activeSection === 0 ? FontWeight.Bold : FontWeight.Medium)
          .fontColor(this.activeSection === 0 ? COLOR_TEXT : COLOR_MUTED)
          .onClick(() => {
            this.activeSection = 0;
          })
        Divider()
          .strokeWidth(this.activeSection === 0 ? 2 : 1)
          .color(this.activeSection === 0 ? COLOR_PRIMARY : COLOR_BORDER)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .onClick(() => {
        this.activeSection = 0;
      })
      Column({ space: 10 }) {
        Text('校园活动')
          .fontSize(14)
          .fontWeight(this.activeSection === 1 ? FontWeight.Bold : FontWeight.Medium)
          .fontColor(this.activeSection === 1 ? COLOR_TEXT : COLOR_MUTED)
          .onClick(() => {
            this.activeSection = 1;
          })
        Divider()
          .strokeWidth(this.activeSection === 1 ? 2 : 1)
          .color(this.activeSection === 1 ? COLOR_BLUE : COLOR_BORDER)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .onClick(() => {
        this.activeSection = 1;
      })
    }
    .width('100%')
    .padding({ top: 18 })
  }

  @Builder
  OpportunityFeed() {
    if (this.activeSection === 0) {
      CompetitionFeed({
        query: this.searchText,
        isLoggedIn: this.isLoggedIn,
        isWide: this.isWide,
        demoAccount: this.demoAccount,
        extraPosts: this.publishedPosts,
        applicationPostId: this.competitionApplicationPostId,
        applicationState: this.competitionApplicationState,
        applicationApplicantId: this.competitionApplicationApplicantId,
        applicationApplicantName: this.competitionApplicationApplicantName,
        applicationApplicantEvidence: this.competitionApplicationApplicantEvidence,
        acceptedAdvisorPostIds: this.acceptedAdvisorPostIds,
        onRequireLogin: () => {
          this.onRequireLogin();
        },
        onStartWorkflow: (title: string) => {
          this.onStartWorkflow(title);
        },
        onSubmitApplication: (postId: string) => {
          this.onSubmitCompetitionApplication(postId);
        },
        onApproveApplication: () => {
          this.onApproveCompetitionApplication();
        }
      })
    } else {
      ActivityFeed({
        query: this.searchText,
        isLoggedIn: this.isLoggedIn,
        isWide: this.isWide,
        demoAccount: this.demoAccount,
        extraPosts: this.publishedPosts,
        applicationPostId: this.activityApplicationPostId,
        applicationState: this.activityApplicationState,
        applicationApplicantId: this.activityApplicationApplicantId,
        applicationApplicantName: this.activityApplicationApplicantName,
        onRequireLogin: () => {
          this.onRequireLogin();
        },
        onSubmitApplication: (postId: string) => {
          this.onSubmitActivityApplication(postId);
        },
        onApproveApplication: () => {
          this.onApproveActivityApplication();
        }
      })
    }
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 0 }) {
          Row() {
            Column({ space: 5 }) {
              Text('机会工作台')
                .fontSize(this.isWide ? 27 : 23)
                .fontWeight(FontWeight.Bold)
                .fontColor(COLOR_TEXT)
              Text(this.activeSection === 0 ? '找到合适的队伍，比较角色与时间要求' : '查看校园活动与可报名岗位')
                .fontSize(13)
                .fontColor(COLOR_MUTED)
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)
            if (this.isWide && !this.showComposer) {
              this.PublishButton()
            }
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)

          if (this.showComposer) {
            RecruitmentComposer({
              defaultKind: this.activeSection === 0 ? RecruitmentKind.COMPETITION : RecruitmentKind.ACTIVITY,
              accountRole: this.accountRole,
              demoAccount: this.demoAccount,
              isWide: this.isWide,
              onClose: () => {
                this.showComposer = false;
              },
              onPublished: (post: RecruitmentPost) => {
                this.onRecruitmentPublished(post);
                this.showComposer = false;
              }
            })
              .margin({ top: 18 })
          } else {
            if (!this.isLoggedIn) {
              Row({ space: 10 }) {
                Text('游客')
                  .fontSize(11)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(COLOR_BLUE)
                Text('可浏览公开机会；申请、报名和发布时需要登录。')
                  .layoutWeight(1)
                  .fontSize(12)
                  .fontColor(COLOR_TEXT)
              }
              .width('100%')
              .margin({ top: 16 })
              .padding({ left: 12, right: 12, top: 10, bottom: 10 })
              .backgroundColor(COLOR_BLUE_SOFT)
              .border({ width: { left: 3 }, color: COLOR_BLUE })
            }

            Row({ space: 10 }) {
              TextInput({ placeholder: '搜索名称、岗位、组织或发布者', text: this.searchText })
                .layoutWeight(1)
                .height(42)
                .fontSize(13)
                .backgroundColor(COLOR_SURFACE)
                .border({ width: 1, color: COLOR_BORDER })
                .borderRadius(4)
                .onChange((value: string) => {
                  this.searchText = value;
                })
              if (!this.isWide) {
                this.PublishButton()
              }
            }
            .width('100%')
            .margin({ top: 16 })

            this.SectionTabs()

            this.OpportunityFeed()

            Row({ space: 10 }) {
              Text('审批规则')
                .fontSize(11)
                .fontWeight(FontWeight.Bold)
                .fontColor(COLOR_MUTED)
              Text(this.activeSection === 0 ? '队长审批加入申请；指导老师接受邀请后可协助管理。' :
                '活动报名由负责老师审批，录取结果同步到申请人。')
                .layoutWeight(1)
                .fontSize(12)
                .fontColor(COLOR_MUTED)
            }
            .width('100%')
            .margin({ top: 18 })
            .padding({ top: 14, bottom: 2 })
            .border({ width: { top: 1 }, color: COLOR_BORDER })
          }
        }
        .width('100%')
        .constraintSize({ maxWidth: PAGE_MAX_WIDTH })
        .padding({ left: this.isWide ? 28 : 18, right: this.isWide ? 28 : 18, top: 24, bottom: 28 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLOR_SURFACE_ALT)
    .scrollBar(BarState.Off)
  }
}
