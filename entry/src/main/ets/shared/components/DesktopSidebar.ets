import { AccountRole, DemoAccount } from '../../domain/WorkflowModels';
import {
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  COLOR_SURFACE_ALT,
  COLOR_TEXT
} from '../Theme';

interface DesktopNavigationItem {
  index: number;
  label: string;
  adminOnly: boolean;
}

const DESKTOP_NAVIGATION: DesktopNavigationItem[] = [
  { index: 0, label: '首页', adminOnly: false },
  { index: 1, label: '可行', adminOnly: false },
  { index: 2, label: '知享', adminOnly: false },
  { index: 3, label: '队伍', adminOnly: false },
  { index: 4, label: '执行', adminOnly: false },
  { index: 5, label: '我的', adminOnly: false },
  { index: 6, label: '管理', adminOnly: true }
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
      Row({ space: 11 }) {
        Text('汇')
          .width(38)
          .height(38)
          .textAlign(TextAlign.Center)
          .padding({ top: 4 })
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .backgroundColor(COLOR_PRIMARY)
          .borderRadius(4)
        Column({ space: 2 }) {
          Text('校汇通')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_TEXT)
            .letterSpacing(0.2)
          Text('校园行动工作台')
            .fontSize(10)
            .fontColor(COLOR_MUTED)
            .letterSpacing(0.5)
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding({ left: 18, right: 18, top: 20, bottom: 24 })

      Column({ space: 5 }) {
        ForEach(DESKTOP_NAVIGATION, (item: DesktopNavigationItem) => {
          if (!item.adminOnly || this.accountRole === AccountRole.ADMIN) {
            Row({ space: 11 }) {
              Column()
                .width(3)
                .height(28)
                .borderRadius(1)
                .backgroundColor(this.selectedTab === item.index ? COLOR_PRIMARY : Color.Transparent)
              Text(item.label)
                .fontSize(15)
                .fontWeight(this.selectedTab === item.index ? FontWeight.Bold : FontWeight.Medium)
                .fontColor(this.selectedTab === item.index ? COLOR_PRIMARY : COLOR_TEXT)
            }
            .width('100%')
            .height(48)
            .padding({ left: 10, right: 12 })
            .borderRadius(4)
            .backgroundColor(this.selectedTab === item.index ? COLOR_SURFACE_ALT : Color.Transparent)
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
      .padding({ left: 10, right: 10, top: 4 })

      Blank()

      Row({ space: 10 }) {
        Text(this.isLoggedIn ? '我' : '客')
          .width(30)
          .height(30)
          .textAlign(TextAlign.Center)
          .padding({ top: 6 })
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.isLoggedIn ? COLOR_PRIMARY : COLOR_MUTED)
          .backgroundColor(this.isLoggedIn ? COLOR_PRIMARY_SOFT : COLOR_SURFACE_ALT)
          .borderRadius(4)
        Column({ space: 2 }) {
          Text(this.isLoggedIn ? this.accountLabel() : '游客')
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor(COLOR_TEXT)
            .constraintSize({ maxWidth: 170 })
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text(this.isLoggedIn ? '当前身份' : '公开浏览')
            .fontSize(10)
            .fontColor(COLOR_MUTED)
            .letterSpacing(0.5)
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding({ left: 18, right: 18, top: 14, bottom: 16 })
      .border({ width: { top: 1 }, color: COLOR_BORDER })
    }
    .width(252)
    .height('100%')
    .backgroundColor(COLOR_SURFACE)
    .border({ width: { right: 1 }, color: COLOR_BORDER })
  }
}
