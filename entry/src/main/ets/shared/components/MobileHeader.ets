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
  @State resetPressed: boolean = false;
  @State accountPressed: boolean = false;
  onReset: () => void = () => {};
  onLogin: () => void = () => {};
  onSwitchAccount: () => void = () => {};

  private accountLabel(): string {
    return this.accountDisplayName.length > 0 ? this.accountDisplayName : '账号';
  }

  private sectionLabel(): string {
    if (this.selectedTab === 1) {
      return '机会判断';
    }
    if (this.selectedTab === 2) {
      return '知识共享';
    }
    if (this.selectedTab === 3) {
      return '我的队伍';
    }
    if (this.selectedTab === 4) {
      return '项目执行';
    }
    if (this.selectedTab === 5) {
      return '个人中心';
    }
    if (this.selectedTab === 6) {
      return '平台管理';
    }
    return '校园机会';
  }

  build() {
    Row() {
      Row({ space: 9 }) {
        Column()
          .width(7).height(7).borderRadius(4).backgroundColor(COLOR_PRIMARY)
        Column({ space: 1 }) {
          Text('校汇通')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_TEXT)
          Text(this.sectionLabel())
            .fontSize(12)
            .fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
      }

      Blank()

      if (this.selectedTab === 1) {
        Button('重置')
          .fontSize(12)
          .fontColor(COLOR_PRIMARY)
          .backgroundColor(COLOR_PRIMARY_SOFT)
          .borderRadius(6)
          .height(34)
          .scale({ x: this.resetPressed ? 0.95 : 1, y: this.resetPressed ? 0.95 : 1 })
          .animation({ duration: 120, curve: Curve.EaseOut })
          .onTouch((event: TouchEvent) => {
            this.resetPressed = event.type === TouchType.Down;
          })
          .onClick(() => {
            this.onReset();
          })
      }
      Button(this.isLoggedIn ? this.accountLabel() : '登录')
          .fontSize(12)
          .fontColor(this.isLoggedIn ? COLOR_PRIMARY : '#FFFFFF')
          .backgroundColor(this.isLoggedIn ? COLOR_PRIMARY_SOFT : COLOR_PRIMARY)
          .borderRadius(6)
          .height(34)
          .margin({ left: 7 })
          .scale({ x: this.accountPressed ? 0.95 : 1, y: this.accountPressed ? 0.95 : 1 })
          .animation({ duration: 120, curve: Curve.EaseOut })
          .onTouch((event: TouchEvent) => {
            this.accountPressed = event.type === TouchType.Down;
          })
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
    .padding({ left: 16, right: 16 })
    .backgroundColor(COLOR_SURFACE)
    .border({ width: { bottom: 1 }, color: COLOR_BORDER })
  }
}
