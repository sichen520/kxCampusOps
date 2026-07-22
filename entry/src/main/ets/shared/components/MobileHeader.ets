import { DemoAccount } from '../../domain/WorkflowModels';
import {
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_SURFACE,
  COLOR_SURFACE_ALT,
  COLOR_TEXT
} from '../Theme';

@Component
export struct MobileHeader {
  @Prop selectedTab: number = 0;
  @Prop isLoggedIn: boolean = false;
  @Prop demoAccount: DemoAccount = DemoAccount.STUDENT_APPLICANT;
  @Prop accountDisplayName: string = '';
  onReset: () => void = () => {};
  onLogin: () => void = () => {};
  onSwitchAccount: () => void = () => {};

  private currentSection(): string {
    const names: string[] = ['机会', '可行性', '知享', '队伍', '执行', '我的', '管理'];
    return names[this.selectedTab];
  }

  build() {
    Row({ space: 8 }) {
      Text('行')
        .width(30)
        .height(30)
        .textAlign(TextAlign.Center)
        .padding({ top: 4 })
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .backgroundColor(COLOR_PRIMARY)
        .borderRadius(4)
      Column({ space: 1 }) {
        Text('可行')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT)
          .letterSpacing(0.3)
        Text(this.currentSection())
          .fontSize(10)
          .fontColor(COLOR_MUTED)
          .letterSpacing(0.5)
      }
      .alignItems(HorizontalAlign.Start)

      Blank()

      if (this.selectedTab === 1) {
        Button('重置')
          .width(52)
          .height(32)
          .fontSize(12)
          .fontColor(COLOR_PRIMARY)
          .backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER })
          .borderRadius(4)
          .onClick(() => {
            this.onReset();
          })
      }
      Button(this.isLoggedIn ? '切换' : '登录')
        .width(52)
        .height(32)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.isLoggedIn ? COLOR_TEXT : '#FFFFFF')
        .backgroundColor(this.isLoggedIn ? COLOR_SURFACE_ALT : COLOR_PRIMARY)
        .border({ width: 1, color: this.isLoggedIn ? COLOR_BORDER : COLOR_PRIMARY })
        .borderRadius(4)
        .onClick(() => {
          if (this.isLoggedIn) {
            this.onSwitchAccount();
          } else {
            this.onLogin();
          }
        })
    }
    .width('100%')
    .height(60)
    .padding({ left: 14, right: 14 })
    .backgroundColor(COLOR_SURFACE)
    .border({ width: { bottom: 1 }, color: COLOR_BORDER })
  }
}
