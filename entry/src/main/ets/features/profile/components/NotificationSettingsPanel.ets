import {
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  COLOR_TEXT
} from '../../../shared/Theme';

PersistentStorage.persistProp<boolean>('xiaoHuiTong.notifications.deadline', true);
PersistentStorage.persistProp<boolean>('xiaoHuiTong.notifications.application', true);
PersistentStorage.persistProp<boolean>('xiaoHuiTong.notifications.task', true);
PersistentStorage.persistProp<boolean>('xiaoHuiTong.notifications.activity', true);

@Component
export struct NotificationSettingsPanel {
  @StorageLink('xiaoHuiTong.notifications.deadline') deadlineEnabled: boolean = true;
  @StorageLink('xiaoHuiTong.notifications.application') applicationEnabled: boolean = true;
  @StorageLink('xiaoHuiTong.notifications.task') taskEnabled: boolean = true;
  @StorageLink('xiaoHuiTong.notifications.activity') activityEnabled: boolean = true;
  @State saved: boolean = false;
  onBack: () => void = () => {};

  @Builder
  SettingRow(title: string, caption: string, value: boolean, onChange: (checked: boolean) => void) {
    Row({ space: 12 }) {
      Column({ space: 4 }) {
        Text(title).fontSize(15).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        Text(caption).fontSize(12).fontColor(COLOR_MUTED)
      }
      .layoutWeight(1).alignItems(HorizontalAlign.Start)
      Toggle({ type: ToggleType.Switch, isOn: value })
        .selectedColor(COLOR_PRIMARY)
        .onChange((checked: boolean) => { onChange(checked); this.saved = false; })
    }
    .width('100%').padding({ top: 14, bottom: 14 })
  }

  build() {
    Column({ space: 16 }) {
      Button('返回个人中心').height(36).fontSize(13).fontColor(COLOR_PRIMARY).backgroundColor(Color.Transparent)
        .onClick(() => { this.onBack(); })
      Column({ space: 5 }) {
        Text('通知设置').fontSize(24).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Text('设置会保存在当前设备，关闭后不再产生对应提醒。').fontSize(13).fontColor(COLOR_MUTED)
      }
      .width('100%').alignItems(HorizontalAlign.Start)
      Column() {
        this.SettingRow('截止提醒', '比赛报名、资料提交和关键里程碑', this.deadlineEnabled,
          (checked: boolean) => { this.deadlineEnabled = checked; })
        Divider().color(COLOR_BORDER)
        this.SettingRow('申请状态', '队伍申请、活动报名和指导邀请', this.applicationEnabled,
          (checked: boolean) => { this.applicationEnabled = checked; })
        Divider().color(COLOR_BORDER)
        this.SettingRow('项目任务', '指派、退回、阻塞和验收结果', this.taskEnabled,
          (checked: boolean) => { this.taskEnabled = checked; })
        Divider().color(COLOR_BORDER)
        this.SettingRow('活动现场', '班次、签到和临时调整', this.activityEnabled,
          (checked: boolean) => { this.activityEnabled = checked; })
      }
      .width('100%').padding({ left: 18, right: 18 }).backgroundColor(COLOR_SURFACE)
      .border({ width: 1, color: COLOR_BORDER }).borderRadius(8)
      Button('保存通知设置').width('100%').height(44).fontSize(14).fontColor('#FFFFFF')
        .backgroundColor(COLOR_PRIMARY).borderRadius(5).onClick(() => { this.saved = true; })
      if (this.saved) {
        Text('设置已保存').width('100%').textAlign(TextAlign.Center).fontSize(12).fontColor(COLOR_PRIMARY)
          .backgroundColor(COLOR_PRIMARY_SOFT).padding(10).borderRadius(5)
      }
    }
    .width('100%').alignItems(HorizontalAlign.Start)
  }
}
