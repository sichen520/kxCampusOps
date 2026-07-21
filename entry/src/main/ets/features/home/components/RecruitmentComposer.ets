import { AccountRole, DemoAccount, RecruitmentKind, RecruitmentPost } from '../../../domain/WorkflowModels';
import { accountIdForDemoAccount, canPublishRecruitment } from '../../../domain/WorkflowRules';
import { StatusPill } from '../../../shared/components/StatusPill';
import {
  COLOR_AMBER,
  COLOR_AMBER_SOFT,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  COLOR_TEXT
} from '../../../shared/Theme';

@Component
export struct RecruitmentComposer {
  @Prop defaultKind: RecruitmentKind = RecruitmentKind.COMPETITION;
  @Prop accountRole: AccountRole = AccountRole.STUDENT;
  @Prop demoAccount: DemoAccount = DemoAccount.STUDENT_APPLICANT;
  @Prop initialTitle: string = '';
  @Prop backLabel: string = '返回公开列表';
  @State title: string = '';
  @State summary: string = '';
  @State requiredRole: string = '';
  @State deadline: string = '';
  @State advisorId: string = '';
  @State advisorName: string = '';
  @State validationMessage: string = '';
  onClose: () => void = () => {};
  onPublished: (post: RecruitmentPost) => void = () => {};

  aboutToAppear(): void {
    if (this.title.length === 0 && this.initialTitle.length > 0) {
      this.title = this.initialTitle;
    }
  }

  private canPublish(): boolean {
    return canPublishRecruitment(this.accountRole, this.defaultKind);
  }

  private identityHint(): string {
    if (this.defaultKind === RecruitmentKind.COMPETITION) {
      return '学生创建组队招募后，才成为这支队伍的队长，并负责审批加入申请。';
    }
    return '校园活动由认证老师或组织负责人发布，学生报名由活动负责人审批。';
  }

  private publish(): void {
    if (this.title.trim().length === 0 || this.requiredRole.trim().length === 0 || this.deadline.trim().length === 0) {
      this.validationMessage = '请填写标题、招募岗位和截止时间。';
      return;
    }
    const post: RecruitmentPost = {
      id: `local-${Date.now()}`,
      createdBy: accountIdForDemoAccount(this.demoAccount),
      kind: this.defaultKind,
      title: this.title.trim(),
      summary: this.summary.trim().length > 0 ? this.summary.trim() : '发布者暂未填写补充说明。',
      publisher: this.demoAccount === DemoAccount.STUDENT_SECONDARY ? '王晨' :
        this.demoAccount === DemoAccount.STUDENT_APPLICANT ? '李然' : '刘老师',
      publisherRole: this.accountRole === AccountRole.STUDENT ? '学生 · 队伍创建者' : '指导老师',
      organization: this.accountRole === AccountRole.STUDENT ? '计算机与人工智能学院' : '校级创新实践中心',
      requiredRole: this.requiredRole.trim(),
      deadline: this.deadline.trim(),
      schedule: '申请通过后由负责人确认',
      location: '校内或线上，录取后通知',
      progress: this.defaultKind === RecruitmentKind.COMPETITION ? '1 / 3 名学生' : '0 个岗位已录取',
      approval: this.defaultKind === RecruitmentKind.COMPETITION ? '申请需队长批准' : '报名需负责老师批准',
      tags: this.defaultKind === RecruitmentKind.COMPETITION ? ['新发布', '比赛组队'] : ['新发布', '校园活动'],
      advisorId: this.advisorId,
      advisorName: this.advisorName,
      advisorStatus: this.advisorId.length > 0 ? '待老师接受' : '未选择'
    };
    this.onPublished(post);
  }

  build() {
    Column({ space: 16 }) {
      Button(this.backLabel)
        .height(36)
        .fontSize(13)
        .fontColor(COLOR_PRIMARY)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.onClose();
        })

