import { PageTitle } from '../../../shared/components/PageTitle';
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
  COLOR_RED,
  COLOR_RED_SOFT,
  COLOR_SURFACE,
  COLOR_SURFACE_ALT,
  COLOR_TEXT,
  PAGE_MAX_WIDTH
} from '../../../shared/Theme';

@Component
export struct AdminConsolePage {
  @Prop isWide: boolean = false;
  @State activeSection: number = 0;
  @State resourceAuditStatus: string = '待审核';
  @State reportStatus: string = '待处理';
  @State identityStatus: string = '待认证';

  @Builder
  Stat(value: string, label: string, color: string) {
    Column({ space: 4 }) {
      Text(value).fontSize(24).fontWeight(FontWeight.Bold).fontColor(color)
      Text(label).fontSize(12).fontColor(COLOR_MUTED)
    }
    .layoutWeight(1)
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  AuditQueue() {
    Flex({ direction: this.isWide ? FlexDirection.Row : FlexDirection.Column, wrap: FlexWrap.NoWrap }) {
      Column({ space: 12 }) {
        Text('资源审核 · RES-026')
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor(COLOR_MUTED)
        Column({ space: 4 }) {
          Text('HarmonyOS 跨设备状态恢复示例').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('周同学 · HarmonyOS 开发 / 源码 · 2026-07-21 09:12').fontSize(12).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Divider().color(COLOR_BORDER)
        Row({ space: 12 }) {
          Text('审核范围').width(72).fontSize(12).fontColor(COLOR_MUTED)
          Text('文件安全、版权声明、分类与标签、隐私信息')
            .layoutWeight(1).fontSize(13).fontColor(COLOR_TEXT)
        }
        .width('100%')
        Row({ space: 12 }) {
          Text('原始证据').width(72).fontSize(12).fontColor(COLOR_MUTED)
          Text('source_bundle_hmos_state.zip').layoutWeight(1).fontSize(13).fontColor(COLOR_BLUE)
        }
        .width('100%')
      }
      .width(this.isWide ? '68%' : '100%')
      .padding(18)
      .alignItems(HorizontalAlign.Start)

      Column({ space: 14 }) {
        Row() {
          Text('处置').fontSize(12).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Blank()
          StatusPill({
            text: this.resourceAuditStatus,
            fillColor: this.resourceAuditStatus === '已通过' ? COLOR_PRIMARY_SOFT : COLOR_AMBER_SOFT,
            textColor: this.resourceAuditStatus === '已通过' ? COLOR_PRIMARY : COLOR_AMBER
          })
        }
        .width('100%')
        Text('先核对源文件，再决定公开状态。').fontSize(12).lineHeight(18).fontColor(COLOR_MUTED)
        Button('通过并发布')
          .width('100%').height(40).fontSize(13).fontColor('#FFFFFF').backgroundColor(COLOR_PRIMARY).borderRadius(4)
          .enabled(this.resourceAuditStatus === '待审核')
          .onClick(() => { this.resourceAuditStatus = '已通过'; })
        Button('退回修改')
          .width('100%').height(40).fontSize(13).fontColor(COLOR_RED).backgroundColor(COLOR_RED_SOFT).borderRadius(4)
          .enabled(this.resourceAuditStatus === '待审核')
          .onClick(() => { this.resourceAuditStatus = '已退回'; })
      }
      .width(this.isWide ? '32%' : '100%')
      .padding(18)
      .backgroundColor(COLOR_SURFACE_ALT)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER })
    .borderRadius(5)
    .clip(true)
  }

  @Builder
  ReportQueue() {
    Flex({ direction: this.isWide ? FlexDirection.Row : FlexDirection.Column, wrap: FlexWrap.NoWrap }) {
      Column({ space: 12 }) {
        Text('举报处理 · RPT-011')
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor(COLOR_MUTED)
        Text('资源举报：疑似包含课程作业答案').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Text('目标：软件工程课程设计完整答案 · 举报人信息仅管理员可见').fontSize(12).fontColor(COLOR_MUTED)
        Divider().color(COLOR_BORDER)
        Row({ space: 12 }) {
          Text('处理原则').width(72).fontSize(12).fontColor(COLOR_MUTED)
          Text('先隐藏内容并保全证据，再通知上传者申诉。')
            .layoutWeight(1).fontSize(13).fontColor(COLOR_TEXT)
        }
        .width('100%')
        Row({ space: 12 }) {
          Text('证据快照').width(72).fontSize(12).fontColor(COLOR_MUTED)
          Text('snapshot_rpt_011.pdf').layoutWeight(1).fontSize(13).fontColor(COLOR_BLUE)
        }
        .width('100%')
      }
      .width(this.isWide ? '68%' : '100%')
      .padding(18)
      .alignItems(HorizontalAlign.Start)

      Column({ space: 14 }) {
        Row() {
          Text('处置').fontSize(12).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Blank()
          StatusPill({
            text: this.reportStatus,
            fillColor: this.reportStatus === '已处理' ? COLOR_PRIMARY_SOFT : COLOR_RED_SOFT,
            textColor: this.reportStatus === '已处理' ? COLOR_PRIMARY : COLOR_RED
          })
        }
        .width('100%')
        Text('该操作保留申诉入口，不会永久删除内容。').fontSize(12).lineHeight(18).fontColor(COLOR_MUTED)
        Button('隐藏并通知上传者')
          .width('100%').height(40).fontSize(13).fontColor('#FFFFFF').backgroundColor(COLOR_RED).borderRadius(4)
          .enabled(this.reportStatus === '待处理')
          .onClick(() => { this.reportStatus = '已处理'; })
      }
      .width(this.isWide ? '32%' : '100%')
      .padding(18)
      .backgroundColor(COLOR_SURFACE_ALT)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER })
    .borderRadius(5)
    .clip(true)
  }

