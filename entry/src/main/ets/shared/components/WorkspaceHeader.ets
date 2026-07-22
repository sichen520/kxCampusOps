import { AccountRole, DemoAccount } from '../../domain/WorkflowModels';
import {
  COLOR_BORDER,
  COLOR_PRIMARY,
  COLOR_SURFACE,
  COLOR_TEXT
} from '../Theme';

@Component
export struct WorkspaceHeader {
  @Prop selectedTab: number = 0;
  @Prop isLoggedIn: boolean = false;
  @Prop accountRole: AccountRole = AccountRole.STUDENT;
  @Prop demoAccount: DemoAccount = DemoAccount.STUDENT_APPLICANT;
  @Prop accountDisplayName: string = '';
  onReset: () => void = () => {};
  onLogin: () => void = () => {};
  onSwitchAccount: () => void = () => {};

  private currentSection(): string {
    const names: string[] = ['机会工作台', '可行', '知享', '队伍', '执行', '我的', '管理'];
    return names[this.selectedTab];
  }

  private accountLabel(): string {
    return this.accountDisplayName;
  }

  build() {
    Row() {
      Text(this.currentSection())
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(COLOR_TEXT)
        .letterSpacing(0.2)
      Blank()
      if (this.selectedTab === 1) {
        Button('重置机会流程')
          .height(34)
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .fontColor(COLOR_PRIMARY)
          .backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_PRIMARY })
          .borderRadius(4)
          .onClick(() => {
            this.onReset();
          })
      }
      Button(this.isLoggedIn ? this.accountLabel() : '登录')
        .height(34)
        .constraintSize({ minWidth: 68, maxWidth: 180 })
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.isLoggedIn ? COLOR_TEXT : '#FFFFFF')
        .backgroundColor(this.isLoggedIn ? COLOR_SURFACE : COLOR_PRIMARY)
        .border({ width: 1, color: this.isLoggedIn ? COLOR_BORDER : COLOR_PRIMARY })
        .borderRadius(4)
        .margin({ left: 10 })
        .onClick(() => {
          if (!this.isLoggedIn) {
            this.onLogin();
          } else {
            this.onSwitchAccount();
          }
        })
    }
    .width('100%')
    .height(60)
    .padding({ left: 24, right: 24 })
    .backgroundColor(COLOR_SURFACE)
    .border({ width: { bottom: 1 }, color: COLOR_BORDER })
  }
}
