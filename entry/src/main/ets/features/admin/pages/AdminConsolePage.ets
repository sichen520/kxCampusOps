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
    .padding(15)
    .backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER })
    .borderRadius(5)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  AuditQueue() {
    Column({ space: 0 }) {
      Row({ space: 12 }) {
        Column({ space: 4 }) {
          Text('HarmonyOS 跨设备状态恢复示例').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('周同学 · HarmonyOS 开发 / 源码 · 2026-07-21 09:12').fontSize(12).fontColor(COLOR_MUTED)
        }
        .layoutWeight(1)
        StatusPill({
          text: this.resourceAuditStatus,
          fillColor: this.resourceAuditStatus === '已通过' ? COLOR_PRIMARY_SOFT : COLOR_AMBER_SOFT,
          textColor: this.resourceAuditStatus === '已通过' ? COLOR_PRIMARY : COLOR_AMBER
        })
      }
      .width('100%')
      .padding({ top: 14, bottom: 14 })
      Text('审核项：文件安全、版权声明、分类和标签、是否包含作业答案或个人隐私。')
        .fontSize(13).lineHeight(20).fontColor(COLOR_MUTED)
      Row({ space: 10 }) {
        Button('通过并发布')
          .layoutWeight(1).height(40).fontSize(13).fontColor('#FFFFFF').backgroundColor(COLOR_PRIMARY).borderRadius(4)
          .enabled(this.resourceAuditStatus === '待审核')
          .onClick(() => {
            this.resourceAuditStatus = '已通过';
          })
        Button('退回修改')
          .layoutWeight(1).height(40).fontSize(13).fontColor(COLOR_RED).backgroundColor(COLOR_RED_SOFT).borderRadius(4)
          .enabled(this.resourceAuditStatus === '待审核')
          .onClick(() => {
            this.resourceAuditStatus = '已退回';
          })
      }
      .width('100%')
      .margin({ top: 14 })
    }
    .width('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER })
    .borderRadius(6)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  ReportQueue() {
    Column({ space: 12 }) {
      Row() {
        Column({ space: 4 }) {
          Text('资源举报：疑似包含课程作业答案').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('目标：软件工程课程设计完整答案 · 举报人信息仅管理员可见').fontSize(12).fontColor(COLOR_MUTED)
        }
        .layoutWeight(1)
        StatusPill({
          text: this.reportStatus,
          fillColor: this.reportStatus === '已处理' ? COLOR_PRIMARY_SOFT : COLOR_RED_SOFT,
          textColor: this.reportStatus === '已处理' ? COLOR_PRIMARY : COLOR_RED
        })
      }
      .width('100%')
      Text('处理原则：先暂时隐藏内容并保存证据，再通知上传者申诉，不直接永久删除。')
        .fontSize(13).lineHeight(20).fontColor(COLOR_MUTED)
      Button('隐藏内容并通知上传者')
        .width('100%').height(42).fontSize(13).fontColor('#FFFFFF').backgroundColor(COLOR_RED).borderRadius(4)
        .enabled(this.reportStatus === '待处理')
        .onClick(() => {
          this.reportStatus = '已处理';
        })
    }
    .width('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER })
    .borderRadius(6)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  IdentityQueue() {
    Column({ space: 12 }) {
      Row() {
        Column({ space: 4 }) {
          Text('刘老师 · 指导老师认证').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('校级创新实践中心 · 工号证明与学院信息已提交').fontSize(12).fontColor(COLOR_MUTED)
        }
        .layoutWeight(1)
        StatusPill({
          text: this.identityStatus,
          fillColor: this.identityStatus === '已认证' ? COLOR_PRIMARY_SOFT : COLOR_BLUE_SOFT,
          textColor: this.identityStatus === '已认证' ? COLOR_PRIMARY : COLOR_BLUE
        })
      }
      .width('100%')
      Text('通过后可发布校园活动并审批学生报名；认证不会赋予平台内容管理权限。')
        .fontSize(13).lineHeight(20).fontColor(COLOR_MUTED)
      Button('确认老师身份')
        .width('100%').height(42).fontSize(13).fontColor('#FFFFFF').backgroundColor(COLOR_PRIMARY).borderRadius(4)
        .enabled(this.identityStatus === '待认证')
        .onClick(() => {
          this.identityStatus = '已认证';
        })
    }
    .width('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER })
    .borderRadius(6)
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 16 }) {
          PageTitle({
            eyebrow: '管理后台',
            title: '平台审核与治理',
            description: '处理公开内容、举报和身份认证。队伍申请与活动报名仍由对应负责人审批。'
          })
          Row({ space: 10 }) {
            this.Stat('2', '待审核资源', COLOR_AMBER)
            this.Stat('1', '待处理举报', COLOR_RED)
            this.Stat('2', '待认证身份', COLOR_BLUE)
            this.Stat('128', '今日公开浏览', COLOR_PRIMARY)
          }
          .width('100%')

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
