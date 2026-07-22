import { DemoAccount } from '../../../domain/WorkflowModels';
import {
  COLOR_BACKGROUND,
  COLOR_BORDER,
  COLOR_BLUE,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  COLOR_SURFACE_ALT,
  COLOR_TEXT,
  PAGE_MAX_WIDTH
} from '../../../shared/Theme';

@Component
export struct LoginPage {
  @Link isLoggedIn: boolean;
  @Prop isWide: boolean = false;
  onClose: () => void = () => {};
  onLogin: (account: DemoAccount) => void = (_account: DemoAccount) => {};

  private login(account: DemoAccount): void {
    this.isLoggedIn = true;
    this.onLogin(account);
    this.onClose();
  }

  @Builder
  AccountRow(name: string, identity: string, caption: string, account: DemoAccount, primary: boolean) {
    Column({ space: 0 }) {
      Row({ space: 14 }) {
        Text(name.slice(0, 1))
          .width(38)
          .height(38)
          .textAlign(TextAlign.Center)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(primary ? '#FFFFFF' : COLOR_TEXT)
          .backgroundColor(primary ? COLOR_PRIMARY : COLOR_SURFACE_ALT)
          .borderRadius(4)
          .padding({ top: 9 })
        Column({ space: 4 }) {
          Row({ space: 8 }) {
            Text(name).fontSize(15).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
            Text(identity).fontSize(12).fontColor(primary ? COLOR_PRIMARY : COLOR_MUTED)
            if (primary) {
              Text('推荐')
                .fontSize(10)
                .fontWeight(FontWeight.Medium)
                .fontColor(COLOR_PRIMARY)
                .backgroundColor(COLOR_PRIMARY_SOFT)
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .borderRadius(3)
            }
          }
          Text(caption).fontSize(12).fontColor(COLOR_MUTED)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        Text('进入')
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor(COLOR_PRIMARY)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 14 })
      .backgroundColor(primary ? '#F6FAF7' : COLOR_SURFACE)
      .onClick(() => {
        this.login(account);
      })
      Divider().color(COLOR_BORDER)
    }
    .width('100%')
  }

  @Builder
  BrandPanel() {
    Column() {
      Column({ space: 18 }) {
        Text('汇')
          .width(46)
          .height(46)
          .padding({ top: 8 })
          .textAlign(TextAlign.Center)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .backgroundColor(COLOR_PRIMARY)
          .borderRadius(5)
        Column({ space: 8 }) {
          Text('校汇通')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_TEXT)
          Text('把公开机会推进到真实行动')
            .fontSize(14)
            .fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
      }
      .alignItems(HorizontalAlign.Start)
      Blank()
      Column({ space: 8 }) {
        Text('机会识别 · 可行性判断 · 团队协作 · 项目执行')
          .fontSize(12)
          .lineHeight(19)
          .fontColor(COLOR_MUTED)
        Text('公开浏览无需登录')
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .fontColor(COLOR_BLUE)
      }
      .alignItems(HorizontalAlign.Start)
    }
    .height('100%')
    .padding({ left: 34, right: 34, top: 42, bottom: 34 })
    .backgroundColor(COLOR_SURFACE_ALT)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  AccessPanel() {
    Column() {
      Column({ space: 10 }) {
        Text('选择演示身份')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT)
        Text('不同身份对应独立权限和工作台。')
          .fontSize(13)
          .fontColor(COLOR_MUTED)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ bottom: 22 })

      Column({ space: 0 }) {
        Row() {
          Text('身份通道')
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_MUTED)
          Blank()
          Text('点击即进入')
            .fontSize(11)
            .fontColor(COLOR_MUTED)
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 11, bottom: 11 })
        .backgroundColor(COLOR_SURFACE_ALT)
        Divider().color(COLOR_BORDER)
        this.AccountRow('李然', '申请学生', '申请加入比赛队伍，报名校园活动', DemoAccount.STUDENT_APPLICANT, true)
        this.AccountRow('王晨', '学生账号', '创建或申请加入一支比赛队伍', DemoAccount.STUDENT_SECONDARY, false)
        this.AccountRow('刘老师', '指导老师', '发布校园活动，审核活动报名', DemoAccount.TEACHER, false)
        this.AccountRow('平台管理员', '管理账号', '审核资源、处理举报和身份认证', DemoAccount.ADMIN, false)
      }
      .width('100%')
      .backgroundColor(COLOR_SURFACE)
      .border({ width: 1, color: COLOR_BORDER })
      .borderRadius(5)
      .clip(true)

      Row({ space: 10 }) {
        Button('返回公开浏览')
          .layoutWeight(1)
          .height(42)
          .fontSize(13)
          .fontColor(COLOR_MUTED)
          .backgroundColor(COLOR_SURFACE_ALT)
          .borderRadius(4)
          .onClick(() => { this.onClose(); })
        Button('华为账号登录')
          .layoutWeight(1)
          .height(42)
          .fontSize(13)
          .fontColor(COLOR_MUTED)
          .backgroundColor(COLOR_SURFACE_ALT)
          .borderRadius(4)
          .enabled(false)
      }
      .width('100%')
      .margin({ top: 16 })

      Text('当前版本使用受控演示身份，真实账号服务将在复赛版本接入。')
        .width('100%')
        .margin({ top: 12 })
        .textAlign(TextAlign.Center)
        .fontSize(11)
        .fontColor(COLOR_MUTED)
    }
    .width('100%')
    .constraintSize({ maxWidth: 620 })
    .padding(this.isWide ? 42 : 18)
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Column() {
      if (this.isWide) {
        Row({ space: 0 }) {
          Column() { this.BrandPanel() }.width(340).height('100%')
          Row() { this.AccessPanel() }
            .layoutWeight(1)
            .height('100%')
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
        }
        .width('100%')
        .height('100%')
      } else {
        Scroll() {
          Column({ space: 0 }) {
            Column({ space: 10 }) {
              Text('汇')
                .width(40)
                .height(40)
                .padding({ top: 7 })
                .textAlign(TextAlign.Center)
                .fontSize(21)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .backgroundColor(COLOR_PRIMARY)
                .borderRadius(5)
              Text('校汇通')
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .fontColor(COLOR_TEXT)
            }
            .width('100%')
            .padding({ left: 18, right: 18, top: 24, bottom: 6 })
            .alignItems(HorizontalAlign.Start)
            this.AccessPanel()
          }
          .width('100%')
          .constraintSize({ maxWidth: PAGE_MAX_WIDTH })
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(COLOR_BACKGROUND)
  }
}
