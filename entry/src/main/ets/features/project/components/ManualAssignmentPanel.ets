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
export struct ManualAssignmentPanel {
  @Prop isWide: boolean = false;
  @Prop canManageProject: boolean = false;
  @Prop leaderName: string = '';
  @Prop memberName: string = '';
  @Prop advisorName: string = '';
  @Link projectGoal: string;
  @Link deliverable: string;
  @Link memberDetails: string;
  @Link constraints: string;
  @Link firstOwner: string;
  @Link secondOwner: string;
  @Link thirdOwner: string;
  onConfirm: (tasks: ProjectTask[]) => void = (_tasks: ProjectTask[]) => {};
  @State selectedTaskIndex: number = 0;
  @State editedTitles: string[] = [];
  @State editedOwners: string[] = [];
  @State editedDeadlines: string[] = [];
  @State editedAcceptances: string[] = [];
  @State editedPriorities: string[] = [];
  @State draftTitle: string = '';
  @State draftOwner: string = '';
  @State draftDeadline: string = '';
  @State draftAcceptance: string = '';
  @State draftPriority: string = '重要';
  @State saveMessage: string = '';

  aboutToAppear(): void {
    this.editedTitles = PROJECT_TASKS.map((task: ProjectTask) => task.title);
    this.editedOwners = PROJECT_TASKS.map((task: ProjectTask, index: number) => this.defaultOwner(index));
    this.editedDeadlines = PROJECT_TASKS.map((task: ProjectTask) => task.dueDate);
    this.editedAcceptances = PROJECT_TASKS.map((task: ProjectTask) => task.acceptance);
    this.editedPriorities = PROJECT_TASKS.map((_task: ProjectTask, index: number) => index === 0 ? '重要' : '普通');
    this.loadTask(0);
  }

  private defaultOwner(index: number): string {
    if (index === 0) {
      return this.leaderName.length > 0 ? this.leaderName : '队长';
    }
    if (index === 1 && this.memberName.length > 0) {
      return this.memberName;
    }
    return this.leaderName.length > 0 ? this.leaderName : '队长';
  }

  private memberOptions(): SelectOption[] {
    const result: SelectOption[] = [{ value: this.leaderName.length > 0 ? this.leaderName : '队长' }];
    if (this.memberName.length > 0 && this.memberName !== this.leaderName) {
      result.push({ value: this.memberName });
    }
    if (this.advisorName.length > 0) {
      result.push({ value: this.advisorName });
    }
    return result;
  }

  private loadTask(index: number): void {
    this.selectedTaskIndex = index;
    this.draftTitle = this.editedTitles[index] === undefined ? PROJECT_TASKS[index].title : this.editedTitles[index];
    this.draftOwner = this.editedOwners[index] === undefined ? this.defaultOwner(index) : this.editedOwners[index];
    this.draftDeadline = this.editedDeadlines[index] === undefined ? PROJECT_TASKS[index].dueDate : this.editedDeadlines[index];
    this.draftAcceptance = this.editedAcceptances[index] === undefined ? PROJECT_TASKS[index].acceptance : this.editedAcceptances[index];
    this.draftPriority = this.editedPriorities[index] === undefined ? '普通' : this.editedPriorities[index];
    this.saveMessage = '';
  }

  private saveCurrent(): void {
    const titles: string[] = this.editedTitles.slice();
    const owners: string[] = this.editedOwners.slice();
    const deadlines: string[] = this.editedDeadlines.slice();
    const acceptances: string[] = this.editedAcceptances.slice();
    const priorities: string[] = this.editedPriorities.slice();
    titles[this.selectedTaskIndex] = this.draftTitle.trim();
    owners[this.selectedTaskIndex] = this.draftOwner;
    deadlines[this.selectedTaskIndex] = this.draftDeadline.trim();
    acceptances[this.selectedTaskIndex] = this.draftAcceptance.trim();
    priorities[this.selectedTaskIndex] = this.draftPriority;
    this.editedTitles = titles;
    this.editedOwners = owners;
    this.editedDeadlines = deadlines;
    this.editedAcceptances = acceptances;
    this.editedPriorities = priorities;
    this.syncOwnerLink();
    this.saveMessage = '当前任务草稿已保存';
  }

  private syncOwnerLink(): void {
    this.firstOwner = this.editedOwners.length > 0 ? this.editedOwners[0] : '';
    this.secondOwner = this.editedOwners.length > 1 ? this.editedOwners[1] : '';
    this.thirdOwner = this.editedOwners.length > 2 ? this.editedOwners[2] : '';
  }

