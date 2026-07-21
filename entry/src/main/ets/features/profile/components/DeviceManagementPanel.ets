import { StatusPill } from '../../../shared/components/StatusPill';
import {
  COLOR_AMBER,
  COLOR_AMBER_SOFT,
  COLOR_BLUE,
  COLOR_BLUE_SOFT,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_RED,
  COLOR_RED_SOFT,
  COLOR_SURFACE,
  COLOR_TEXT
} from '../../../shared/Theme';

PersistentStorage.persistProp<boolean>('kxCampusOps.devices.phoneActive', true);

@Component
export struct DeviceManagementPanel {
  @StorageLink('kxCampusOps.devices.phoneActive') phoneActive: boolean = true;
  @State refreshed: boolean = false;
  onBack: () => void = () => {};

  @Builder
  DeviceRow(name: string, detail: string, current: boolean) {
    Row({ space: 12 }) {
      Text(current ? 'PC' : '手机')
        .width(42).height(42).textAlign(TextAlign.Center).padding({ top: 11 })
        .fontSize(12).fontWeight(FontWeight.Bold)
        .fontColor(current ? COLOR_PRIMARY : COLOR_BLUE)
        .backgroundColor(current ? COLOR_PRIMARY_SOFT : COLOR_BLUE_SOFT).borderRadius(7)
      Column({ space: 4 }) {
        Text(name).fontSize(15).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        Text(detail).fontSize(12).fontColor(COLOR_MUTED)
      }
      .layoutWeight(1).alignItems(HorizontalAlign.Start)
      if (current) {
        StatusPill({ text: '当前设备', fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
      } else {
        Button('下线').height(34).fontSize(12).fontColor(COLOR_RED).backgroundColor(COLOR_RED_SOFT).borderRadius(4)
          .onClick(() => { this.phoneActive = false; })
      }
    }
    .width('100%').padding(16).backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER }).borderRadius(7)
  }

  build() {
    Column({ space: 16 }) {
      Button('返回个人中心').height(36).fontSize(13).fontColor(COLOR_PRIMARY).backgroundColor(Color.Transparent)
        .onClick(() => { this.onBack(); })
      Column({ space: 5 }) {
        Text('登录设备').fontSize(24).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Text('发现陌生设备时可以立即撤销其演示会话。').fontSize(13).fontColor(COLOR_MUTED)
      }
      .width('100%').alignItems(HorizontalAlign.Start)
      this.DeviceRow('HarmonyOS PC 工作区', '当前 DevEco Preview 会话 · 刚刚活跃', true)
      if (this.phoneActive) {
        this.DeviceRow('HarmonyOS 手机', '校园网 · 2026-07-21 10:32', false)
      } else {
        Row({ space: 8 }) {
          StatusPill({ text: '已下线', fillColor: COLOR_AMBER_SOFT, textColor: COLOR_AMBER })
          Text('HarmonyOS 手机会话已被撤销。').fontSize(13).fontColor(COLOR_TEXT)
        }
        .width('100%').padding(14).backgroundColor(COLOR_AMBER_SOFT).borderRadius(6)
      }
      Button('刷新设备列表').width('100%').height(42).fontSize(13)
        .fontColor(COLOR_PRIMARY).backgroundColor(COLOR_PRIMARY_SOFT).borderRadius(5)
        .onClick(() => { this.refreshed = true; })
      if (this.refreshed) {
        Text('设备列表已刷新').width('100%').textAlign(TextAlign.Center).fontSize(12).fontColor(COLOR_PRIMARY)
      }
    }
    .width('100%').alignItems(HorizontalAlign.Start)
  }
}
