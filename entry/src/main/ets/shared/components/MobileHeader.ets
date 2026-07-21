import { DemoAccount } from '../../domain/WorkflowModels';
import {
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
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

  private accountLabel(): string {
    return this.accountDisplayName;
  }

  build() {
    Row() {
      Column({ space: 2 }) {
        Text('可行 CampusOps')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT)
        Text('把机会推进到结果')
          .fontSize(12)
          .fontColor(COLOR_MUTED)
      }
      .alignItems(HorizontalAlign.Start)

      Blank()

      if (this.selectedTab === 1) {
        Button('重置流程')
          .fontSize(13)
          .fontColor(COLOR_PRIMARY)
          .backgroundColor(COLOR_PRIMARY_SOFT)
          .borderRadius(4)
          .height(36)
          .onClick(() => {
            this.onReset();
          })
      }
      Button(this.isLoggedIn ? this.accountLabel() : '登录')
          .fontSize(13)
          .fontColor(this.isLoggedIn ? COLOR_PRIMARY : '#FFFFFF')
          .backgroundColor(this.isLoggedIn ? COLOR_PRIMARY_SOFT : COLOR_PRIMARY)
          .borderRadius(4)
          .height(36)
          .margin({ left: 8 })
          .onClick(() => {
            if (this.isLoggedIn) {
              this.onSwitchAccount();
            } else {
              this.onLogin();
            }
          })
    }
    .width('100%')
    .height(68)
    .padding({ left: 20, right: 20 })
    .backgroundColor(COLOR_SURFACE)
    .border({ width: { bottom: 1 }, color: COLOR_BORDER })
  }
}
