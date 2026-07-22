@Component
export struct StatusPill {
  @Prop text: string = '';
  @Prop fillColor: string = '#EEF0ED';
  @Prop textColor: string = '#68706A';

  build() {
    Text(this.text)
      .fontSize(11)
      .fontWeight(FontWeight.Medium)
      .fontColor(this.textColor)
      .letterSpacing(0.3)
      .backgroundColor(this.fillColor)
      .border({ width: { left: 2 }, color: this.textColor })
      .borderRadius(2)
      .padding({ left: 7, right: 8, top: 3, bottom: 3 })
  }
}
