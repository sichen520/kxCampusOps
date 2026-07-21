import { DISCUSSION_BOARDS, RESOURCE_CATEGORIES, RESOURCE_TYPES } from '../../../data/MockCampusData';
import { DiscussionPost, KnowledgeResource } from '../../../domain/WorkflowModels';
import { StatusPill } from '../../../shared/components/StatusPill';
import { formatLocalMinute } from '../../../shared/DateTime';
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

@Component
export struct KnowledgeComposer {
  @Prop isResource: boolean = true;
  @State title: string = '';
  @State summary: string = '';
  @State categoryIndex: number = 0;
  @State typeIndex: number = 0;
  @State customCategory: string = '';
  @State customType: string = '';
  @State validationMessage: string = '';
  onClose: () => void = () => {};
  onResourcePublished: (resource: KnowledgeResource) => void = (_resource: KnowledgeResource) => {};
  onDiscussionPublished: (post: DiscussionPost) => void = (_post: DiscussionPost) => {};

  private categoryOptions(): string[] {
    return this.isResource ? RESOURCE_CATEGORIES : DISCUSSION_BOARDS;
  }

  private selectedCategory(): string {
    const options: string[] = this.categoryOptions();
    return this.isResource && options[this.categoryIndex] === '其他' ? this.customCategory.trim() :
      options[this.categoryIndex];
  }

  private selectedType(): string {
    return RESOURCE_TYPES[this.typeIndex] === '其他' ? this.customType.trim() : RESOURCE_TYPES[this.typeIndex];
  }

  private publish(): void {
    if (this.title.trim().length === 0 || this.summary.trim().length === 0) {
      this.validationMessage = '请先填写标题和内容说明。';
      return;
    }
    if (this.selectedCategory().length === 0 || (this.isResource && this.selectedType().length === 0)) {
      this.validationMessage = '选择“其他”时，请填写自定义主题或资料类型。';
      return;
    }
    if (this.isResource) {
      const resource: KnowledgeResource = {
        id: `resource-local-${Date.now()}`,
        category: this.selectedCategory(),
        resourceType: this.selectedType(),
        title: this.title.trim(),
        summary: this.summary.trim(),
        author: '当前账号',
        courseName: '待补充课程',
        college: '当前学院',
        major: '当前专业',
        teacherName: '待补充',
        permission: '全校公开',
        tags: ['新发布', this.selectedCategory()],
        viewCount: 0,
        downloadCount: 0,
        favoriteCount: 0,
        averageRating: 0,
        ratingCount: 0,
        createdAt: formatLocalMinute(new Date()),
        fileName: '未附带实体附件'
      };
      this.onResourcePublished(resource);
    } else {
      const post: DiscussionPost = {
        id: `discussion-local-${Date.now()}`,
        board: this.selectedCategory(),
        postType: '技术讨论',
        title: this.title.trim(),
        content: this.summary.trim(),
        author: '当前账号',
        tags: [this.selectedCategory()],
        status: '讨论中',
        viewCount: 0,
        replyCount: 0,
        createdAt: formatLocalMinute(new Date())
      };
      this.onDiscussionPublished(post);
    }
  }

