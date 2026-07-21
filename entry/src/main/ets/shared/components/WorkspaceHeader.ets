import { AccountRole, DemoAccount } from '../../domain/WorkflowModels';
import {
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
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
    const names: string[] = ['首页', '可行', '知享', '队伍', 'CampusOps', '我的', '管理后台'];
    return names[this.selectedTab];
  }

  private accountLabel(): string {
    return this.accountDisplayName;
  }

  build() {
    Row() {
      Column({ space: 2 }) {
        Text(this.currentSection())
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT)
        Text('HarmonyOS PC 工作区')
          .fontSize(12)
          .fontColor(COLOR_MUTED)
      }
      .alignItems(HorizontalAlign.Start)
      Blank()
      if (this.selectedTab === 1) {
        Button('重置机会流程')
          .height(36)
          .fontSize(13)
          .fontColor(COLOR_PRIMARY)
          .backgroundColor(COLOR_PRIMARY_SOFT)
          .borderRadius(4)
          .onClick(() => {
            this.onReset();
          })
      }
      Button(this.isLoggedIn ? this.accountLabel() : '登录')
        .height(36)
        .fontSize(13)
        .fontColor(this.isLoggedIn ? COLOR_TEXT : '#FFFFFF')
        .backgroundColor(this.isLoggedIn ? COLOR_PRIMARY_SOFT : COLOR_PRIMARY)
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
    .height(72)
    .padding({ left: 28, right: 28 })
    .backgroundColor(COLOR_SURFACE)
    .border({ width: { bottom: 1 }, color: COLOR_BORDER })
  }
}
