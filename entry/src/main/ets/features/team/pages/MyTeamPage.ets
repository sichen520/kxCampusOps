import {
  AccountRole,
  ApplicationState,
  DemoAccount,
  RecruitmentPost,
  TeamMember
} from '../../../domain/WorkflowModels';
import { PageTitle } from '../../../shared/components/PageTitle';
import { StatusPill } from '../../../shared/components/StatusPill';
import { TeamCreatePage } from './TeamCreatePage';
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
export struct MyTeamPage {
  @Prop accountRole: AccountRole = AccountRole.STUDENT;
  @Prop demoAccount: DemoAccount = DemoAccount.STUDENT_APPLICANT;
  @Prop teamExists: boolean = false;
  @Prop teamConfirmed: boolean = false;
  @Prop isWide: boolean = false;
  @Prop teamTitle: string = '';
  @Prop opportunityTitle: string = '';
  @Prop currentAccountId: string = '';
  @Prop currentDisplayName: string = '';
  @Prop teamOwnerId: string = '';
  @Prop teamOwnerName: string = '';
  @Prop applicantId: string = '';
  @Prop applicantName: string = '';
  @Prop applicantEvidence: string = '';
  @Prop applicationState: ApplicationState = ApplicationState.NONE;
  @Prop advisorId: string = '';
  @Prop advisorName: string = '';
  @Prop advisorAccepted: boolean = false;
  @Prop canManageTeam: boolean = false;
  @State showCreator: boolean = false;
  onCreateTeam: (post: RecruitmentPost) => void = (_post: RecruitmentPost) => {};
  onAcceptAdvisor: () => void = () => {};
  onApproveApplicant: () => void = () => {};
  onRejectApplicant: () => void = () => {};
  onOpenFeasibility: () => void = () => {};
  onOpenHome: () => void = () => {};

  private isCurrentLeader(): boolean {
    return this.teamExists && this.currentAccountId === this.teamOwnerId;
  }

  private hasPendingApplication(): boolean {
    return this.canManageTeam && this.applicationState === ApplicationState.PENDING &&
      this.applicantId.length > 0;
  }

  private members(): TeamMember[] {
    const result: TeamMember[] = [{
      id: this.teamOwnerId,
      name: this.teamOwnerName,
      role: '队伍创建者 · 临时队长',
      status: '已确认',
      isLeader: true
    }];
    if (this.applicationState === ApplicationState.APPROVED && this.applicantId.length > 0 &&
      this.applicantId !== this.teamOwnerId) {
      result.push({
        id: this.applicantId,
        name: this.applicantName,
        role: '队员 · 已通过加入申请',
        status: '已确认',
        isLeader: false
      });
    }
    return result;
  }

