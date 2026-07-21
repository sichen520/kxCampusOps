import { TEAM_CANDIDATE } from '../../../data/MockCampusData';
import { WorkflowStep } from '../../../domain/WorkflowModels';
import { canConfirmTeam, canCreateProject } from '../../../domain/WorkflowRules';
import { StatusPill } from '../../../shared/components/StatusPill';
import { WorkflowHeader } from '../../../shared/components/WorkflowHeader';
import {
  COLOR_AMBER,
  COLOR_AMBER_SOFT,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
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
    Column({ space: 9 }) {
      Row() {
        Text('当前能力缺口').fontSize(13).fontColor(COLOR_MUTED)
        Blank()
        StatusPill({ text: '招募 1 人', fillColor: COLOR_AMBER_SOFT, textColor: COLOR_AMBER })
      }
      .width('100%')
      Text('产品设计与交互表达').fontSize(18).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      Text('职责：完成黄金链路原型、演示画面和交互走查。')
        .fontSize(13).lineHeight(19).fontColor(COLOR_MUTED)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(COLOR_AMBER_SOFT)
    .borderRadius(6)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  CandidateCard() {
    Column({ space: 10 }) {
      Row() {
        Column({ space: 3 }) {
          Text(TEAM_CANDIDATE.name).fontSize(18).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
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
      Text(`公开证据：${TEAM_CANDIDATE.evidence}`).fontSize(13).lineHeight(19).fontColor(COLOR_TEXT)
      Text(`共同时间：${TEAM_CANDIDATE.availability}`).fontSize(13).lineHeight(19).fontColor(COLOR_MUTED)
      Button(this.candidateApproved ? '申请已批准' : '批准加入草稿团队')
        .width('100%')
        .height(44)
        .fontSize(14)
        .fontColor(this.candidateApproved ? COLOR_MUTED : '#FFFFFF')
        .backgroundColor(this.candidateApproved ? '#E8EBE8' : COLOR_PRIMARY)
        .borderRadius(5)
        .enabled(!this.candidateApproved)
        .onClick(() => {
          this.candidateApproved = true;
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(COLOR_SURFACE)
    .borderRadius(6)
    .border({ width: 1, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 16 }) {
          WorkflowHeader({
            step: this.workflowStep,
            title: '组建互补团队',
            description: '申请必须由队长批准；定向邀请必须由候选人接受。系统不会自动录取任何人。'
          })
          if (this.opportunityTitle.length > 0) {
            Text(`当前机会：${this.opportunityTitle}`).fontSize(14).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
          }
          if (this.isWide) {
            Row({ space: 16 }) {
              Column() { this.RoleCard() }.layoutWeight(1)
              Column() { this.CandidateCard() }.layoutWeight(2)
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)
          } else {
            this.RoleCard()
            this.CandidateCard()
          }
          if (!this.teamConfirmed) {
            Button('确认团队正式成立')
              .width('100%')
              .height(48)
              .fontSize(15)
              .fontColor('#FFFFFF')
              .backgroundColor(canConfirmTeam(this.candidateApproved ? 1 : 0) ? COLOR_PRIMARY : '#AAB2AD')
              .borderRadius(5)
              .enabled(canConfirmTeam(this.candidateApproved ? 1 : 0))
              .onClick(() => {
                this.teamConfirmed = true;
              })
          } else {
            Column({ space: 12 }) {
              Row({ space: 10 }) {
                StatusPill({ text: '团队已成立', fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
                Text('团队仍可继续招募，项目不会自动创建。')
                  .layoutWeight(1).fontSize(13).fontColor(COLOR_TEXT)
              }
              .width('100%')
              Button('由队长创建 CampusOps 项目')
                .width('100%')
                .height(48)
                .fontSize(15)
                .fontColor('#FFFFFF')
                .backgroundColor(canCreateProject(this.teamConfirmed) ? COLOR_PRIMARY : '#AAB2AD')
                .borderRadius(5)
                .enabled(canCreateProject(this.teamConfirmed))
                .onClick(() => {
                  this.workflowStep = WorkflowStep.PROJECT_PLAN;
                })
            }
            .width('100%')
            .padding(16)
            .backgroundColor(COLOR_PRIMARY_SOFT)
            .borderRadius(6)
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
