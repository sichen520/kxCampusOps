import {
  COLOR_AMBER,
  COLOR_AMBER_SOFT,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  COLOR_TEXT
} from '../../../shared/Theme';

PersistentStorage.persistProp<boolean>('xiaoHuiTong.privacy.evidence', true);
PersistentStorage.persistProp<boolean>('xiaoHuiTong.privacy.contact', false);
PersistentStorage.persistProp<boolean>('xiaoHuiTong.privacy.aiData', false);
PersistentStorage.persistProp<boolean>('xiaoHuiTong.privacy.publicProfile', true);

@Component
export struct PrivacySettingsPanel {
  @StorageLink('xiaoHuiTong.privacy.evidence') evidenceEnabled: boolean = true;
  @StorageLink('xiaoHuiTong.privacy.contact') contactEnabled: boolean = false;
  @StorageLink('xiaoHuiTong.privacy.aiData') aiDataEnabled: boolean = false;
  @StorageLink('xiaoHuiTong.privacy.publicProfile') publicProfileEnabled: boolean = true;
  @State saved: boolean = false;
  onBack: () => void = () => {};

  @Builder
  SettingRow(title: string, caption: string, value: boolean, onChange: (checked: boolean) => void) {
    Row({ space: 12 }) {
      Column({ space: 4 }) {
        Text(title).fontSize(15).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        Text(caption).fontSize(12).lineHeight(18).fontColor(COLOR_MUTED)
      }
      .layoutWeight(1).alignItems(HorizontalAlign.Start)
      Toggle({ type: ToggleType.Switch, isOn: value }).selectedColor(COLOR_PRIMARY)
        .onChange((checked: boolean) => { onChange(checked); this.saved = false; })
    }
    .width('100%').padding({ top: 14, bottom: 14 })
  }

  build() {
    Column({ space: 16 }) {
      Button('返回个人中心').height(36).fontSize(13).fontColor(COLOR_PRIMARY).backgroundColor(Color.Transparent)
        .onClick(() => { this.onBack(); })
      Column({ space: 5 }) {
        Text('隐私与授权').fontSize(24).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Text('队伍负责人只能看到你主动授权的资料。').fontSize(13).fontColor(COLOR_MUTED)
      }
      .width('100%').alignItems(HorizontalAlign.Start)
      Row({ space: 8 }) {
        Text('授权原则').fontSize(11).fontColor(COLOR_AMBER).backgroundColor(COLOR_AMBER_SOFT)
          .borderRadius(3).padding({ left: 7, right: 7, top: 4, bottom: 4 })
        Text('AI 数据处理默认关闭，每次外发仍需单独确认。').layoutWeight(1).fontSize(12).fontColor(COLOR_TEXT)
      }
      .width('100%').padding(12).backgroundColor(COLOR_AMBER_SOFT).borderRadius(6)
      Column() {
        this.SettingRow('公开能力证据', '申请队伍时允许负责人查看已选择的作品和验证记录', this.evidenceEnabled,
          (checked: boolean) => { this.evidenceEnabled = checked; })
        Divider().color(COLOR_BORDER)
        this.SettingRow('公开联系方式', '仅向已经完成双向确认的队伍成员展示', this.contactEnabled,
          (checked: boolean) => { this.contactEnabled = checked; })
        Divider().color(COLOR_BORDER)
        this.SettingRow('允许外部 AI 处理私有资料', '实际调用前仍展示供应商、数据范围和留存策略', this.aiDataEnabled,
          (checked: boolean) => { this.aiDataEnabled = checked; })
        Divider().color(COLOR_BORDER)
        this.SettingRow('公开基础档案', '允许校内用户检索姓名、学院和公开技能', this.publicProfileEnabled,
          (checked: boolean) => { this.publicProfileEnabled = checked; })
      }
      .width('100%').padding({ left: 18, right: 18 }).backgroundColor(COLOR_SURFACE)
      .border({ width: 1, color: COLOR_BORDER }).borderRadius(8)
      Button('保存隐私设置').width('100%').height(44).fontSize(14).fontColor('#FFFFFF')
        .backgroundColor(COLOR_PRIMARY).borderRadius(5).onClick(() => { this.saved = true; })
      if (this.saved) {
        Text('隐私设置已保存').width('100%').textAlign(TextAlign.Center).fontSize(12).fontColor(COLOR_PRIMARY)
          .backgroundColor(COLOR_PRIMARY_SOFT).padding(10).borderRadius(5)
      }
    }
    .width('100%').alignItems(HorizontalAlign.Start)
  }
}
