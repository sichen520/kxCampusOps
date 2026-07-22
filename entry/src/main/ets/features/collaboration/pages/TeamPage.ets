import { TEAM_CANDIDATE } from '../../../data/MockCampusData';
import { WorkflowStep } from '../../../domain/WorkflowModels';
import { canConfirmTeam, canCreateProject } from '../../../domain/WorkflowRules';
import { StatusPill } from '../../../shared/components/StatusPill';
import { WorkflowHeader } from '../../../shared/components/WorkflowHeader';
import {
  COLOR_AMBER,
  COLOR_AMBER_SOFT,
  COLOR_BLUE,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  COLOR_SURFACE_ALT,
  COLOR_TEXT,
  PAGE_MAX_WIDTH
} from '../../../shared/Theme';

@Component
export struct TeamPage {
  @Link workflowStep: WorkflowStep;
  @Link candidateApproved: boolean;
  @Link teamConfirmed: boolean;
  @Prop opportunityTitle: string = '';
  @Prop isWide: boolean = false;

  @Builder
  RoleCard() {
    Column({ space: 12 }) {
      Row() {
        Text('能力缺口').fontSize(11).fontWeight(FontWeight.Medium).fontColor(COLOR_MUTED)
        Blank()
        StatusPill({ text: '招募 1 人', fillColor: COLOR_AMBER_SOFT, textColor: COLOR_AMBER })
      }
      .width('100%')
      Text('产品设计与交互表达').fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      Divider().color(COLOR_BORDER)
      Column({ space: 5 }) {
        Text('交付').fontSize(11).fontColor(COLOR_MUTED)
        Text('黄金链路原型、演示画面、交互走查').fontSize(13).lineHeight(19).fontColor(COLOR_TEXT)
      }
      .alignItems(HorizontalAlign.Start)
      Column({ space: 5 }) {
        Text('优先证据').fontSize(11).fontColor(COLOR_MUTED)
        Text('已上线作品或可交互原型').fontSize(13).lineHeight(19).fontColor(COLOR_TEXT)
      }
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE_ALT)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  CandidateCard() {
    Column({ space: 12 }) {
      Text('候选申请 · APP-001').fontSize(11).fontWeight(FontWeight.Medium).fontColor(COLOR_MUTED)
      Row() {
        Column({ space: 3 }) {
          Text(TEAM_CANDIDATE.name).fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text(TEAM_CANDIDATE.role).fontSize(13).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        StatusPill({
          text: this.candidateApproved ? '队长已批准' : '待队长审批',
          fillColor: this.candidateApproved ? COLOR_PRIMARY_SOFT : COLOR_AMBER_SOFT,
          textColor: this.candidateApproved ? COLOR_PRIMARY : COLOR_AMBER
        })
      }
      .width('100%')
      Divider().color(COLOR_BORDER)
      Row({ space: 12 }) {
        Text('公开证据').width(68).fontSize(11).fontColor(COLOR_MUTED)
        Text(TEAM_CANDIDATE.evidence).layoutWeight(1).fontSize(13).lineHeight(19).fontColor(COLOR_BLUE)
      }
      .width('100%')
      Row({ space: 12 }) {
        Text('共同时间').width(68).fontSize(11).fontColor(COLOR_MUTED)
        Text(TEAM_CANDIDATE.availability).layoutWeight(1).fontSize(13).lineHeight(19).fontColor(COLOR_TEXT)
      }
      .width('100%')
      Button(this.candidateApproved ? '申请已批准' : '批准加入草稿团队')
        .width('100%')
        .height(40)
        .fontSize(13)
        .fontColor(this.candidateApproved ? COLOR_MUTED : '#FFFFFF')
        .backgroundColor(this.candidateApproved ? '#E8EBE8' : COLOR_PRIMARY)
        .borderRadius(4)
        .enabled(!this.candidateApproved)
        .onClick(() => {
          this.candidateApproved = true;
        })
    }
    .width('100%')
    .height('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  FormationPanel() {
    Column({ space: 14 }) {
      Text('团队状态').fontSize(11).fontWeight(FontWeight.Medium).fontColor(COLOR_MUTED)
      if (!this.teamConfirmed) {
        Text('等待正式确认').fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Text(this.candidateApproved ? '候选人已批准，可以确认团队成立。' : '先批准至少一名候选人。')
          .fontSize(12).lineHeight(18).fontColor(COLOR_MUTED)
        Blank()
        Button('确认团队成立')
          .width('100%')
          .height(42)
          .fontSize(13)
          .fontColor('#FFFFFF')
          .backgroundColor(canConfirmTeam(this.candidateApproved ? 1 : 0) ? COLOR_PRIMARY : '#AAB2AD')
          .borderRadius(4)
          .enabled(canConfirmTeam(this.candidateApproved ? 1 : 0))
          .onClick(() => { this.teamConfirmed = true; })
      } else {
        StatusPill({ text: '团队已成立', fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
        Text('项目不会自动创建，仍可继续招募。').fontSize(12).lineHeight(18).fontColor(COLOR_MUTED)
        Blank()
        Button('创建校汇通项目')
          .width('100%')
          .height(42)
          .fontSize(13)
          .fontColor('#FFFFFF')
          .backgroundColor(canCreateProject(this.teamConfirmed) ? COLOR_PRIMARY : '#AAB2AD')
          .borderRadius(4)
          .enabled(canCreateProject(this.teamConfirmed))
          .onClick(() => { this.workflowStep = WorkflowStep.PROJECT_PLAN; })
      }
    }
    .width('100%')
    .height('100%')
    .padding(18)
    .backgroundColor(this.teamConfirmed ? COLOR_PRIMARY_SOFT : COLOR_SURFACE_ALT)
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 16 }) {
          WorkflowHeader({
            step: this.workflowStep,
            title: '组建互补团队',
            description: '核对候选证据，由队长完成批准与正式确认。',
            isWide: this.isWide
          })
          if (this.opportunityTitle.length > 0) {
            Row({ space: 10 }) {
              Text('当前机会').fontSize(11).fontColor(COLOR_MUTED)
              Text(this.opportunityTitle).layoutWeight(1).fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
            }
            .width('100%')
          }
          if (this.isWide) {
            Row({ space: 0 }) {
              Column() { this.RoleCard() }.width('27%').height('100%')
              Column() { this.CandidateCard() }.width('45%').height('100%')
              Column() { this.FormationPanel() }.width('28%').height('100%')
            }
            .width('100%')
            .constraintSize({ minHeight: 320 })
            .alignItems(VerticalAlign.Top)
            .border({ width: 1, color: COLOR_BORDER })
            .borderRadius(5)
            .clip(true)
          } else {
            Column({ space: 0 }) {
              this.RoleCard()
              Divider().color(COLOR_BORDER)
              this.CandidateCard()
              Divider().color(COLOR_BORDER)
              this.FormationPanel()
            }
            .width('100%')
            .border({ width: 1, color: COLOR_BORDER })
            .borderRadius(5)
            .clip(true)
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
