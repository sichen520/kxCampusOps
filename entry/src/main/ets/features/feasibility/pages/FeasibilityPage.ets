import { FEASIBILITY_ITEMS } from '../../../data/MockCampusData';
import { AccountRole, FeasibilityItem, FeasibilityState, WorkflowStep } from '../../../domain/WorkflowModels';
import { StatusPill } from '../../../shared/components/StatusPill';
import { WorkflowHeader } from '../../../shared/components/WorkflowHeader';
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
  COLOR_SURFACE_ALT,
  COLOR_TEXT,
  PAGE_MAX_WIDTH
} from '../../../shared/Theme';

@Component
export struct FeasibilityPage {
  @Link workflowStep: WorkflowStep;
  @Link personalPlanCreated: boolean;
  @Prop opportunityTitle: string = '';
  @Prop isWide: boolean = false;
  @Prop accountRole: AccountRole = AccountRole.STUDENT;

  private stateBackground(state: FeasibilityState): string {
    if (state === FeasibilityState.MET) {
      return COLOR_PRIMARY_SOFT;
    }
    if (state === FeasibilityState.MISSING) {
      return COLOR_RED_SOFT;
    }
    if (state === FeasibilityState.RISK) {
      return COLOR_AMBER_SOFT;
    }
    return COLOR_BLUE_SOFT;
  }

  private stateColor(state: FeasibilityState): string {
    if (state === FeasibilityState.MET) {
      return COLOR_PRIMARY;
    }
    if (state === FeasibilityState.MISSING) {
      return COLOR_RED;
    }
    if (state === FeasibilityState.RISK) {
      return COLOR_AMBER;
    }
    return COLOR_BLUE;
  }

  private metCount(): number {
    return FEASIBILITY_ITEMS.filter((item: FeasibilityItem) => item.state === FeasibilityState.MET).length;
  }

  private pendingCount(): number {
    return FEASIBILITY_ITEMS.length - this.metCount();
  }

  @Builder
  DesktopHeader() {
    Row() {
      Text('要求项').width('23%').fontSize(12).fontColor(COLOR_MUTED)
      Text('判断结果').width('18%').fontSize(12).fontColor(COLOR_MUTED)
      Text('原文与个人证据').width('34%').fontSize(12).fontColor(COLOR_MUTED)
      Text('下一步行动').width('25%').fontSize(12).fontColor(COLOR_MUTED)
    }
    .width('100%')
    .height(42)
    .padding({ left: 16, right: 16 })
    .backgroundColor(COLOR_SURFACE_ALT)
    .border({ width: { top: 1, bottom: 1 }, color: COLOR_BORDER })
  }

