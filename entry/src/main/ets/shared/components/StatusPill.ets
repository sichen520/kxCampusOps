@Component
export struct StatusPill {
  @Prop text: string = '';
  @Prop fillColor: string = '#EEF0ED';
  @Prop textColor: string = '#68706A';

  build() {
    Text(this.text)
      .fontSize(12)
      .fontWeight(FontWeight.Medium)
      .fontColor(this.textColor)
      .backgroundColor(this.fillColor)
      .borderRadius(3)
      .padding({ left: 7, right: 7, top: 3, bottom: 3 })
  }
}
