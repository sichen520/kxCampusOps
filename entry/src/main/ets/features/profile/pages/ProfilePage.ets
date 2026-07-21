import { AccountRole, ApplicationState, DemoAccount, UserProfile } from '../../../domain/WorkflowModels';
import { PageTitle } from '../../../shared/components/PageTitle';
import { StatusPill } from '../../../shared/components/StatusPill';
import { DeviceManagementPanel } from '../components/DeviceManagementPanel';
import { FeedbackPanel } from '../components/FeedbackPanel';
import { NotificationSettingsPanel } from '../components/NotificationSettingsPanel';
import { PrivacySettingsPanel } from '../components/PrivacySettingsPanel';
import { ProfileActivityPanel } from '../components/ProfileActivityPanel';
import { ProfileApplicationsPanel } from '../components/ProfileApplicationsPanel';
import {
  COLOR_AMBER,
  COLOR_AMBER_SOFT,
  COLOR_BLUE,
  COLOR_BLUE_SOFT,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_RED,
  COLOR_RED_SOFT,
  COLOR_SURFACE,
  COLOR_TEXT,
  PAGE_MAX_WIDTH
} from '../../../shared/Theme';

@Component
export struct ProfilePage {
  @Prop isWide: boolean = false;
  @Prop accountRole: AccountRole = AccountRole.STUDENT;
  @Prop demoAccount: DemoAccount = DemoAccount.STUDENT_APPLICANT;
  @Prop accountId: string = '';
  @Prop displayName: string = '';
  @Prop college: string = '';
  @Prop grade: string = '';
  @Prop major: string = '';
  @Prop availability: string = '';
  @Prop teamExists: boolean = false;
  @Prop projectExists: boolean = false;
  @Prop knowledgeContributionCount: number = 0;
  @Prop competitionApplicationState: ApplicationState = ApplicationState.NONE;
  @Prop activityApplicationState: ApplicationState = ApplicationState.NONE;
  @State isEditing: boolean = false;
  @State editDisplayName: string = '';
  @State editCollege: string = '';
  @State editGrade: string = '';
  @State editMajor: string = '';
  @State editAvailability: string = '';
  @State editMessage: string = '';
  @State resetArmed: boolean = false;
  @State activePanel: string = '';
  onLogout: () => void = () => {};
  onOpenTeam: () => void = () => {};
  onOpenProject: () => void = () => {};
  onOpenHome: () => void = () => {};
  onOpenAdmin: () => void = () => {};
  onSaveProfile: (profile: UserProfile) => void = (_profile: UserProfile) => {};
  onResetDemoData: () => void = () => {};

  aboutToAppear(): void {
    this.resetEditor();
  }

  private resetEditor(): void {
    this.editDisplayName = this.displayName;
    this.editCollege = this.college;
    this.editGrade = this.grade;
    this.editMajor = this.major;
    this.editAvailability = this.availability;
    this.editMessage = '';
  }

  private saveEditor(): void {
    if (this.editDisplayName.trim().length === 0 || this.editCollege.trim().length === 0 ||
      this.editMajor.trim().length === 0) {
      this.editMessage = '姓名、学院和专业不能为空。';
      return;
    }
    this.onSaveProfile({
      accountId: this.accountId,
      displayName: this.editDisplayName.trim(),
      college: this.editCollege.trim(),
      grade: this.editGrade.trim(),
      major: this.editMajor.trim(),
      availability: this.editAvailability.trim()
    });
    this.isEditing = false;
  }

  private accountName(): string {
    return this.displayName;
  }

  private accountIdentity(): string {
    return `${this.college} · ${this.grade}`;
  }

  private applicationBadge(): string {
    if (this.competitionApplicationState === ApplicationState.APPROVED) {
      return '比赛已通过';
    }
    if (this.activityApplicationState === ApplicationState.APPROVED) {
      return '活动已通过';
    }
    if (this.competitionApplicationState === ApplicationState.PENDING ||
      this.activityApplicationState === ApplicationState.PENDING) {
      return '待审批';
    }
    if (this.competitionApplicationState === ApplicationState.REJECTED ||
      this.activityApplicationState === ApplicationState.REJECTED) {
      return '申请未通过';
    }
    return '暂无申请';
  }

  private pendingCount(): number {
    let count: number = 0;
    if (this.competitionApplicationState === ApplicationState.PENDING) {
      count += 1;
    }
    if (this.activityApplicationState === ApplicationState.PENDING) {
      count += 1;
    }
    return count;
  }