      Column({ space: 8 }) {
        StatusPill({
          text: this.defaultKind,
          fillColor: COLOR_PRIMARY_SOFT,
          textColor: COLOR_PRIMARY
        })
        Text(this.defaultKind === RecruitmentKind.COMPETITION ? '发布比赛组队招募' : '发布校园活动岗位')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT)
        Text(this.identityHint()).fontSize(13).lineHeight(20).fontColor(COLOR_MUTED)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)

      if (!this.canPublish()) {
        Column({ space: 10 }) {
          StatusPill({ text: '身份权限', fillColor: COLOR_AMBER_SOFT, textColor: COLOR_AMBER })
          Text(this.defaultKind === RecruitmentKind.COMPETITION ?
            '当前是老师演示账号，不能发布学生组队招募。' :
            '当前是学生演示账号，不能发布需要老师负责审批的校园活动。')
            .fontSize(14)
            .lineHeight(22)
            .fontColor(COLOR_TEXT)
          Text('返回后退出当前账号，可在登录页选择对应的演示身份。')
            .fontSize(12)
            .fontColor(COLOR_MUTED)
        }
        .width('100%')
        .padding(18)
        .backgroundColor(COLOR_AMBER_SOFT)
        .borderRadius(6)
        .alignItems(HorizontalAlign.Start)
      } else {
        Column({ space: 12 }) {
          TextInput({ placeholder: this.defaultKind === RecruitmentKind.COMPETITION ? '比赛或项目名称' : '活动名称', text: this.title })
            .width('100%')
            .height(46)
            .backgroundColor(COLOR_SURFACE)
            .border({ width: 1, color: COLOR_BORDER })
            .borderRadius(5)
            .onChange((value: string) => {
              this.title = value;
            })
          TextArea({ placeholder: '说明当前进展、工作内容和适合参与的人', text: this.summary })
            .width('100%')
            .height(104)
            .backgroundColor(COLOR_SURFACE)
            .border({ width: 1, color: COLOR_BORDER })
            .borderRadius(5)
            .onChange((value: string) => {
              this.summary = value;
            })
          TextInput({ placeholder: this.defaultKind === RecruitmentKind.COMPETITION ? '需要的能力或队伍角色' : '需要报名的活动岗位', text: this.requiredRole })
            .width('100%')
            .height(46)
            .backgroundColor(COLOR_SURFACE)
            .border({ width: 1, color: COLOR_BORDER })
            .borderRadius(5)
            .onChange((value: string) => {
              this.requiredRole = value;
            })
          if (this.defaultKind === RecruitmentKind.COMPETITION) {
            Text('指导老师（可选）').fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
            Select([
              { value: '暂不选择指导老师' },
              { value: '刘老师 · 校级创新实践中心' },
              { value: '赵老师 · 计算机学院' }
            ])
              .width('100%').height(44)
              .value(this.advisorName.length > 0 ? this.advisorName : '暂不选择指导老师')
              .fontColor(COLOR_TEXT).backgroundColor(COLOR_SURFACE)
              .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
              .onSelect((index: number, _value: string) => {
                if (index === 1) {
                  this.advisorId = 'liuteacher';
                  this.advisorName = '刘老师';
                } else if (index === 2) {
                  this.advisorId = 'zhaoteacher';
                  this.advisorName = '赵老师';
                } else {
                  this.advisorId = '';
                  this.advisorName = '';
                }
              })
            Text('选择后会发送指导邀请；老师接受前不获得队伍管理权限。')
              .fontSize(12).lineHeight(18).fontColor(COLOR_MUTED)
          }
          Text('报名截止时间').fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
          Select([
            { value: '2026-07-24 20:00' },
            { value: '2026-07-31 20:00' },
            { value: '2026-08-10 20:00' },
            { value: '2026-08-31 18:00' }
          ])
            .width('100%')
            .height(44)
            .value(this.deadline.length > 0 ? this.deadline : '选择常用截止时间')
            .fontColor(COLOR_TEXT)
            .backgroundColor(COLOR_SURFACE)
            .border({ width: 1, color: COLOR_BORDER })
            .borderRadius(5)
            .onSelect((_index: number, value: string) => {
              this.deadline = value;
            })
          TextInput({ placeholder: '也可以自定义，例如 2026-08-10 20:00', text: this.deadline })
            .width('100%')
            .height(46)
            .backgroundColor(COLOR_SURFACE)
            .border({ width: 1, color: COLOR_BORDER })
            .borderRadius(5)
            .onChange((value: string) => {
              this.deadline = value;
            })
          if (this.validationMessage.length > 0) {
            Text(this.validationMessage).fontSize(13).fontColor(COLOR_AMBER)
          }
          Button('发布到首页')
            .width('100%')
            .height(48)
            .fontSize(15)
            .fontColor('#FFFFFF')
            .backgroundColor(COLOR_PRIMARY)
            .borderRadius(5)
            .onClick(() => {
              this.publish();
            })
        }
        .width('100%')
        .padding(18)
        .backgroundColor(COLOR_SURFACE)
        .borderRadius(6)
        .border({ width: 1, color: COLOR_BORDER })
        .alignItems(HorizontalAlign.Start)
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
