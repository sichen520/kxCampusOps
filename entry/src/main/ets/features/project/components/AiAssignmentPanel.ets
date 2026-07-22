import { PROJECT_TASKS } from '../../../data/MockCampusData';
import { ProjectTask } from '../../../domain/WorkflowModels';
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
  COLOR_TEXT
} from '../../../shared/Theme';

@Component
export struct AiAssignmentPanel {
  @Prop isWide: boolean = false;
  @Prop canManageProject: boolean = false;
  @Prop leaderName: string = '';
  @Prop memberName: string = '';
  @Prop advisorName: string = '';
  @Link projectGoal: string;
  @Link deliverable: string;
  @Link memberDetails: string;
  @Link constraints: string;
  @Link aiDraftGenerated: boolean;
  @Link firstOwner: string;
  @Link secondOwner: string;
  @Link thirdOwner: string;
  onConfirm: (tasks: ProjectTask[]) => void = (_tasks: ProjectTask[]) => {};

  private complete(): boolean {
    return this.projectGoal.trim().length > 0 && this.deliverable.trim().length > 0 &&
      this.memberDetails.trim().length > 0 && this.constraints.trim().length > 0;
  }

  private loadDemoContext(): void {
    this.projectGoal = '完成可安装的可行 CampusOps HarmonyOS Demo，跑通机会履约黄金链路。';
    this.deliverable = '7 月 24 日前完成 HAP、核心链路测试记录、5 分钟演示脚本和答辩材料。';
    this.memberDetails = `${this.leaderName.length > 0 ? this.leaderName : '队长'}负责产品统筹与最终提交；` +
      `${this.memberName.length > 0 ? this.memberName : '队员'}负责交互走查和演示表达。`;
    this.constraints = '关键任务必须保留人工确认；先保证手机和平板流程稳定，再接入额外能力。';
    this.aiDraftGenerated = false;
  }

  private options(): SelectOption[] {
    const result: SelectOption[] = [{ value: this.leaderName.length > 0 ? this.leaderName : '队长' }];
    if (this.memberName.length > 0 && this.memberName !== this.leaderName) {
      result.push({ value: this.memberName });
    }
    if (this.advisorName.length > 0) {
      result.push({ value: this.advisorName });
    }
    return result;
  }

  private owner(index: number): string {
    if (index === 0) {
      return this.firstOwner.length > 0 ? this.firstOwner : (this.leaderName.length > 0 ? this.leaderName : '队长');
    }
    if (index === 1) {
      return this.secondOwner.length > 0 ? this.secondOwner :
        (this.memberName.length > 0 ? this.memberName : (this.leaderName.length > 0 ? this.leaderName : '队长'));
    }
    return this.thirdOwner.length > 0 ? this.thirdOwner : (this.leaderName.length > 0 ? this.leaderName : '队长');
  }

  private setOwner(index: number, value: string): void {
    if (index === 0) {
      this.firstOwner = value;
    } else if (index === 1) {
      this.secondOwner = value;
    } else {
      this.thirdOwner = value;
    }
  }

  private reason(index: number): string {
    if (index === 0) {
      return '需要统筹目标、材料和最终提交，优先匹配队长的全局上下文。';
    }
    if (index === 1) {
      return this.memberName.length > 0 ? '根据成员能力证据和可投入时间匹配，建议先由成员承担主交付。' :
        '当前只有队长信息，建议补充正式成员后再确认这一项。';
    }
    return this.advisorName.length > 0 ? '指导老师可作为验收人，负责检查方向、风险和答辩材料。' :
      '尚未选择指导老师，验收角色暂由队长承担。';
  }

  private confirmedTasks(): ProjectTask[] {
    return PROJECT_TASKS.map((task: ProjectTask, index: number) => {
      const confirmedTask: ProjectTask = {
        id: task.id,
        title: task.title,
        owner: this.owner(index),
        dueDate: task.dueDate,
        acceptance: task.acceptance
      };
      return confirmedTask;
    });
  }

