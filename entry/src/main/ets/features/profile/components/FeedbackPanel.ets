import {
  COLOR_AMBER,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  COLOR_TEXT
} from '../../../shared/Theme';

PersistentStorage.persistProp<string>('kxCampusOps.feedback.lastReceipt', '');

@Component
export struct FeedbackPanel {
  @StorageLink('kxCampusOps.feedback.lastReceipt') lastReceipt: string = '';
  @State category: string = '功能问题';
  @State content: string = '';
  @State contact: string = '';
  @State message: string = '';
  onBack: () => void = () => {};

  private submit(): void {
    if (this.content.trim().length < 5) {
      this.message = '请至少填写 5 个字的问题说明。';
      return;
    }
    const receipt: string = `KX-${Date.now()}`;
    this.lastReceipt = receipt;
    this.message = `反馈已保存到本地队列，编号 ${receipt}`;
    this.content = '';
  }

  build() {
    Column({ space: 16 }) {
      Button('返回个人中心').height(36).fontSize(13).fontColor(COLOR_PRIMARY).backgroundColor(Color.Transparent)
        .onClick(() => { this.onBack(); })
      Column({ space: 5 }) {
        Text('帮助与反馈').fontSize(24).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Text('Demo 会把反馈保存到本地队列；接入服务端后再同步给管理员。').fontSize(13).fontColor(COLOR_MUTED)
      }
      .width('100%').alignItems(HorizontalAlign.Start)
      Column({ space: 12 }) {
        Text('问题类型').fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        Select([{ value: '功能问题' }, { value: '界面问题' }, { value: '数据问题' }, { value: '建议与需求' }])
          .width('100%').height(42).value(this.category)
          .backgroundColor(COLOR_SURFACE).border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
          .onSelect((_index: number, value: string) => { this.category = value; })
        TextArea({ placeholder: '说明发生了什么、所在页面和期望结果', text: this.content })
          .width('100%').height(130).backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
          .onChange((value: string) => { this.content = value; this.message = ''; })
        TextInput({ placeholder: '联系方式（可选）', text: this.contact })
          .width('100%').height(42).backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER }).borderRadius(5)
          .onChange((value: string) => { this.contact = value; })
        Button('提交反馈').width('100%').height(44).fontSize(14).fontColor('#FFFFFF')
          .backgroundColor(COLOR_PRIMARY).borderRadius(5).onClick(() => { this.submit(); })
        if (this.message.length > 0) {
          Text(this.message).fontSize(12).fontColor(this.message.startsWith('反馈已保存') ? COLOR_PRIMARY : COLOR_AMBER)
        }
      }
      .width('100%').padding(18).backgroundColor(COLOR_SURFACE)
      .border({ width: 1, color: COLOR_BORDER }).borderRadius(8).alignItems(HorizontalAlign.Start)
      if (this.lastReceipt.length > 0) {
        Text(`最近一次本地反馈：${this.lastReceipt}`).fontSize(12).fontColor(COLOR_MUTED)
      }
      Text('当前版本：0.1.0 Demo · HarmonyOS API 24').fontSize(12).fontColor(COLOR_MUTED)
    }
    .width('100%').alignItems(HorizontalAlign.Start)
  }
}
