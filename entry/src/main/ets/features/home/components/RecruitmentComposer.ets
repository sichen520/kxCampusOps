import { AccountRole, DemoAccount, RecruitmentKind, RecruitmentPost } from '../../../domain/WorkflowModels';
import { accountIdForDemoAccount, canPublishRecruitment } from '../../../domain/WorkflowRules';
import {
  COLOR_AMBER,
  COLOR_AMBER_SOFT,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
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
  @Prop isWide: boolean = false;
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
      return '发布后你将成为队伍创建者，并负责处理加入申请。';
    }
    return '活动岗位由负责老师发布并审批报名。';
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

  @Builder
  FieldLabel(label: string, required: boolean = false) {
    Row({ space: 4 }) {
      Text(label).fontSize(12).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
      if (required) {
        Text('必填').fontSize(10).fontColor(COLOR_AMBER)
      }
    }
  }

  @Builder
  BasicFields() {
    Column({ space: 9 }) {
      Text('招募内容')
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT)
        .margin({ bottom: 3 })
      this.FieldLabel(this.defaultKind === RecruitmentKind.COMPETITION ? '比赛或项目名称' : '活动名称', true)
      TextInput({ placeholder: '输入清晰、可识别的名称', text: this.title })
        .width('100%')
        .height(44)
        .fontSize(13)
        .backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_BORDER })
        .borderRadius(4)
        .onChange((value: string) => {
          this.title = value;
        })
      this.FieldLabel('工作说明')
      TextArea({ placeholder: '写明当前进展、具体工作和适合参与的人', text: this.summary })
        .width('100%')
        .height(124)
        .fontSize(13)
        .backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_BORDER })
        .borderRadius(4)
        .onChange((value: string) => {
          this.summary = value;
        })
      this.FieldLabel(this.defaultKind === RecruitmentKind.COMPETITION ? '需要的能力或队伍角色' : '开放岗位', true)
      TextInput({ placeholder: this.defaultKind === RecruitmentKind.COMPETITION ?
        '例如：产品设计 / 交互表达' : '例如：现场协助 / 技术答疑', text: this.requiredRole })
        .width('100%')
        .height(44)
        .fontSize(13)
        .backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_BORDER })
        .borderRadius(4)
        .onChange((value: string) => {
          this.requiredRole = value;
        })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  PublishSettings() {
    Column({ space: 9 }) {
      Text('发布设置')
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT)
        .margin({ bottom: 3 })
      if (this.defaultKind === RecruitmentKind.COMPETITION) {
        this.FieldLabel('指导老师')
        Select([
          { value: '暂不选择指导老师' },
          { value: '刘老师 · 校级创新实践中心' },
          { value: '赵老师 · 计算机学院' }
        ])
          .width('100%')
          .height(42)
          .value(this.advisorName.length > 0 ? this.advisorName : '暂不选择指导老师')
          .fontColor(COLOR_TEXT)
          .backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER })
          .borderRadius(4)
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
        Text('老师接受邀请后可协助管理队伍。')
          .fontSize(11)
          .lineHeight(17)
          .fontColor(COLOR_MUTED)
      }
      this.FieldLabel('报名截止时间', true)
      Select([
        { value: '2026-07-24 20:00' },
        { value: '2026-07-31 20:00' },
        { value: '2026-08-10 20:00' },
        { value: '2026-08-31 18:00' }
      ])
        .width('100%')
        .height(42)
        .value(this.deadline.length > 0 ? this.deadline : '选择常用时间')
        .fontColor(COLOR_TEXT)
        .backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_BORDER })
        .borderRadius(4)
        .onSelect((_index: number, value: string) => {
          this.deadline = value;
        })
      TextInput({ placeholder: '或输入自定义时间', text: this.deadline })
        .width('100%')
        .height(42)
        .fontSize(12)
        .backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_BORDER })
        .borderRadius(4)
        .onChange((value: string) => {
          this.deadline = value;
        })
      Column({ space: 5 }) {
        Text('审批').fontSize(11).fontColor(COLOR_MUTED)
        Text(this.defaultKind === RecruitmentKind.COMPETITION ? '加入申请由队长处理' : '岗位报名由负责老师处理')
          .fontSize(12)
          .fontColor(COLOR_TEXT)
      }
      .width('100%')
      .padding({ top: 3, bottom: 3 })
      .alignItems(HorizontalAlign.Start)
      if (this.validationMessage.length > 0) {
        Text(this.validationMessage)
          .width('100%')
          .padding({ left: 10, right: 10, top: 8, bottom: 8 })
          .fontSize(12)
          .fontColor(COLOR_AMBER)
          .backgroundColor(COLOR_AMBER_SOFT)
          .border({ width: { left: 3 }, color: COLOR_AMBER })
      }
      Button('发布到机会工作台')
        .width('100%')
        .height(44)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#FFFFFF')
        .backgroundColor(COLOR_PRIMARY)
        .borderRadius(4)
        .margin({ top: 3 })
        .onClick(() => {
          this.publish();
        })
    }
    .width(this.isWide ? 330 : '100%')
    .padding(this.isWide ? { left: 24, bottom: 4 } : { top: 20, bottom: 4 })
    .alignItems(HorizontalAlign.Start)
    .border(this.isWide ? { width: { left: 1 }, color: COLOR_BORDER } :
      { width: { top: 1 }, color: COLOR_BORDER })
  }

  build() {
    Column({ space: 16 }) {
      Text(this.backLabel)
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
        .fontColor(COLOR_PRIMARY)
        .onClick(() => {
          this.onClose();
        })

      Column({ space: 7 }) {
        Text(this.defaultKind)
          .fontSize(11)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_PRIMARY)
        Text(this.defaultKind === RecruitmentKind.COMPETITION ? '发布比赛组队招募' : '发布校园活动岗位')
          .fontSize(this.isWide ? 25 : 22)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT)
        Text(this.identityHint()).fontSize(12).lineHeight(18).fontColor(COLOR_MUTED)
      }
      .width('100%')
      .padding({ bottom: 14 })
      .alignItems(HorizontalAlign.Start)
      .border({ width: { bottom: 1 }, color: COLOR_BORDER })

      if (!this.canPublish()) {
        Column({ space: 8 }) {
          Text('当前身份不能发布')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_AMBER)
          Text(this.defaultKind === RecruitmentKind.COMPETITION ?
            '老师账号不能发布学生组队招募。' : '学生账号不能发布由老师审批的校园活动。')
            .fontSize(13)
            .lineHeight(20)
            .fontColor(COLOR_TEXT)
          Text('返回并切换对应演示身份后再试。').fontSize(11).fontColor(COLOR_MUTED)
        }
        .width('100%')
        .padding({ left: 14, right: 14, top: 14, bottom: 14 })
        .backgroundColor(COLOR_AMBER_SOFT)
        .border({ width: { left: 3 }, color: COLOR_AMBER })
        .alignItems(HorizontalAlign.Start)
      } else if (this.isWide) {
        Row() {
          Column() {
            this.BasicFields()
          }
          .layoutWeight(1)
          .padding({ right: 24 })
          this.PublishSettings()
        }
        .width('100%')
        .alignItems(VerticalAlign.Top)
      } else {
        Column() {
          this.BasicFields()
          this.PublishSettings()
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