  @Builder
  DesktopRow(item: FeasibilityItem) {
    Row() {
      Column({ space: 4 }) {
        Text(item.title).fontSize(14).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        Text(item.id.toUpperCase()).fontSize(10).fontColor(COLOR_MUTED)
      }
      .width('23%')
      .padding({ right: 14 })
      .alignItems(HorizontalAlign.Start)

      Column({ space: 5 }) {
        StatusPill({
          text: item.state,
          fillColor: this.stateBackground(item.state),
          textColor: this.stateColor(item.state)
        })
        Text(item.state === FeasibilityState.MET ? '条件已具备' : '需要处理')
          .fontSize(11).fontColor(COLOR_MUTED)
      }
      .width('18%')
      .alignItems(HorizontalAlign.Start)

      Text(item.evidence)
        .width('34%')
        .padding({ right: 22 })
        .fontSize(13)
        .lineHeight(19)
        .fontColor(COLOR_TEXT)

      Text(item.action)
        .width('25%')
        .fontSize(13)
        .lineHeight(19)
        .fontColor(item.state === FeasibilityState.MET ? COLOR_MUTED : COLOR_BLUE)
    }
    .width('100%')
    .constraintSize({ minHeight: 82 })
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor(COLOR_SURFACE)
    .border({ width: { bottom: 1 }, color: COLOR_BORDER })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  MobileRow(item: FeasibilityItem) {
    Column({ space: 9 }) {
      Row() {
        Text(item.title).layoutWeight(1).fontSize(15).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        StatusPill({
          text: item.state,
          fillColor: this.stateBackground(item.state),
          textColor: this.stateColor(item.state)
        })
      }
      .width('100%')
      Text(item.evidence).fontSize(13).lineHeight(19).fontColor(COLOR_MUTED)
      Row({ space: 8 }) {
        Text('行动').fontSize(11).fontColor(COLOR_MUTED)
        Text(item.action)
          .layoutWeight(1)
          .fontSize(13)
          .lineHeight(19)
          .fontColor(item.state === FeasibilityState.MET ? COLOR_MUTED : COLOR_BLUE)
      }
      .width('100%')
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .border({ width: { bottom: 1 }, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  JudgmentLedger() {
    Column() {
      Row() {
        Column({ space: 3 }) {
          Text('条件判断台账').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('结论、证据和行动保持在同一行。').fontSize(12).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        Row({ space: 8 }) {
          StatusPill({ text: `${this.metCount()} 项符合`, fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
          StatusPill({ text: `${this.pendingCount()} 项待处理`, fillColor: COLOR_AMBER_SOFT, textColor: COLOR_AMBER })
        }
      }
      .width('100%')
      .padding({ top: 14, bottom: 14 })

      if (this.isWide) {
        this.DesktopHeader()
        ForEach(FEASIBILITY_ITEMS, (item: FeasibilityItem) => {
          this.DesktopRow(item)
        }, (item: FeasibilityItem) => item.id)
      } else {
        Divider().color(COLOR_BORDER)
        ForEach(FEASIBILITY_ITEMS, (item: FeasibilityItem) => {
          this.MobileRow(item)
        }, (item: FeasibilityItem) => item.id)
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  ActionItem(item: FeasibilityItem) {
    if (item.state !== FeasibilityState.MET) {
      Row({ space: 10 }) {
        Column()
          .width(8)
          .height(8)
          .borderRadius(4)
          .backgroundColor(this.stateColor(item.state))
        Column({ space: 3 }) {
          Text(item.action).fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
          Text(item.title).fontSize(11).fontColor(COLOR_MUTED)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding({ top: 12, bottom: 12 })
      .border({ width: { bottom: 1 }, color: COLOR_BORDER })
    }
  }

  @Builder
  ActionPanel() {
    Column() {
      Row() {
        Column({ space: 3 }) {
          Text('下一步行动').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text(`${this.pendingCount()} 项需要推进`).fontSize(12).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        StatusPill({ text: '行动清单', fillColor: COLOR_BLUE_SOFT, textColor: COLOR_BLUE })
      }
      .width('100%')
      .padding({ top: 14, bottom: 14 })
      .border({ width: { bottom: 1 }, color: COLOR_BORDER })

      ForEach(FEASIBILITY_ITEMS, (item: FeasibilityItem) => {
        this.ActionItem(item)
      }, (item: FeasibilityItem) => item.id)

      if (this.personalPlanCreated) {
        Row({ space: 8 }) {
          StatusPill({ text: '已生成', fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
          Text('个人行动清单已记录').fontSize(12).fontColor(COLOR_TEXT)
        }
        .width('100%')
        .padding({ top: 12, bottom: 4 })
      }

      Button(this.personalPlanCreated ? '个人行动清单已生成' : '生成个人行动清单')
        .width('100%')
        .height(42)
        .margin({ top: 14 })
        .fontSize(13)
        .fontColor(COLOR_PRIMARY)
        .backgroundColor(COLOR_PRIMARY_SOFT)
        .borderRadius(4)
        .enabled(!this.personalPlanCreated)
        .onClick(() => {
          this.personalPlanCreated = true;
        })
      Button('创建组队招募')
        .width('100%')
        .height(44)
        .margin({ top: 10, bottom: 14 })
        .fontSize(14)
        .fontColor(this.accountRole === AccountRole.STUDENT ? '#FFFFFF' : COLOR_MUTED)
        .backgroundColor(this.accountRole === AccountRole.STUDENT ? COLOR_PRIMARY : '#E4E8E5')
        .borderRadius(4)
        .enabled(this.accountRole === AccountRole.STUDENT)
        .onClick(() => {
          this.workflowStep = WorkflowStep.TEAM;
        })
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor(COLOR_SURFACE)
    .border({
      width: this.isWide ? { left: 1, top: 1, bottom: 1 } : { top: 1, bottom: 1 },
      color: COLOR_BORDER
    })
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 18 }) {
          WorkflowHeader({
            step: this.workflowStep,
            title: '个人可行性报告',
            description: '按条件核对结论、证据和下一步行动。',
            isWide: this.isWide
          })

          Row({ space: 10 }) {
            StatusPill({ text: '当前机会', fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
            Text(this.opportunityTitle.length > 0 ? this.opportunityTitle : '2026 中国高校计算机大赛 · 鸿蒙高校创新赛')
              .layoutWeight(1)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor(COLOR_TEXT)
          }
          .width('100%')
          .padding({ top: 11, bottom: 11 })
          .border({ width: { top: 1, bottom: 1 }, color: COLOR_BORDER })

          if (this.isWide) {
            Row({ space: 24 }) {
              Column() { this.JudgmentLedger() }.layoutWeight(1)
              Column() { this.ActionPanel() }.width(286)
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)
          } else {
            this.JudgmentLedger()
            this.ActionPanel()
          }
        }
        .width('100%')
        .constraintSize({ maxWidth: PAGE_MAX_WIDTH })
        .padding({ left: this.isWide ? 28 : 18, right: this.isWide ? 28 : 18, top: 18, bottom: 28 })
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
