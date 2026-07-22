import { ProjectTask, WorkflowStep } from '../../../domain/WorkflowModels';
import { PageTitle } from '../../../shared/components/PageTitle';
import { StatusPill } from '../../../shared/components/StatusPill';
import {
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
export struct ProjectBoardPage {
  @Link selectedTab: number;
  @Link workflowStep: WorkflowStep;
  @Link taskPlanConfirmed: boolean;
  @Link firstTaskStarted: boolean;
  @Prop opportunityTitle: string = '';
  @Prop isWide: boolean = false;
  @Prop canManageProject: boolean = false;
  @Prop currentTaskOwnerName: string = '';
  @Prop hasTeam: boolean = false;
  @Prop teamConfirmed: boolean = false;
  @Prop hasProject: boolean = false;
  @Prop tasks: ProjectTask[] = [];

  private todoTasks(): ProjectTask[] {
    if (this.firstTaskStarted) {
      return this.tasks.filter((_task: ProjectTask, index: number) => index > 0);
    }
    return this.tasks;
  }

  private progressTasks(): ProjectTask[] {
    if (this.firstTaskStarted && this.tasks.length > 0) {
      return [this.tasks[0]];
    }
    return [];
  }

  private firstTaskId(): string {
    return this.tasks.length > 0 ? this.tasks[0].id : '';
  }

  private canStartTask(task: ProjectTask): boolean {
    return this.canManageProject ||
      (this.currentTaskOwnerName.length > 0 && task.owner === this.currentTaskOwnerName);
  }

  @Builder
  EmptyProject() {
    Column({ space: 12 }) {
      Text(this.hasTeam && !this.teamConfirmed ? '队伍尚未正式成立' : '还没有正式项目')
        .fontSize(19).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      Text(this.hasTeam && !this.teamConfirmed ?
        '申请获批后，还需要队伍创建者确认团队成立。完成确认后才能创建项目。' :
        '先从一个机会完成判断、组队和团队确认，再由队长创建项目。')
        .fontSize(14).lineHeight(21).fontColor(COLOR_MUTED)
      Button(this.hasTeam && !this.teamConfirmed ? '前往队伍确认' : '前往可行')
        .width('100%')
        .height(44)
        .fontSize(14)
        .fontColor('#FFFFFF')
        .backgroundColor(COLOR_PRIMARY)
        .borderRadius(5)
        .onClick(() => {
          this.selectedTab = this.hasTeam && !this.teamConfirmed ? 3 : 1;
        })
    }
    .width('100%')
    .padding({ left: 18, right: 18, top: 20, bottom: 20 })
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(4)
    .border({ width: 1, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  ProjectSummary() {
    Row() {
      Column({ space: 3 }) {
        Text(this.opportunityTitle.length > 0 ? this.opportunityTitle : 'CampusOps 项目')
          .fontSize(18).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Text(`${this.tasks.length} 个任务 · 分工已由负责人确认`).fontSize(12).fontColor(COLOR_MUTED)
      }
      .alignItems(HorizontalAlign.Start)
      Blank()
      StatusPill({ text: '进行中', fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 13, bottom: 13 })
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(4)
    .border({ width: 1, color: COLOR_BORDER })
  }

  @Builder
  TaskCard(task: ProjectTask, status: string) {
    Column({ space: 9 }) {
      Row() {
        Text(task.title).layoutWeight(1).fontSize(15).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        StatusPill({
          text: status,
          fillColor: status === '进行中' ? COLOR_BLUE_SOFT : '#EEF0ED',
          textColor: status === '进行中' ? COLOR_BLUE : COLOR_MUTED
        })
      }
      .width('100%')
      Text(`${task.owner} · ${task.dueDate}`).fontSize(12).fontColor(COLOR_MUTED)
      Text(`验收：${task.acceptance}`).fontSize(12).lineHeight(18).fontColor(COLOR_MUTED)
      if (task.id === this.firstTaskId() && !this.firstTaskStarted && this.canStartTask(task)) {
        Button('开始任务')
          .width('100%')
          .height(36)
          .fontSize(13)
          .fontColor(COLOR_PRIMARY)
          .backgroundColor(COLOR_PRIMARY_SOFT)
          .borderRadius(4)
          .onClick(() => {
            this.firstTaskStarted = true;
          })
      } else if (task.id === this.firstTaskId() && !this.firstTaskStarted) {
        Text(`等待 ${task.owner} 开始任务`).fontSize(12).fontColor(COLOR_BLUE)
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(4)
    .border({ width: 1, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  BoardColumn(title: string, tasks: ProjectTask[], status: string) {
    Column({ space: 8 }) {
      Row() {
        Text(title).fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        Blank()
        Text(tasks.length.toString())
          .width(24).height(22).textAlign(TextAlign.Center).padding({ top: 3 })
          .fontSize(11).fontColor(COLOR_MUTED).backgroundColor(COLOR_SURFACE).borderRadius(3)
      }
      .width('100%')
      if (tasks.length === 0) {
        Text('暂无任务')
          .width('100%')
          .height(72)
          .textAlign(TextAlign.Center)
          .fontSize(13)
          .fontColor(COLOR_MUTED)
          .padding({ top: 25 })
      } else {
        ForEach(tasks, (task: ProjectTask) => {
          this.TaskCard(task, status)
        }, (task: ProjectTask) => task.id)
      }
    }
    .layoutWeight(1)
    .padding(10)
    .backgroundColor('#F1F3F2')
    .border({ width: 1, color: COLOR_BORDER })
    .borderRadius(4)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  MobileTaskList() {
    ForEach(this.tasks, (task: ProjectTask) => {
      this.TaskCard(task, task.id === this.firstTaskId() && this.firstTaskStarted ? '进行中' : '待办')
    }, (task: ProjectTask) => task.id)
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 16 }) {
          PageTitle({
            eyebrow: 'CampusOps',
            title: this.isWide ? '项目执行控制台' : '项目执行看板',
            description: '任务、负责人、截止时间和验收条件保持在同一视图。'
          })
          if (this.hasProject && this.taskPlanConfirmed) {
            Row({ space: 8 }) {
              StatusPill({ text: this.canManageProject ? '项目管理权限' : '成员执行权限',
                fillColor: this.canManageProject ? COLOR_PRIMARY_SOFT : COLOR_BLUE_SOFT,
                textColor: this.canManageProject ? COLOR_PRIMARY : COLOR_BLUE })
              Text(this.canManageProject ? '你可以调整任务、验收交付和处理风险。' :
                '只显示与你相关的执行权限。')
                .layoutWeight(1).fontSize(12).fontColor(COLOR_MUTED)
            }
            .width('100%').padding({ left: 12, right: 12, top: 9, bottom: 9 })
            .backgroundColor(COLOR_SURFACE)
            .border({ width: 1, color: COLOR_BORDER }).borderRadius(4)
          }
          if (!this.hasProject || !this.taskPlanConfirmed) {
            this.EmptyProject()
          } else {
            this.ProjectSummary()
            if (this.isWide) {
              Row({ space: 10 }) {
                this.BoardColumn('待整理', [], '待整理')
                this.BoardColumn('待开始', this.todoTasks(), '待开始')
                this.BoardColumn('进行中', this.progressTasks(), '进行中')
                this.BoardColumn('已完成', [], '已完成')
              }
              .width('100%')
              .alignItems(VerticalAlign.Top)
            } else {
              this.MobileTaskList()
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
