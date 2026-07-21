import { DemoAccount } from '../../../domain/WorkflowModels';
import {
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
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
    Row({ space: 12 }) {
      Text(name.slice(0, 1))
        .width(38)
        .height(38)
        .textAlign(TextAlign.Center)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(primary ? '#FFFFFF' : COLOR_PRIMARY)
        .backgroundColor(primary ? COLOR_PRIMARY : COLOR_PRIMARY_SOFT)
        .borderRadius(19)
        .padding({ top: 9 })
      Column({ space: 3 }) {
        Row({ space: 8 }) {
          Text(name).fontSize(15).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text(identity).fontSize(12).fontColor(COLOR_PRIMARY)
        }
        Text(caption).fontSize(12).fontColor(COLOR_MUTED)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      Text('进入').fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_PRIMARY)
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 11, bottom: 11 })
    .backgroundColor(primary ? '#F1F8F5' : COLOR_SURFACE)
    .borderRadius(5)
    .border({ width: 1, color: primary ? COLOR_PRIMARY : COLOR_BORDER })
    .onClick(() => {
      this.login(account);
    })
  }

  build() {
    Column() {
      Column({ space: 20 }) {
        Column({ space: 5 }) {
          Text('可行 CampusOps')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_TEXT)
          Text('把公开机会推进到你的行动')
            .fontSize(14)
            .fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)

        Column({ space: 12 }) {
          Text('登录后继续')
            .fontSize(21)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_TEXT)
          Text('公开的比赛招募、校园活动和知识内容无需登录即可浏览。申请加入、活动报名、发布招募和个人项目需要登录。')
            .fontSize(14)
            .lineHeight(22)
            .fontColor(COLOR_MUTED)
          this.AccountRow('李然', '申请学生', '申请加入比赛队伍，报名校园活动', DemoAccount.STUDENT_APPLICANT, true)
          this.AccountRow('王晨', '学生账号', '可申请加入队伍，也可以创建自己的组队招募', DemoAccount.STUDENT_SECONDARY, false)
          this.AccountRow('刘老师', '指导老师', '发布校园活动，审核活动报名', DemoAccount.TEACHER, false)
          this.AccountRow('平台管理员', '管理账号', '审核资源、处理举报和身份认证', DemoAccount.ADMIN, false)
          Button('华为账号登录（复赛接入）')
            .width('100%')
            .height(44)
            .fontSize(14)
            .fontColor(COLOR_PRIMARY)
            .backgroundColor(COLOR_PRIMARY_SOFT)
            .borderRadius(5)
            .enabled(false)
          Text('当前 Demo 使用受控演示身份，不代表已接入真实账号服务。')
            .width('100%')
            .textAlign(TextAlign.Center)
            .fontSize(12)
            .fontColor(COLOR_MUTED)
        }
        .width('100%')
        .padding(22)
        .backgroundColor(COLOR_SURFACE)
        .borderRadius(8)
        .border({ width: 1, color: COLOR_BORDER })
        .alignItems(HorizontalAlign.Start)

        Button('返回公开浏览')
          .height(40)
          .fontSize(14)
          .fontColor(COLOR_MUTED)
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            this.onClose();
          })
      }
      .width('100%')
      .constraintSize({ maxWidth: this.isWide ? 520 : PAGE_MAX_WIDTH })
      .padding({ left: 20, right: 20 })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#EAF0EB')
  }
}