  @Builder
  MemberRow(member: TeamMember) {
    Row({ space: 12 }) {
      Text(member.name.slice(0, 1))
        .width(40).height(40).textAlign(TextAlign.Center).fontSize(15).fontWeight(FontWeight.Bold)
        .fontColor(member.isLeader ? COLOR_PRIMARY : COLOR_BLUE)
        .backgroundColor(member.isLeader ? COLOR_PRIMARY_SOFT : COLOR_BLUE_SOFT)
        .borderRadius(20).padding({ top: 10 })
      Column({ space: 4 }) {
        Row({ space: 8 }) {
          Text(member.name).fontSize(15).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
          if (member.isLeader) {
            StatusPill({ text: '队长', fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
          }
        }
        Text(member.role).fontSize(12).fontColor(COLOR_MUTED)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      Text(member.status).fontSize(12).fontColor(COLOR_MUTED)
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
  }

  @Builder
  EmptyTeam() {
    Column({ space: 14 }) {
      Text(this.accountRole === AccountRole.TEACHER ? '尚未绑定指导队伍' :
        this.accountRole === AccountRole.ADMIN ? '管理账号不加入业务队伍' : '还没有加入或创建任何队伍')
        .fontSize(21).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      Text(this.accountRole === AccountRole.TEACHER ?
        '学生发起指导邀请并经你确认后，队伍及指导关系会显示在这里。' :
        this.accountRole === AccountRole.ADMIN ? '管理员只处理平台治理，不拥有学生队伍或活动队伍。' :
        '你可以直接创建比赛组队招募，也可以从首页申请加入其他同学的队伍。')
        .width('100%').textAlign(TextAlign.Center).fontSize(14).lineHeight(22).fontColor(COLOR_MUTED)
      if (this.accountRole === AccountRole.STUDENT) {
        Row({ space: 10 }) {
          Button('创建比赛队伍')
            .layoutWeight(1).height(46).fontSize(14).fontColor('#FFFFFF')
            .backgroundColor(COLOR_PRIMARY).borderRadius(5)
            .onClick(() => { this.showCreator = true; })
          Button('浏览比赛招募')
            .layoutWeight(1).height(46).fontSize(14).fontColor(COLOR_PRIMARY)
            .backgroundColor(COLOR_PRIMARY_SOFT).borderRadius(5)
            .onClick(() => { this.onOpenHome(); })
        }
        .width('100%')
      } else if (this.accountRole === AccountRole.TEACHER) {
        Button('浏览比赛招募')
          .width('100%').height(46).fontSize(14).fontColor(COLOR_PRIMARY)
          .backgroundColor(COLOR_PRIMARY_SOFT).borderRadius(5)
          .onClick(() => { this.onOpenHome(); })
      }
    }
    .width('100%')
    .padding({ top: 42, bottom: 42, left: 28, right: 28 })
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(8)
    .border({ width: 1, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  TeamOverview() {
    Column({ space: 20 }) {
      Row() {
        Column({ space: 5 }) {
          Text(this.teamTitle).fontSize(22).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text(this.opportunityTitle).fontSize(13).fontColor(COLOR_MUTED)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        StatusPill({
          text: this.teamConfirmed ? '正式成立' : '招募中',
          fillColor: this.teamConfirmed ? COLOR_PRIMARY_SOFT : COLOR_AMBER_SOFT,
          textColor: this.teamConfirmed ? COLOR_PRIMARY : COLOR_AMBER
        })
      }
      .width('100%')
      Row({ space: 10 }) {
        StatusPill({
          text: this.isCurrentLeader() ? '我的权限：本队队长' :
            this.canManageTeam ? '我的权限：指导老师' : '我的权限：队员 / 待确认',
          fillColor: this.canManageTeam ? COLOR_PRIMARY_SOFT : COLOR_BLUE_SOFT,
          textColor: this.canManageTeam ? COLOR_PRIMARY : COLOR_BLUE
        })
        Text(this.isCurrentLeader() ?
          '你创建了这条组队招募，因此只在这支队伍中拥有审批和分工权限。' :
          this.canManageTeam ? '你已接受指导邀请，与队长共享成员管理和任务分工权限。' :
          '你在这支队伍中没有管理权限，队长由创建关系决定，指导老师需先接受邀请。')
          .layoutWeight(1).fontSize(13).lineHeight(20).fontColor(COLOR_TEXT)
      }
      .width('100%')
      .padding(14)
      .backgroundColor(this.isCurrentLeader() ? COLOR_PRIMARY_SOFT : COLOR_BLUE_SOFT)
      .borderRadius(6)
      if (this.hasPendingApplication()) {
        this.PendingApplicationPanel()
      }
      if (this.isWide) {
        Row({ space: 18 }) {
          this.MemberPanel()
          this.TeacherPanel()
        }
        .width('100%')
        .alignItems(VerticalAlign.Top)
      } else {
        this.MemberPanel()
        this.TeacherPanel()
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  PendingApplicationPanel() {
    Column({ space: 14 }) {
      Row() {
        Column({ space: 3 }) {
          Text('待审批申请').fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('批准后申请人才会成为正式队员。').fontSize(12).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        StatusPill({ text: '1 条待处理', fillColor: COLOR_AMBER_SOFT, textColor: COLOR_AMBER })
      }
      .width('100%')
      Divider().color(COLOR_BORDER)
      Row({ space: 12 }) {
        Text(this.applicantName.slice(0, 1))
          .width(44).height(44).textAlign(TextAlign.Center).padding({ top: 11 })
          .fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_BLUE)
          .backgroundColor(COLOR_BLUE_SOFT).borderRadius(22)
        Column({ space: 4 }) {
          Text(this.applicantName).fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('申请加入当前比赛队伍').fontSize(12).fontColor(COLOR_MUTED)
          Text(this.applicantEvidence.length > 0 ? this.applicantEvidence : '申请人暂未补充能力说明')
            .fontSize(12).fontColor(COLOR_BLUE)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      Row({ space: 10 }) {
        Button('拒绝申请')
          .layoutWeight(1).height(42).fontSize(13).fontColor(COLOR_AMBER)
          .backgroundColor(COLOR_AMBER_SOFT).borderRadius(5)
          .onClick(() => { this.onRejectApplicant(); })
        Button('批准加入')
          .layoutWeight(1).height(42).fontSize(13).fontColor('#FFFFFF')
          .backgroundColor(COLOR_PRIMARY).borderRadius(5)
          .onClick(() => { this.onApproveApplicant(); })
      }
      .width('100%')
    }
    .width('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_AMBER })
    .borderRadius(8)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  MemberPanel() {
    Column({ space: 2 }) {
      Text('队伍成员').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      Text(`${this.members().length} 名已确认成员`).fontSize(12).fontColor(COLOR_MUTED)
      Divider().color(COLOR_BORDER).margin({ top: 8 })
      ForEach(this.members(), (member: TeamMember) => {
        this.MemberRow(member)
        Divider().color(COLOR_BORDER)
      }, (member: TeamMember) => member.id)
    }
    .layoutWeight(2)
    .width(this.isWide ? undefined : '100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(8)
    .border({ width: 1, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  TeacherPanel() {
    Column({ space: 10 }) {
      Text('指导老师').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      Text(this.advisorName.length > 0 ? this.advisorName : '暂未选择')
        .fontSize(18).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
      StatusPill({
        text: this.advisorName.length === 0 ? '未选择' : this.advisorAccepted ? '已接受指导' : '待老师接受',
        fillColor: this.advisorAccepted ? COLOR_PRIMARY_SOFT : COLOR_AMBER_SOFT,
        textColor: this.advisorAccepted ? COLOR_PRIMARY : COLOR_AMBER
      })
      Text(this.advisorAccepted ? '指导老师与队长共享成员管理、AI 分工确认和任务发布权限。' :
        '选择老师只会发送邀请；老师接受后才建立指导关系并获得管理权限。')
        .fontSize(13).lineHeight(20).fontColor(COLOR_MUTED)
      if (this.currentAccountId === this.advisorId && !this.advisorAccepted) {
        Button('接受指导邀请')
          .width('100%').height(40).fontSize(13).fontColor('#FFFFFF')
          .backgroundColor(COLOR_PRIMARY).borderRadius(5)
          .onClick(() => { this.onAcceptAdvisor(); })
      } else if (this.isCurrentLeader()) {
        Button('去可行查看指导条件')
          .width('100%').height(40).fontSize(13).fontColor(COLOR_PRIMARY)
          .backgroundColor(COLOR_PRIMARY_SOFT).borderRadius(5)
          .onClick(() => { this.onOpenFeasibility(); })
      }
    }
    .layoutWeight(1)
    .width(this.isWide ? undefined : '100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(8)
    .border({ width: 1, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    if (this.showCreator) {
      TeamCreatePage({
        accountRole: this.accountRole,
        demoAccount: this.demoAccount,
        isWide: this.isWide,
        suggestedTitle: this.opportunityTitle,
        onClose: () => { this.showCreator = false; },
        onCreated: (post: RecruitmentPost) => {
          this.onCreateTeam(post);
          this.showCreator = false;
        }
      })
    } else {
      Scroll() {
        Row() {
          Column({ space: 20 }) {
            PageTitle({
              eyebrow: '队伍',
              title: this.teamExists ? '我的队伍' : '队伍与指导关系',
              description: this.teamExists ? '队长由具体队伍的创建或移交关系决定，不是账号的固定身份。' :
                '创建、加入和指导关系都需要明确的双向确认。'
            })
            if (this.teamExists) {
              this.TeamOverview()
            } else {
              this.EmptyTeam()
            }
          }
          .width('100%')
          .constraintSize({ maxWidth: PAGE_MAX_WIDTH })
          .padding({ left: this.isWide ? 32 : 18, right: this.isWide ? 32 : 18, top: 26, bottom: 32 })
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
}
