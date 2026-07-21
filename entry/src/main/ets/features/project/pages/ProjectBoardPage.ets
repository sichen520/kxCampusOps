import { PROJECT_TASKS } from '../../../data/MockCampusData';
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
  @Prop hasProject: boolean = false;

  private todoTasks(): ProjectTask[] {
    if (this.firstTaskStarted) {
      return [PROJECT_TASKS[1], PROJECT_TASKS[2]];
    }
    return PROJECT_TASKS;
  }

  private progressTasks(): ProjectTask[] {
    if (this.firstTaskStarted) {
      return [PROJECT_TASKS[0]];
    }
    return [];
  }

  @Builder
  EmptyProject() {
    Column({ space: 12 }) {
      Text('还没有正式项目').fontSize(19).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      Text('先从一个机会完成判断、组队和团队确认，再由队长创建项目。')
        .fontSize(14).lineHeight(21).fontColor(COLOR_MUTED)
      Button('前往可行')
        .width('100%')
        .height(44)
        .fontSize(14)
        .fontColor('#FFFFFF')
        .backgroundColor(COLOR_PRIMARY)
        .borderRadius(5)
        .onClick(() => {
          this.selectedTab = 1;
        })
    }
    .width('100%')
    .padding(20)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(6)
    .border({ width: 1, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  ProjectSummary() {
    Row() {
      Column({ space: 3 }) {
        Text('鸿蒙高校创新赛项目').fontSize(18).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Text('3 个任务 · 1 个临近截止风险').fontSize(12).fontColor(COLOR_MUTED)
      }
      .alignItems(HorizontalAlign.Start)
      Blank()
      StatusPill({ text: '进行中', fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(6)
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
      if (task.id === 'task-concept' && !this.firstTaskStarted) {
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
      }
    }
    .width('100%')
    .padding(14)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(5)
    .border({ width: 1, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  BoardColumn(title: string, tasks: ProjectTask[], status: string) {
    Column({ space: 10 }) {
      Row() {
        Text(title).fontSize(15).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Blank()
        Text(tasks.length.toString()).fontSize(12).fontColor(COLOR_MUTED)
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
    .padding(12)
    .backgroundColor('#EEF1ED')
    .borderRadius(6)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  MobileTaskList() {
    ForEach(PROJECT_TASKS, (task: ProjectTask) => {
      this.TaskCard(task, task.id === 'task-concept' && this.firstTaskStarted ? '进行中' : '待办')
    }, (task: ProjectTask) => task.id)
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 16 }) {
          PageTitle({
            eyebrow: 'CampusOps',
            title: this.isWide ? '项目执行控制台' : '项目执行看板',
            description: '队长或已确认指导老师负责分工；成员在任务发布后执行本人任务，状态变化保留时间线。'
          })
          if (this.hasProject && this.taskPlanConfirmed) {
            Row({ space: 8 }) {
              StatusPill({ text: this.canManageProject ? '项目管理权限' : '成员执行权限',
                fillColor: this.canManageProject ? COLOR_PRIMARY_SOFT : COLOR_BLUE_SOFT,
                textColor: this.canManageProject ? COLOR_PRIMARY : COLOR_BLUE })
              Text(this.canManageProject ? '你可以调整任务、验收交付和处理风险。' :
                '你可以查看看板和执行本人任务，但不能修改团队分工。')
                .layoutWeight(1).fontSize(12).fontColor(COLOR_MUTED)
            }
            .width('100%').padding(12).backgroundColor(COLOR_SURFACE)
            .border({ width: 1, color: COLOR_BORDER }).borderRadius(6)
          }
          if (this.opportunityTitle.length > 0) {
            Text(`项目来源：${this.opportunityTitle}`).fontSize(14).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
          }
          if (!this.hasProject || !this.taskPlanConfirmed) {
            this.EmptyProject()
          } else {
            this.ProjectSummary()
            if (this.isWide) {
              Row({ space: 14 }) {
                this.BoardColumn('待办', this.todoTasks(), '待办')
                this.BoardColumn('进行中', this.progressTasks(), '进行中')
                this.BoardColumn('待验收', [], '待验收')
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