  @Builder
  CategoryPicker() {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
      ForEach(this.categoryOptions(), (category: string, index: number) => {
        Button(category)
          .height(32).fontSize(11)
          .fontColor(this.categoryIndex === index ? COLOR_PRIMARY : COLOR_MUTED)
          .backgroundColor(this.categoryIndex === index ? COLOR_PRIMARY_SOFT : COLOR_SURFACE)
          .border({ width: 1, color: this.categoryIndex === index ? COLOR_PRIMARY : COLOR_BORDER })
          .borderRadius(4)
          .margin({ right: 6, bottom: 6 })
          .onClick(() => { this.categoryIndex = index; })
      }, (category: string) => category)
    }
    .width('100%')
  }

  @Builder
  TypePicker() {
    if (this.isResource) {
      Column({ space: 8 }) {
        Text('资料类型').fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
          ForEach(RESOURCE_TYPES, (type: string, index: number) => {
            Button(type)
              .height(32).fontSize(11)
              .fontColor(this.typeIndex === index ? COLOR_PRIMARY : COLOR_MUTED)
              .backgroundColor(this.typeIndex === index ? COLOR_PRIMARY_SOFT : COLOR_SURFACE)
              .border({ width: 1, color: this.typeIndex === index ? COLOR_PRIMARY : COLOR_BORDER })
              .borderRadius(4)
              .margin({ right: 6, bottom: 6 })
              .onClick(() => { this.typeIndex = index; })
          }, (type: string) => type)
        }
        .width('100%')
        if (RESOURCE_TYPES[this.typeIndex] === '其他') {
          TextInput({ placeholder: '填写自定义资料类型', text: this.customType })
            .width('100%').height(42).backgroundColor(COLOR_SURFACE)
            .border({ width: 1, color: COLOR_BORDER }).borderRadius(4)
            .onChange((value: string) => { this.customType = value; })
        }
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
  }

  build() {
    Column({ space: 14 }) {
      Button('返回知享').height(34).fontSize(13).fontColor(COLOR_PRIMARY).backgroundColor(Color.Transparent)
        .onClick(() => { this.onClose(); })
      Row({ space: 8 }) {
        StatusPill({ text: this.isResource ? '资源发布' : '讨论发布', fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
        Text(this.isResource ? '分享一份可复用的学习资料' : '发起一个技术问题或经验讨论')
          .fontSize(13).fontColor(COLOR_MUTED)
      }
      .width('100%')
      Text(this.isResource ? '发布资源' : '发布讨论').fontSize(24).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      Column({ space: 12 }) {
        TextInput({ placeholder: this.isResource ? '资源标题' : '讨论标题', text: this.title })
          .width('100%').height(46).backgroundColor(COLOR_SURFACE).border({ width: 1, color: COLOR_BORDER }).borderRadius(4)
          .onChange((value: string) => { this.title = value; })
        TextArea({ placeholder: this.isResource ? '说明资源内容、适用课程和使用注意事项' : '把问题、背景和你已经尝试过的方案写清楚', text: this.summary })
          .width('100%').height(120).backgroundColor(COLOR_SURFACE).border({ width: 1, color: COLOR_BORDER }).borderRadius(4)
          .onChange((value: string) => { this.summary = value; })
        Text(this.isResource ? '主题分类' : '讨论版块').fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        this.CategoryPicker()
        if (this.isResource && RESOURCE_CATEGORIES[this.categoryIndex] === '其他') {
          TextInput({ placeholder: '填写自定义主题，例如网络安全、数字媒体', text: this.customCategory })
            .width('100%').height(42).backgroundColor(COLOR_SURFACE)
            .border({ width: 1, color: COLOR_BORDER }).borderRadius(4)
            .onChange((value: string) => { this.customCategory = value; })
        }
        this.TypePicker()
        if (this.isResource) {
          Row() {
            Text('附件状态').fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
            Blank()
            StatusPill({ text: '演示包未附带附件', fillColor: COLOR_AMBER_SOFT, textColor: COLOR_AMBER })
          }
          .width('100%')
          .height(42)
        }
        if (this.validationMessage.length > 0) {
          Text(this.validationMessage).fontSize(12).fontColor(COLOR_AMBER)
        }
        Button(this.isResource ? '提交资源' : '发布讨论')
          .width('100%').height(46).fontSize(14).fontColor('#FFFFFF').backgroundColor(COLOR_PRIMARY).borderRadius(4)
          .onClick(() => { this.publish(); })
      }
      .width('100%')
      .padding(18)
      .backgroundColor(COLOR_SURFACE)
      .border({ width: 1, color: COLOR_BORDER })
      .borderRadius(6)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