  @Builder
  IdentityQueue() {
    Flex({ direction: this.isWide ? FlexDirection.Row : FlexDirection.Column, wrap: FlexWrap.NoWrap }) {
      Column({ space: 12 }) {
        Text('身份认证 · IDV-008')
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor(COLOR_MUTED)
        Text('刘老师 · 指导老师认证').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Text('校级创新实践中心 · 工号证明与学院信息已提交').fontSize(12).fontColor(COLOR_MUTED)
        Divider().color(COLOR_BORDER)
        Row({ space: 12 }) {
          Text('授权范围').width(72).fontSize(12).fontColor(COLOR_MUTED)
          Text('发布校园活动、审批学生报名').layoutWeight(1).fontSize(13).fontColor(COLOR_TEXT)
        }
        .width('100%')
        Row({ space: 12 }) {
          Text('认证材料').width(72).fontSize(12).fontColor(COLOR_MUTED)
          Text('teacher_identity_008.pdf').layoutWeight(1).fontSize(13).fontColor(COLOR_BLUE)
        }
        .width('100%')
      }
      .width(this.isWide ? '68%' : '100%')
      .padding(18)
      .alignItems(HorizontalAlign.Start)

      Column({ space: 14 }) {
        Row() {
          Text('处置').fontSize(12).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Blank()
          StatusPill({
            text: this.identityStatus,
            fillColor: this.identityStatus === '已认证' ? COLOR_PRIMARY_SOFT : COLOR_BLUE_SOFT,
            textColor: this.identityStatus === '已认证' ? COLOR_PRIMARY : COLOR_BLUE
          })
        }
        .width('100%')
        Text('认证不会赋予平台内容管理权限。').fontSize(12).lineHeight(18).fontColor(COLOR_MUTED)
        Button('确认老师身份')
          .width('100%').height(40).fontSize(13).fontColor('#FFFFFF').backgroundColor(COLOR_PRIMARY).borderRadius(4)
          .enabled(this.identityStatus === '待认证')
          .onClick(() => { this.identityStatus = '已认证'; })
      }
      .width(this.isWide ? '32%' : '100%')
      .padding(18)
      .backgroundColor(COLOR_SURFACE_ALT)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER })
    .borderRadius(5)
    .clip(true)
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 16 }) {
          PageTitle({
            eyebrow: '管理后台',
            title: '平台审核与治理',
            description: '核对证据、记录判断并执行处置。'
          })
          Row({ space: 10 }) {
            this.Stat('2', '待审核资源', COLOR_AMBER)
            this.Stat('1', '待处理举报', COLOR_RED)
            this.Stat('2', '待认证身份', COLOR_BLUE)
            this.Stat('128', '今日公开浏览', COLOR_PRIMARY)
          }
          .width('100%')
          .backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER })
          .borderRadius(5)

          Row({ space: 8 }) {
            Button('内容审核')
              .layoutWeight(1).height(40).fontSize(13)
              .fontColor(this.activeSection === 0 ? COLOR_PRIMARY : COLOR_MUTED)
              .backgroundColor(this.activeSection === 0 ? COLOR_PRIMARY_SOFT : COLOR_SURFACE)
              .borderRadius(4).onClick(() => { this.activeSection = 0; })
            Button('举报处理')
              .layoutWeight(1).height(40).fontSize(13)
              .fontColor(this.activeSection === 1 ? COLOR_RED : COLOR_MUTED)
              .backgroundColor(this.activeSection === 1 ? COLOR_RED_SOFT : COLOR_SURFACE)
              .borderRadius(4).onClick(() => { this.activeSection = 1; })
            Button('身份认证')
              .layoutWeight(1).height(40).fontSize(13)
              .fontColor(this.activeSection === 2 ? COLOR_BLUE : COLOR_MUTED)
              .backgroundColor(this.activeSection === 2 ? COLOR_BLUE_SOFT : COLOR_SURFACE)
              .borderRadius(4).onClick(() => { this.activeSection = 2; })
          }
          .width('100%')
          .constraintSize({ maxWidth: this.isWide ? 480 : PAGE_MAX_WIDTH })
          .padding(4)
          .backgroundColor('#E9EDE9')
          .borderRadius(5)

          if (this.activeSection === 0) {
            this.AuditQueue()
          } else if (this.activeSection === 1) {
            this.ReportQueue()
          } else {
            this.IdentityQueue()
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
