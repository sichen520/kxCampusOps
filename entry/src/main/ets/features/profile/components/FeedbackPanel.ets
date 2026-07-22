import {
  COLOR_AMBER,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  COLOR_TEXT
} from '../../../shared/Theme';
import { formatLocalMinute } from '../../../shared/DateTime';
import {
  FeedbackRecord,
  createFeedbackRecord,
  enqueueFeedback,
  feedbackValidationMessage
} from '../domain/FeedbackQueue';

PersistentStorage.persistProp<FeedbackRecord[]>('xiaoHuiTong.feedback.records.v1', []);

@Component
export struct FeedbackPanel {
  @StorageLink('xiaoHuiTong.feedback.records.v1') records: FeedbackRecord[] = [];
  @State category: string = '功能问题';
  @State content: string = '';
  @State contact: string = '';
  @State message: string = '';
  onBack: () => void = () => {};

  private submit(): void {
    const validationMessage: string = feedbackValidationMessage(this.content);
    if (validationMessage.length > 0) {
      this.message = validationMessage;
      return;
    }
    const receipt: string = `XHT-${Date.now()}`;
    const record: FeedbackRecord = createFeedbackRecord(
      receipt, this.category, this.content, this.contact, formatLocalMinute(new Date()));
    this.records = enqueueFeedback(this.records, record);
    this.message = `反馈已保存到本地队列，编号 ${receipt}`;
    this.content = '';
    this.contact = '';
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
          .maxLength(500)
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
      if (this.records.length > 0) {
        Column({ space: 10 }) {
          Row() {
            Text(`本地反馈队列 · ${this.records.length} 条`)
              .fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
            Blank()
            Button('清空记录').height(32).fontSize(12).fontColor(COLOR_AMBER)
              .backgroundColor(Color.Transparent)
              .onClick(() => {
                this.records = [];
                this.message = '本地反馈记录已清空。';
              })
          }
          .width('100%')
          ForEach(this.records.slice(0, 5), (record: FeedbackRecord) => {
            Column({ space: 5 }) {
              Row() {
                Text(record.category).fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
                Blank()
                Text(record.syncState).fontSize(11).fontColor(COLOR_AMBER)
              }
              .width('100%')
              Text(record.content).fontSize(13).lineHeight(19).fontColor(COLOR_MUTED)
                .maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })
              Text(`${record.id} · ${record.createdAt}`).fontSize(11).fontColor(COLOR_MUTED)
            }
            .width('100%')
            .padding({ top: 10, bottom: 10 })
            .border({ width: { top: 1 }, color: COLOR_BORDER })
            .alignItems(HorizontalAlign.Start)
          }, (record: FeedbackRecord) => record.id)
        }
        .width('100%')
        .padding(18)
        .backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_BORDER })
        .borderRadius(8)
        .alignItems(HorizontalAlign.Start)
      }
      Text('当前版本：0.1.0 Demo · HarmonyOS API 24').fontSize(12).fontColor(COLOR_MUTED)
    }
    .width('100%').alignItems(HorizontalAlign.Start)
  }
}