  @Builder
  IdentityCard() {
    Row({ space: 14 }) {
      Text(this.accountRole === AccountRole.STUDENT ? '学生' : this.accountRole === AccountRole.TEACHER ? '老师' : '管')
        .width(54)
        .height(54)
        .textAlign(TextAlign.Center)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .backgroundColor(COLOR_PRIMARY)
        .borderRadius(27)
        .padding({ top: 17 })
      Column({ space: 5 }) {
        Row({ space: 8 }) {
          Text(this.accountName())
            .fontSize(20).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          StatusPill({ text: this.accountRole === AccountRole.ADMIN ? '平台账号' : '身份已确认', fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
        }
        Text(this.accountIdentity())
          .fontSize(13).fontColor(COLOR_MUTED)
        Text(this.accountRole === AccountRole.ADMIN ? '平台权限范围：内容审核与治理' : '个人资料完整度 72%').fontSize(12).fontColor(COLOR_BLUE)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      Button('编辑资料')
        .height(36)
        .fontSize(13)
        .fontColor(COLOR_PRIMARY)
        .backgroundColor(COLOR_PRIMARY_SOFT)
        .borderRadius(4)
        .onClick(() => {
          this.resetEditor();
          this.isEditing = true;
        })
    }
    .width('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(6)
    .border({ width: 1, color: COLOR_BORDER })
  }

  @Builder
  ProfileEditor() {
    Column({ space: 12 }) {
      Row() {
        Column({ space: 3 }) {
          Text('编辑个人资料').fontSize(18).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('保存后会写入当前演示账号的本地持久数据。').fontSize(12).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        Button('取消').height(34).fontSize(13).fontColor(COLOR_MUTED).backgroundColor(Color.Transparent)
          .onClick(() => {
            this.resetEditor();
            this.isEditing = false;
          })
      }
      .width('100%')
      TextInput({ placeholder: '姓名', text: this.editDisplayName })
        .width('100%').height(44).backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
        .onChange((value: string) => { this.editDisplayName = value; })
      Row({ space: 10 }) {
        TextInput({ placeholder: '学院或组织', text: this.editCollege })
          .layoutWeight(2).height(44).backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
          .onChange((value: string) => { this.editCollege = value; })
        TextInput({ placeholder: '年级或身份', text: this.editGrade })
          .layoutWeight(1).height(44).backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
          .onChange((value: string) => { this.editGrade = value; })
      }
      .width('100%')
      TextInput({ placeholder: '专业或主要方向', text: this.editMajor })
        .width('100%').height(44).backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
        .onChange((value: string) => { this.editMajor = value; })
      TextInput({ placeholder: '可投入时间，例如工作日晚间、周五下午', text: this.editAvailability })
        .width('100%').height(44).backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
        .onChange((value: string) => { this.editAvailability = value; })
      if (this.editMessage.length > 0) {
        Text(this.editMessage).fontSize(12).fontColor(COLOR_AMBER)
      }
      Button('保存资料')
        .width('100%').height(44).fontSize(14).fontColor('#FFFFFF')
        .backgroundColor(COLOR_PRIMARY).borderRadius(5)
        .onClick(() => { this.saveEditor(); })
    }
    .width('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(8)
    .border({ width: 1, color: COLOR_PRIMARY })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  Stat(value: string, label: string, color: string) {
    Column({ space: 4 }) {
      Text(value).fontSize(23).fontWeight(FontWeight.Bold).fontColor(color)
      Text(label).fontSize(12).fontColor(COLOR_MUTED)
    }
    .layoutWeight(1)
    .padding(13)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(5)
    .border({ width: 1, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  MenuItem(title: string, caption: string, badge: string, onClick: () => void) {
    Row({ space: 12 }) {
      Column({ space: 3 }) {
        Text(title).fontSize(15).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        Text(caption).fontSize(12).fontColor(COLOR_MUTED)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      if (badge.length > 0) {
        StatusPill({ text: badge, fillColor: COLOR_AMBER_SOFT, textColor: COLOR_AMBER })
      }
      Text('>').fontSize(16).fontColor(COLOR_MUTED)
    }
    .width('100%')
    .padding({ top: 13, bottom: 13 })
    .onClick(() => {
      onClick();
    })
  }

  @Builder
  AbilityPassport() {
    Column({ space: 12 }) {
      Text('能力护照').fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      Text('只在你授权后向招募负责人展示证据。').fontSize(12).fontColor(COLOR_MUTED)
      Row({ space: 8 }) {
        StatusPill({ text: 'ArkTS', fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
        StatusPill({ text: '应用开发', fillColor: COLOR_BLUE_SOFT, textColor: COLOR_BLUE })
        StatusPill({ text: '可组队', fillColor: COLOR_AMBER_SOFT, textColor: COLOR_AMBER })
      }
      Divider().color(COLOR_BORDER)
      Text('已验证证据').fontSize(14).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
      Text('HarmonyOS API 24 工程构建记录').fontSize(13).fontColor(COLOR_TEXT)
      Text('Hvigor 构建通过 · 2026-07-21').fontSize(12).fontColor(COLOR_MUTED)
      Text(`可投入时间：${this.availability}`).fontSize(13).fontColor(COLOR_MUTED)
    }
    .width('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(6)
    .border({ width: 1, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  PersonalMenus() {
    Column() {
      Text(this.accountRole === AccountRole.STUDENT ? '个人事务' : this.accountRole === AccountRole.ADMIN ? '平台事务' : '指导事务')
        .width('100%').fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      if (this.accountRole === AccountRole.STUDENT) {
        this.MenuItem('我的申请', '比赛组队与活动岗位申请记录', this.applicationBadge(), () => {
          this.activePanel = 'applications';
        })
        Divider().color(COLOR_BORDER)
        this.MenuItem('我的队伍', '已加入队伍、邀请与候补状态', this.teamExists ? '1 个队伍' : '暂无队伍', () => {
          this.onOpenTeam();
        })
        Divider().color(COLOR_BORDER)
        this.MenuItem('我的项目', 'CampusOps 项目与个人任务', this.projectExists ? '进入项目' : '暂无项目', () => {
          this.onOpenProject();
        })
        Divider().color(COLOR_BORDER)
        this.MenuItem('活动记录', '班次、签到和服务时长', '', () => {
          this.activePanel = 'activities';
        })
      } else if (this.accountRole === AccountRole.TEACHER) {
        this.MenuItem('报名审批', '查看学生报名并决定是否录取', '进入活动', () => {
          this.onOpenHome();
        })
        Divider().color(COLOR_BORDER)
        this.MenuItem('我发布的活动', '活动岗位、指定学生和执行进度', '进入首页', () => {
          this.onOpenHome();
        })
        Divider().color(COLOR_BORDER)
        this.MenuItem('指导项目', '查看项目里程碑和风险上报', this.projectExists ? '进入项目' : '暂无项目', () => {
          this.onOpenProject();
        })
        Divider().color(COLOR_BORDER)
        this.MenuItem('活动记录', '签到、现场协同和服务总结', '', () => {
          this.activePanel = 'activities';
        })
      } else {
        this.MenuItem('资源审核', '审核上传内容并维护分类', '进入后台', () => {
          this.onOpenAdmin();
        })
        Divider().color(COLOR_BORDER)
        this.MenuItem('举报处理', '保存证据、隐藏内容和处理申诉', '进入后台', () => {
          this.onOpenAdmin();
        })
        Divider().color(COLOR_BORDER)
        this.MenuItem('身份认证', '审核老师和组织负责人身份', '进入后台', () => {
          this.onOpenAdmin();
        })
        Divider().color(COLOR_BORDER)
        this.MenuItem('平台统计', '查看资源、讨论和活跃度数据', '', () => {
          this.onOpenAdmin();
        })
      }
    }
    .width('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(6)
    .border({ width: 1, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  AccountSettings() {
    Column() {
      Text('账号与设置').width('100%').fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      this.MenuItem('通知设置', '截止、申请、任务和活动通知', '', () => {
        this.activePanel = 'notifications';
      })
      Divider().color(COLOR_BORDER)
      this.MenuItem('隐私与授权', '证据、联系方式和 AI 数据授权', '', () => {
        this.activePanel = 'privacy';
      })
      Divider().color(COLOR_BORDER)
      this.MenuItem('登录设备', '查看并下线已登录设备', '', () => {
        this.activePanel = 'devices';
      })
      Divider().color(COLOR_BORDER)
      this.MenuItem('帮助与反馈', '问题反馈和版本信息', '', () => {
        this.activePanel = 'feedback';
      })
      Divider().color(COLOR_BORDER)
      Button(this.resetArmed ? '再次点击确认清除' : '清除本地演示数据')
        .width('100%').height(40).fontSize(13)
        .fontColor(this.resetArmed ? COLOR_RED : COLOR_MUTED)
        .backgroundColor(this.resetArmed ? COLOR_RED_SOFT : '#F2F4F3')
        .borderRadius(4)
        .onClick(() => {
          if (this.resetArmed) {
            this.onResetDemoData();
            this.resetArmed = false;
          } else {
            this.resetArmed = true;
          }
        })
      Divider().color(COLOR_BORDER)
      Button('退出演示账号')
        .width('100%')
        .height(42)
        .fontSize(14)
        .fontColor(COLOR_RED)
        .backgroundColor(COLOR_RED_SOFT)
        .borderRadius(4)
        .onClick(() => {
          this.onLogout();
        })
    }
    .width('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(6)
    .border({ width: 1, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  ActivePanel() {
    if (this.activePanel === 'applications') {
      ProfileApplicationsPanel({
        competitionState: this.competitionApplicationState,
        activityState: this.activityApplicationState,
        onBack: () => { this.activePanel = ''; },
        onBrowse: () => {
          this.activePanel = '';
          this.onOpenHome();
        }
      })
    } else if (this.activePanel === 'activities') {
      ProfileActivityPanel({
        activityState: this.activityApplicationState,
        onBack: () => { this.activePanel = ''; },
        onBrowse: () => {
          this.activePanel = '';
          this.onOpenHome();
        }
      })
    } else if (this.activePanel === 'notifications') {
      NotificationSettingsPanel({ onBack: () => { this.activePanel = ''; } })
    } else if (this.activePanel === 'privacy') {
      PrivacySettingsPanel({ onBack: () => { this.activePanel = ''; } })
    } else if (this.activePanel === 'devices') {
      DeviceManagementPanel({ onBack: () => { this.activePanel = ''; } })
    } else {
      FeedbackPanel({ onBack: () => { this.activePanel = ''; } })
    }
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 16 }) {
          if (this.activePanel.length > 0) {
            this.ActivePanel()
          } else {
            PageTitle({
              eyebrow: '个人中心',
              title: this.accountRole === AccountRole.STUDENT ? '我的账号与校园履约记录' :
                this.accountRole === AccountRole.ADMIN ? '我的平台管理记录' : '我的指导工作与活动记录',
              description: this.accountRole === AccountRole.STUDENT ?
                '管理身份资料、能力证据、申请、队伍、项目、活动记录和隐私设置。' :
                this.accountRole === AccountRole.ADMIN ? '管理内容审核、举报处理、身份认证和平台设置。' :
                '管理身份资料、活动发布、报名审批、指导项目和隐私设置。'
            })
            this.IdentityCard()
            if (this.isEditing) {
              this.ProfileEditor()
            }
            if (this.isWide) {
              Row({ space: 10 }) {
                this.Stat(this.accountRole === AccountRole.STUDENT ? this.pendingCount().toString() : this.accountRole === AccountRole.ADMIN ? '2' : '6',
                  this.accountRole === AccountRole.STUDENT ? '待审批申请' : this.accountRole === AccountRole.ADMIN ? '待处理审核' : '待审批报名', COLOR_AMBER)
                this.Stat(this.accountRole === AccountRole.STUDENT ? (this.teamExists ? '1' : '0') : this.accountRole === AccountRole.ADMIN ? '128' : '3',
                  this.accountRole === AccountRole.STUDENT ? '参与队伍' : this.accountRole === AccountRole.ADMIN ? '今日浏览' : '已发布活动', COLOR_PRIMARY)
                this.Stat(this.accountRole === AccountRole.STUDENT ? (this.projectExists ? '3' : '0') : this.accountRole === AccountRole.ADMIN ? '4' : '4',
                  this.accountRole === AccountRole.STUDENT ? '个人任务' : this.accountRole === AccountRole.ADMIN ? '待处理举报' : '指导项目', COLOR_BLUE)
                this.Stat(this.accountRole === AccountRole.STUDENT ? this.knowledgeContributionCount.toString() : this.accountRole === AccountRole.ADMIN ? '7' : '8',
                  this.accountRole === AccountRole.STUDENT ? '知识贡献' : this.accountRole === AccountRole.ADMIN ? '资源分类' : '活动人次', COLOR_PRIMARY)
              }
              .width('100%')
            } else {
              Row({ space: 10 }) {
                this.Stat(this.pendingCount().toString(), '待审批申请', COLOR_AMBER)
                this.Stat(this.teamExists ? '1' : '0', '参与队伍', COLOR_PRIMARY)
              }
              .width('100%')
              Row({ space: 10 }) {
                this.Stat(this.projectExists ? '3' : '0', '个人任务', COLOR_BLUE)
                this.Stat(this.knowledgeContributionCount.toString(), '知识贡献', COLOR_PRIMARY)
              }
              .width('100%')
            }
            if (this.isWide) {
              Row({ space: 16 }) {
                Column({ space: 16 }) {
                  this.PersonalMenus()
                  this.AbilityPassport()
                }
                .layoutWeight(2)
                Column() {
                  this.AccountSettings()
                }
                .layoutWeight(1)
              }
              .width('100%')
              .alignItems(VerticalAlign.Top)
            } else {
              this.PersonalMenus()
              this.AbilityPassport()
              this.AccountSettings()
            }
          }
        }
        .width('100%')
        .constraintSize({ maxWidth: PAGE_MAX_WIDTH })
        .padding({ left: this.isWide ? 28 : 18, right: this.isWide ? 28 : 18, top: 22, bottom: 28 })
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
