import { AccountRole, DemoAccount } from '../../domain/WorkflowModels';
import {
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  COLOR_TEXT
} from '../Theme';

interface DesktopNavigationItem {
  index: number;
  label: string;
  caption: string;
  adminOnly: boolean;
}

const DESKTOP_NAVIGATION: DesktopNavigationItem[] = [
  { index: 0, label: '首页', caption: '比赛与活动', adminOnly: false },
  { index: 1, label: '可行', caption: '机会履约', adminOnly: false },
  { index: 2, label: '知享', caption: '知识资源', adminOnly: false },
  { index: 3, label: '队伍', caption: '成员与指导老师', adminOnly: false },
  { index: 4, label: 'CampusOps', caption: '项目执行', adminOnly: false },
  { index: 5, label: '我的', caption: '个人中心', adminOnly: false },
  { index: 6, label: '管理后台', caption: '审核与平台治理', adminOnly: true }
];

@Component
export struct DesktopSidebar {
  @Link selectedTab: number;
  @Prop isLoggedIn: boolean = false;
  @Prop accountRole: AccountRole = AccountRole.STUDENT;
  @Prop demoAccount: DemoAccount = DemoAccount.STUDENT_APPLICANT;
  @Prop accountDisplayName: string = '';
  onRequireLogin: (index: number) => void = (_index: number) => {};

  private requiresLogin(index: number): boolean {
    return index === 1 || index === 3 || index === 4 || index === 5 || index === 6;
  }

  private accountLabel(): string {
    if (this.demoAccount === DemoAccount.TEACHER) {
      return `${this.accountDisplayName} · 指导老师`;
    }
    if (this.demoAccount === DemoAccount.ADMIN) {
      return this.accountDisplayName;
    }
    return `${this.accountDisplayName} · 学生`;
  }

  build() {
    Column() {
      Row({ space: 12 }) {
        Text('KX')
          .width(42).height(42).textAlign(TextAlign.Center).padding({ top: 11 })
          .fontSize(14).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
          .backgroundColor(COLOR_PRIMARY).borderRadius(8)
        Column({ space: 3 }) {
          Text('可行 CampusOps')
            .fontSize(19).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('校园机会协作工作台')
            .fontSize(11).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding({ left: 18, right: 18, top: 22, bottom: 22 })

      Column({ space: 5 }) {
        ForEach(DESKTOP_NAVIGATION, (item: DesktopNavigationItem) => {
          if (!item.adminOnly || this.accountRole === AccountRole.ADMIN) {
            Row({ space: 10 }) {
            Column()
              .width(4)
              .height(30)
              .borderRadius(2)
              .backgroundColor(this.selectedTab === item.index ? COLOR_PRIMARY : Color.Transparent)
            Column({ space: 2 }) {
              Text(item.label)
                .fontSize(14)
                .fontWeight(this.selectedTab === item.index ? FontWeight.Bold : FontWeight.Medium)
                .fontColor(this.selectedTab === item.index ? COLOR_PRIMARY : COLOR_TEXT)
              Text(item.caption)
                .fontSize(10)
                .fontColor(COLOR_MUTED)
            }
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .height(52)
          .padding({ left: 12, right: 12 })
          .borderRadius(7)
          .backgroundColor(this.selectedTab === item.index ? COLOR_PRIMARY_SOFT : Color.Transparent)
            .onClick(() => {
              if (!this.isLoggedIn && this.requiresLogin(item.index)) {
                this.onRequireLogin(item.index);
              } else {
                this.selectedTab = item.index;
              }
            })
          }
        }, (item: DesktopNavigationItem) => item.index.toString())
      }
      .width('100%')
      .padding({ left: 10, right: 10 })

      Blank()

      Column({ space: 5 }) {
        Text(this.isLoggedIn ? this.accountLabel() : '当前为游客模式')
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .fontColor(COLOR_PRIMARY)
        Text(this.isLoggedIn ? '可申请、报名与管理项目' : '可浏览公开招募和知识内容')
          .fontSize(11)
          .fontColor(COLOR_MUTED)
      }
      .width('100%')
      .margin({ left: 12, right: 12, bottom: 14 })
      .padding(14)
      .backgroundColor(this.isLoggedIn ? COLOR_PRIMARY_SOFT : '#F2F4F3')
      .borderRadius(7)
      .alignItems(HorizontalAlign.Start)
    }
    .width(248)
    .height('100%')
    .backgroundColor(COLOR_SURFACE)
    .border({ width: { right: 1 }, color: COLOR_BORDER })
  }
}