  @Builder
  MemberEvidence(name: string, role: string, evidence: string, color: string, fill: string) {
    Column({ space: 5 }) {
      Row() {
        Text(name).layoutWeight(1).fontSize(15).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        StatusPill({ text: role, fillColor: fill, textColor: color })
      }
      .width('100%')
      Text(evidence).fontSize(12).lineHeight(18).fontColor(COLOR_MUTED)
    }
    .width(this.isWide ? '32%' : '100%')
    .margin({ bottom: this.isWide ? 0 : 8 })
    .padding(14)
    .backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER })
    .borderRadius(4)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  ContextForm() {
    Column({ space: 10 }) {
      Row() {
        Column({ space: 3 }) {
          Text('项目上下文').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('目标、交付和限制').fontSize(12).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        StatusPill({ text: this.complete() ? '可分析' : '缺少信息',
          fillColor: this.complete() ? COLOR_PRIMARY_SOFT : COLOR_AMBER_SOFT,
          textColor: this.complete() ? COLOR_PRIMARY : COLOR_AMBER })
      }
      .width('100%')
      if (this.isWide) {
        Row({ space: 12 }) {
          Column({ space: 10 }) {
            TextArea({ placeholder: '项目目标：用户、问题、成功标准', text: this.projectGoal })
              .width('100%').height(84).backgroundColor(COLOR_SURFACE)
              .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
              .onChange((value: string) => { this.projectGoal = value; this.aiDraftGenerated = false; })
            TextArea({ placeholder: '交付物与里程碑：Demo、文档、视频、答辩材料和截止时间', text: this.deliverable })
              .width('100%').height(84).backgroundColor(COLOR_SURFACE)
              .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
              .onChange((value: string) => { this.deliverable = value; this.aiDraftGenerated = false; })
          }
          .layoutWeight(1)
          Column({ space: 10 }) {
            TextArea({ placeholder: '成员详情：姓名、能力证据、经验、时间、偏好和需要协助的部分', text: this.memberDetails })
              .width('100%').height(84).backgroundColor(COLOR_SURFACE)
              .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
              .onChange((value: string) => { this.memberDetails = value; this.aiDraftGenerated = false; })
            TextArea({ placeholder: '限制与依赖：设备、场地、指导要求、不可并行任务和风险', text: this.constraints })
              .width('100%').height(84).backgroundColor(COLOR_SURFACE)
              .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
              .onChange((value: string) => { this.constraints = value; this.aiDraftGenerated = false; })
          }
          .layoutWeight(1)
        }
        .width('100%')
        .alignItems(VerticalAlign.Top)
      } else {
        TextArea({ placeholder: '项目目标：用户、问题、成功标准', text: this.projectGoal })
          .width('100%').height(78).backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
          .onChange((value: string) => { this.projectGoal = value; this.aiDraftGenerated = false; })
        TextArea({ placeholder: '交付物与里程碑：Demo、文档、视频、答辩材料和截止时间', text: this.deliverable })
          .width('100%').height(78).backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
          .onChange((value: string) => { this.deliverable = value; this.aiDraftGenerated = false; })
        TextArea({ placeholder: '成员详情：姓名、能力证据、经验、时间、偏好和需要协助的部分', text: this.memberDetails })
          .width('100%').height(96).backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
          .onChange((value: string) => { this.memberDetails = value; this.aiDraftGenerated = false; })
        TextArea({ placeholder: '限制与依赖：设备、场地、指导要求、不可并行任务和风险', text: this.constraints })
          .width('100%').height(78).backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
          .onChange((value: string) => { this.constraints = value; this.aiDraftGenerated = false; })
      }
      Button('填入演示上下文')
        .width('100%').height(40).fontSize(13)
        .fontColor(this.canManageProject ? COLOR_BLUE : COLOR_MUTED)
        .backgroundColor(this.canManageProject ? COLOR_BLUE_SOFT : '#E4E8E5')
        .borderRadius(5).enabled(this.canManageProject)
        .onClick(() => { this.loadDemoContext(); })
    }
    .width('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER })
    .borderRadius(4)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  AnalysisConfig() {
    Column({ space: 10 }) {
      Row() {
        Column({ space: 3 }) {
          Text('分析侧重点').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('生成后仍需负责人确认').fontSize(12).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        Text('4 项已启用').fontSize(12).fontColor(COLOR_BLUE)
      }
      .width('100%')
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
        ForEach(['能力互补', '时间重合', '负载均衡', '关键路径'], (item: string) => {
          Text(item).fontSize(12).fontColor(COLOR_BLUE).backgroundColor(COLOR_BLUE_SOFT)
            .borderRadius(4).padding({ left: 10, right: 10, top: 7, bottom: 7 })
            .margin({ right: 8, bottom: 8 })
        }, (item: string) => item)
      }
      .width('100%')
      Button(this.complete() ? '生成可解释的分工建议' : '补齐信息后生成建议')
        .width('100%').height(46).fontSize(14)
        .fontColor(this.canManageProject && this.complete() ? '#FFFFFF' : COLOR_MUTED)
        .backgroundColor(this.canManageProject && this.complete() ? COLOR_PRIMARY : '#E4E8E5')
        .borderRadius(5).enabled(this.canManageProject && this.complete())
        .onClick(() => { this.aiDraftGenerated = true; })
    }
    .width('100%')
    .padding(18)
    .backgroundColor('#F8FBFA')
    .border({ width: 1, color: COLOR_PRIMARY })
    .borderRadius(4)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  ResultPanel() {
    Column({ space: 12 }) {
      Row() {
        Column({ space: 3 }) {
          Text('AI 分工建议').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('核对负责人和风险后发布').fontSize(12).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        StatusPill({ text: '待负责人确认', fillColor: COLOR_AMBER_SOFT, textColor: COLOR_AMBER })
      }
      .width('100%')
      Row({ space: 8 }) {
        Text('3 个任务').fontSize(12).fontColor(COLOR_PRIMARY).backgroundColor(COLOR_PRIMARY_SOFT)
          .borderRadius(4).padding(8)
        Text('2 个高匹配').fontSize(12).fontColor(COLOR_BLUE).backgroundColor(COLOR_BLUE_SOFT)
          .borderRadius(4).padding(8)
        Text('1 项待确认').fontSize(12).fontColor(COLOR_AMBER).backgroundColor(COLOR_AMBER_SOFT)
          .borderRadius(4).padding(8)
      }
      .width('100%')
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(PROJECT_TASKS, (task: ProjectTask, index: number) => {
          Column({ space: 8 }) {
            Row() {
              Text(task.title).layoutWeight(1).fontSize(15).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
              StatusPill({ text: index === 2 ? '待确认' : '高匹配',
                fillColor: index === 2 ? COLOR_AMBER_SOFT : COLOR_PRIMARY_SOFT,
                textColor: index === 2 ? COLOR_AMBER : COLOR_PRIMARY })
            }
            .width('100%')
            Text(this.reason(index)).fontSize(12).lineHeight(18).fontColor(COLOR_MUTED)
            Row({ space: 8 }) {
              Text('负责人').fontSize(12).fontColor(COLOR_MUTED)
              Select(this.options()).layoutWeight(1).height(36).value(this.owner(index))
                .backgroundColor(COLOR_SURFACE).border({ width: 1, color: COLOR_BORDER }).borderRadius(4)
                .onSelect((_optionIndex: number, value: string) => { this.setOwner(index, value); })
            }
            .width('100%')
          }
          .width(this.isWide ? '32%' : '100%').padding(14).margin({ bottom: 10 })
          .backgroundColor(COLOR_SURFACE).border({ width: 1, color: COLOR_BORDER }).borderRadius(4)
          .alignItems(HorizontalAlign.Start)
        }, (task: ProjectTask) => task.id)
      }
      .width('100%')
      Button('确认建议并发布到项目看板')
        .width('100%').height(46).fontSize(14).fontColor(this.canManageProject ? '#FFFFFF' : COLOR_MUTED)
        .backgroundColor(this.canManageProject ? COLOR_PRIMARY : '#E4E8E5').borderRadius(5)
        .enabled(this.canManageProject).onClick(() => { this.onConfirm(this.confirmedTasks()); })
    }
    .width('100%').padding(18).backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER }).borderRadius(4).alignItems(HorizontalAlign.Start)
  }

  build() {
    Column({ space: 14 }) {
      this.ContextForm()
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        this.MemberEvidence(this.leaderName.length > 0 ? this.leaderName : '队长', '统筹', '目标确认、材料整理、最终提交', COLOR_PRIMARY, COLOR_PRIMARY_SOFT)
        if (this.memberName.length > 0) {
          this.MemberEvidence(this.memberName, '成员', '能力证据由申请人授权后提供', COLOR_BLUE, COLOR_BLUE_SOFT)
        }
        if (this.advisorName.length > 0) {
          this.MemberEvidence(this.advisorName, '指导', '方向把关、风险和交付验收', COLOR_AMBER, COLOR_AMBER_SOFT)
        }
      }
      .width('100%')
      if (!this.aiDraftGenerated) {
        this.AnalysisConfig()
      } else {
        this.ResultPanel()
      }
    }
    .width('100%').alignItems(HorizontalAlign.Start)
  }
}
