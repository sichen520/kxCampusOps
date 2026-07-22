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
import { PageTitle } from '../../../shared/components/PageTitle';
import { StatusPill } from '../../../shared/components/StatusPill';
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
  @State searchFocused: boolean = false;
  onRequireLogin: () => void = () => {};
  onStartWorkflow: (title: string) => void = (_title: string) => {};
  onSubmitCompetitionApplication: (postId: string) => void = (_postId: string) => {};
  onApproveCompetitionApplication: () => void = () => {};
  onSubmitActivityApplication: (postId: string) => void = (_postId: string) => {};
  onApproveActivityApplication: () => void = () => {};
  onRecruitmentPublished: (post: RecruitmentPost) => void = (_post: RecruitmentPost) => {};

  private switchSection(index: number): void {
    if (this.activeSection === index) {
      return;
    }
    this.getUIContext().animateTo({ duration: 220, curve: Curve.EaseOut }, () => {
      this.activeSection = index;
    });
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: this.isWide ? 16 : 12 }) {
          PageTitle({
            eyebrow: '首页 · 校园机会广场',
            title: this.isWide ? '发现招募，找到下一步行动' : '校园机会与招募',
            description: '比赛组队和校园活动在同一个入口发现，但采用各自独立的审批与参与流程。',
            compact: !this.isWide
          })

          if (this.showComposer) {
            RecruitmentComposer({
              defaultKind: this.activeSection === 0 ? RecruitmentKind.COMPETITION : RecruitmentKind.ACTIVITY,
              accountRole: this.accountRole,
              demoAccount: this.demoAccount,
              onClose: () => {
                this.showComposer = false;
              },
              onPublished: (post: RecruitmentPost) => {
                this.onRecruitmentPublished(post);
                this.showComposer = false;
              }
            })
          } else {
            if (!this.isLoggedIn) {
              Row({ space: 10 }) {
                StatusPill({ text: '游客浏览', fillColor: COLOR_BLUE_SOFT, textColor: COLOR_BLUE })
                Text('公开信息可以直接查看，申请加入、报名活动和发布招募需要登录。')
                  .layoutWeight(1).fontSize(13).fontColor(COLOR_TEXT)
              }
              .width('100%')
              .padding(this.isWide ? 14 : 10)
              .backgroundColor(COLOR_BLUE_SOFT)
              .borderRadius(6)
            }

            Row({ space: this.isWide ? 10 : 8 }) {
              TextInput({ placeholder: '搜索比赛、活动、岗位或发布者', text: this.searchText })
                .layoutWeight(1)
                .height(this.isWide ? 46 : 42)
                .fontSize(this.isWide ? 14 : 13)
                .backgroundColor(this.searchFocused ? COLOR_SURFACE : '#F0F3F2')
                .border({ width: this.searchFocused ? 1.5 : 1,
                  color: this.searchFocused ? COLOR_PRIMARY : COLOR_BORDER })
                .borderRadius(7)
                .animation({ duration: 160, curve: Curve.EaseOut })
                .onFocus(() => {
                  this.searchFocused = true;
                })
                .onBlur(() => {
                  this.searchFocused = false;
                })
                .onChange((value: string) => {
                  this.searchText = value;
                })
              Button(this.isWide ? (this.activeSection === 0 ? '发布组队招募' : '发布活动') : '发布')
                .width(this.isWide ? 116 : 68)
                .height(this.isWide ? 46 : 42)
                .fontSize(this.isWide ? 14 : 13)
                .fontColor('#FFFFFF')
                .backgroundColor(this.activeSection === 0 ? COLOR_PRIMARY : COLOR_BLUE)
                .borderRadius(7)
                .animation({ duration: 180, curve: Curve.EaseOut })
                .onClick(() => {
                  if (this.isLoggedIn) {
                    this.showComposer = true;
                  } else {
                    this.onRequireLogin();
                  }
                })
            }
            .width('100%')

            Row({ space: 8 }) {
              Button('比赛组队')
                .layoutWeight(1)
                .height(this.isWide ? 42 : 38)
                .fontSize(this.isWide ? 14 : 13)
                .fontWeight(this.activeSection === 0 ? FontWeight.Bold : FontWeight.Medium)
                .fontColor(this.activeSection === 0 ? '#FFFFFF' : COLOR_MUTED)
                .backgroundColor(this.activeSection === 0 ? COLOR_PRIMARY : Color.Transparent)
                .borderRadius(6)
                .animation({ duration: 180, curve: Curve.EaseOut })
                .onClick(() => {
                  this.switchSection(0);
                })
              Button('校园活动')
                .layoutWeight(1)
                .height(this.isWide ? 42 : 38)
                .fontSize(this.isWide ? 14 : 13)
                .fontWeight(this.activeSection === 1 ? FontWeight.Bold : FontWeight.Medium)
                .fontColor(this.activeSection === 1 ? '#FFFFFF' : COLOR_MUTED)
                .backgroundColor(this.activeSection === 1 ? COLOR_BLUE : Color.Transparent)
                .borderRadius(6)
                .animation({ duration: 180, curve: Curve.EaseOut })
                .onClick(() => {
                  this.switchSection(1);
                })
            }
            .width('100%')
            .padding(3)
            .backgroundColor('#E9EEEC')
            .borderRadius(8)

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

            Row({ space: 8 }) {
              StatusPill({ text: '审批边界', fillColor: COLOR_AMBER_SOFT, textColor: COLOR_AMBER })
              Text(this.activeSection === 0 ? '比赛申请由队长审批，队长邀请还需候选人接受。' :
                '活动报名由负责老师审批，老师指定也需要学生本人确认。')
                .layoutWeight(1).fontSize(12).fontColor(COLOR_MUTED)
            }
            .width('100%')
            .padding(this.isWide ? 12 : 10)
            .backgroundColor(COLOR_SURFACE)
            .borderRadius(6)
            .border({ width: 1, color: COLOR_BORDER })
          }
        }
        .width('100%')
        .constraintSize({ maxWidth: PAGE_MAX_WIDTH })
        .padding({ left: this.isWide ? 28 : 16, right: this.isWide ? 28 : 16,
          top: this.isWide ? 22 : 16, bottom: this.isWide ? 28 : 20 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
  }
}