  private canPublish(): boolean {
    return this.canManageProject && this.projectGoal.trim().length > 0 && this.deliverable.trim().length > 0 &&
      this.editedTitles.every((title: string) => title.trim().length > 0) &&
      this.editedOwners.every((owner: string) => owner.trim().length > 0) &&
      this.editedDeadlines.every((deadline: string) => deadline.trim().length > 0) &&
      this.editedAcceptances.every((acceptance: string) => acceptance.trim().length > 0);
  }

  private confirmedTasks(): ProjectTask[] {
    return PROJECT_TASKS.map((task: ProjectTask, index: number) => {
      const confirmedTask: ProjectTask = {
        id: task.id,
        title: this.editedTitles[index],
        owner: this.editedOwners[index],
        dueDate: this.editedDeadlines[index],
        acceptance: this.editedAcceptances[index]
      };
      return confirmedTask;
    });
  }

  private publishTasks(): void {
    this.saveCurrent();
    if (this.canPublish()) {
      this.onConfirm(this.confirmedTasks());
    }
  }

  private workload(name: string): number {
    return this.editedOwners.filter((owner: string) => owner === name).length;
  }

  @Builder
  ProjectBrief() {
    Column({ space: 10 }) {
      Row() {
        Column({ space: 3 }) {
          Text('项目边界').fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('人工分工也要先明确交付目标，避免只按个人喜好分任务。').fontSize(12).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        StatusPill({ text: this.projectGoal.length > 0 && this.deliverable.length > 0 ? '已定义' : '待填写',
          fillColor: this.projectGoal.length > 0 && this.deliverable.length > 0 ? COLOR_PRIMARY_SOFT : COLOR_AMBER_SOFT,
          textColor: this.projectGoal.length > 0 && this.deliverable.length > 0 ? COLOR_PRIMARY : COLOR_AMBER })
      }
      .width('100%')
      TextInput({ placeholder: '项目目标和成功标准', text: this.projectGoal })
        .width('100%').height(42).backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
        .onChange((value: string) => { this.projectGoal = value; })
      TextArea({ placeholder: '交付物、里程碑和不可违反的限制', text: this.deliverable })
        .width('100%').height(72).backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
        .onChange((value: string) => { this.deliverable = value; })
    }
    .width('100%').padding(18).backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER }).borderRadius(4).alignItems(HorizontalAlign.Start)
  }

  @Builder
  TaskList() {
    Column({ space: 8 }) {
      Row() {
        Column({ space: 3 }) {
          Text('任务清单').fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('逐项选择任务后在右侧编辑').fontSize(12).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        Text(`${PROJECT_TASKS.length} 项`).fontSize(12).fontColor(COLOR_MUTED)
      }
      .width('100%')
      ForEach(PROJECT_TASKS, (task: ProjectTask, index: number) => {
        Row({ space: 10 }) {
          Column().width(4).height(42).backgroundColor(this.selectedTaskIndex === index ? COLOR_PRIMARY : COLOR_BORDER)
            .borderRadius(2)
          Column({ space: 4 }) {
            Text(this.editedTitles[index] === undefined ? task.title : this.editedTitles[index])
              .fontSize(14).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
            Text(`${this.editedOwners[index] === undefined ? this.defaultOwner(index) : this.editedOwners[index]} · ${this.editedPriorities[index] === undefined ? '普通' : this.editedPriorities[index]}`)
              .fontSize(12).fontColor(COLOR_MUTED)
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Start)
          Text('编辑').fontSize(12).fontColor(COLOR_PRIMARY)
        }
        .width('100%').padding(10)
        .backgroundColor(this.selectedTaskIndex === index ? COLOR_PRIMARY_SOFT : COLOR_SURFACE)
        .borderRadius(5)
        .onClick(() => { this.saveCurrent(); this.loadTask(index); })
      }, (task: ProjectTask) => task.id)
    }
    .width('100%').padding(18).backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER }).borderRadius(4).alignItems(HorizontalAlign.Start)
  }

  @Builder
  TaskEditor() {
    Column({ space: 11 }) {
      Row() {
        Column({ space: 3 }) {
          Text('任务编辑').fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text(`第 ${this.selectedTaskIndex + 1} 项，共 ${PROJECT_TASKS.length} 项`).fontSize(12).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        StatusPill({ text: '人工指定', fillColor: COLOR_BLUE_SOFT, textColor: COLOR_BLUE })
      }
      .width('100%')
      TextInput({ placeholder: '任务名称', text: this.draftTitle })
        .width('100%').height(42).backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
        .onChange((value: string) => { this.draftTitle = value; })
      Row({ space: 10 }) {
        Column({ space: 5 }) {
          Text('负责人').fontSize(12).fontColor(COLOR_MUTED)
          Select(this.memberOptions()).width('100%').height(38).value(this.draftOwner)
            .backgroundColor(COLOR_SURFACE).border({ width: 1, color: COLOR_BORDER }).borderRadius(4)
            .onSelect((_index: number, value: string) => { this.draftOwner = value; })
        }
        .layoutWeight(1).alignItems(HorizontalAlign.Start)
        Column({ space: 5 }) {
          Text('截止时间').fontSize(12).fontColor(COLOR_MUTED)
          Select([{ value: '07-21 20:00' }, { value: '07-22 22:00' }, { value: '07-24 18:00' }])
            .width('100%').height(38).value(this.draftDeadline)
            .backgroundColor(COLOR_SURFACE).border({ width: 1, color: COLOR_BORDER }).borderRadius(4)
            .onSelect((_index: number, value: string) => { this.draftDeadline = value; })
        }
        .layoutWeight(1).alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      Text('优先级').fontSize(12).fontColor(COLOR_MUTED)
      Row({ space: 8 }) {
        ForEach(['重要', '普通', '可延后'], (priority: string) => {
          Button(priority).layoutWeight(1).height(34).fontSize(12)
            .fontColor(this.draftPriority === priority ? COLOR_PRIMARY : COLOR_MUTED)
            .backgroundColor(this.draftPriority === priority ? COLOR_PRIMARY_SOFT : COLOR_SURFACE)
            .border({ width: 1, color: this.draftPriority === priority ? COLOR_PRIMARY : COLOR_BORDER })
            .borderRadius(4).onClick(() => { this.draftPriority = priority; })
        }, (priority: string) => priority)
      }
      .width('100%')
      TextArea({ placeholder: '验收条件：完成到什么程度才算通过', text: this.draftAcceptance })
        .width('100%').height(82).backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
        .onChange((value: string) => { this.draftAcceptance = value; })
      Button('保存当前任务')
        .width('100%').height(42).fontSize(13).fontColor(COLOR_PRIMARY)
        .backgroundColor(COLOR_PRIMARY_SOFT).borderRadius(5)
        .onClick(() => { this.saveCurrent(); })
      if (this.saveMessage.length > 0) {
        Text(this.saveMessage).fontSize(12).fontColor(COLOR_PRIMARY)
      }
    }
    .width('100%').padding(18).backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER }).borderRadius(4).alignItems(HorizontalAlign.Start)
  }

  @Builder
  WorkloadPanel() {
    Column({ space: 9 }) {
      Row() {
        Text('成员负载').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Blank()
        Text('发布前检查').fontSize(12).fontColor(COLOR_MUTED)
      }
      .width('100%')
      ForEach(this.memberOptions(), (option: SelectOption) => {
        Row() {
          Text(option.value as string).layoutWeight(1).fontSize(13).fontColor(COLOR_TEXT)
          Text(`${this.workload(option.value as string)} 项`).fontSize(12).fontColor(COLOR_MUTED)
        }
        .width('100%').padding({ top: 7, bottom: 7 })
      }, (option: SelectOption) => option.value as string)
      Text(this.canPublish() ? '目标、交付物、负责人和任务内容均已具备。' :
        '还需要补齐项目目标、交付物、任务名称和负责人。')
        .fontSize(12).lineHeight(18).fontColor(this.canPublish() ? COLOR_PRIMARY : COLOR_AMBER)
    }
    .width('100%').padding(16).backgroundColor('#F8FBFA')
    .border({ width: 1, color: COLOR_BORDER }).borderRadius(4).alignItems(HorizontalAlign.Start)
  }

  build() {
    Column({ space: 14 }) {
      this.ProjectBrief()
      if (this.isWide) {
        Row({ space: 14 }) {
          Column() { this.TaskList() }.width('34%')
          Column() { this.TaskEditor() }.layoutWeight(1)
        }
        .width('100%').alignItems(VerticalAlign.Top)
      } else {
        this.TaskList()
        this.TaskEditor()
      }
      this.WorkloadPanel()
      Button('确认人工分工并发布到项目看板')
        .width('100%').height(46).fontSize(14)
        .fontColor(this.canPublish() ? '#FFFFFF' : COLOR_MUTED)
        .backgroundColor(this.canPublish() ? COLOR_PRIMARY : '#E4E8E5').borderRadius(5)
        .enabled(this.canPublish()).onClick(() => { this.publishTasks(); })
    }
    .width('100%').alignItems(HorizontalAlign.Start)
  }
}
