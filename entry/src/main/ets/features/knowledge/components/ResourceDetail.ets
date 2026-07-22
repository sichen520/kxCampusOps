import { common } from '@kit.AbilityKit';
import { KnowledgeResource, ResourceComment } from '../../../domain/WorkflowModels';
import { StatusPill } from '../../../shared/components/StatusPill';
import {
  AttachmentExportResult,
  exportBundledAttachment
} from '../services/BundledAttachmentExporter';
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

@Component
export struct ResourceDetail {
  @Prop resource: KnowledgeResource;
  @Prop isLoggedIn: boolean = false;
  @Prop isWide: boolean = false;
  @Prop isSaved: boolean = false;
  @Prop isReported: boolean = false;
  @Prop selectedRating: number = 0;
  @Prop comments: ResourceComment[] = [];
  @State commentText: string = '';
  @State notice: string = '';
  onBack: () => void = () => {};
  onRequireLogin: () => void = () => {};
  onFavorite: () => void = () => {};
  onDownload: () => void = () => {};
  onRate: (score: number) => void = (_score: number) => {};
  onComment: (content: string) => void = (_content: string) => {};
  onReport: () => void = () => {};

  private interact(action: () => void, notice: string): void {
    if (!this.isLoggedIn) {
      this.onRequireLogin();
      return;
    }
    action();
    this.notice = notice;
  }

  private attachmentRawFile(): string {
    return this.resource.attachmentRawFile === undefined ? '' : this.resource.attachmentRawFile;
  }

  private hasAttachment(): boolean {
    return this.attachmentRawFile().trim().length > 0;
  }

  private async saveAttachment(): Promise<void> {
    if (!this.isLoggedIn) {
      this.onRequireLogin();
      return;
    }
    const context = this.getUIContext().getHostContext();
    if (context === undefined || !this.hasAttachment()) {
      this.notice = '附件不可用，请稍后重试。';
      return;
    }
    this.notice = '请选择 PDF 保存位置。';
    const result: AttachmentExportResult = await exportBundledAttachment(
      context as common.UIAbilityContext, this.attachmentRawFile(), this.resource.fileName);
    if (result === AttachmentExportResult.SAVED) {
      this.onDownload();
      this.notice = `附件已保存：${this.resource.fileName}`;
    } else if (result === AttachmentExportResult.CANCELLED) {
      this.notice = '已取消保存附件。';
    } else {
      this.notice = '附件保存失败，请检查存储空间后重试。';
    }
  }

  @Builder
  MetaRow(label: string, value: string) {
    Row() {
      Text(label).width(74).fontSize(12).fontColor(COLOR_MUTED)
      Text(value).layoutWeight(1).fontSize(13).fontColor(COLOR_TEXT)
    }
    .width('100%')
    .padding({ top: 7, bottom: 7 })
  }

  @Builder
  MainDetail() {
    Column({ space: 8 }) {
      this.MetaRow('学院', this.resource.college)
      Divider().color(COLOR_BORDER)
      this.MetaRow('专业', this.resource.major)
      Divider().color(COLOR_BORDER)
      this.MetaRow('课程', this.resource.courseName)
      Divider().color(COLOR_BORDER)
      this.MetaRow('任课教师', this.resource.teacherName)
      Divider().color(COLOR_BORDER)
      this.MetaRow('可见范围', this.resource.permission)
      Divider().color(COLOR_BORDER)
      this.MetaRow('附件名称', this.resource.fileName)
      if (this.hasAttachment()) {
        Text('实体 PDF 已随应用内置，可保存到本机。')
          .fontSize(12).fontColor(COLOR_PRIMARY).padding({ top: 4, bottom: 4 })
      } else {
        Text('当前演示包未附带实体附件，暂不提供下载。')
          .fontSize(12).fontColor(COLOR_AMBER).padding({ top: 4, bottom: 4 })
      }
      Text('资源简介').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT).margin({ top: 10 })
      Text(this.resource.summary).fontSize(14).lineHeight(22).fontColor(COLOR_MUTED)
      Row({ space: 6 }) {
        ForEach(this.resource.tags, (tag: string) => {
          Text(tag).fontSize(11).fontColor(COLOR_BLUE).padding({ left: 7, right: 7, top: 4, bottom: 4 })
            .backgroundColor(COLOR_BLUE_SOFT).borderRadius(3)
        }, (tag: string) => tag)
      }
      .width('100%')
    }
    .width('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER })
    .borderRadius(6)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  SideActions() {
    Column({ space: 12 }) {
      Text('资源数据').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      Row() {
        Column({ space: 3 }) {
          Text(this.resource.viewCount.toString()).fontSize(19).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('浏览').fontSize(11).fontColor(COLOR_MUTED)
        }.layoutWeight(1)
        Column({ space: 3 }) {
          Text(this.resource.downloadCount.toString()).fontSize(19).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('下载').fontSize(11).fontColor(COLOR_MUTED)
        }.layoutWeight(1)
        Column({ space: 3 }) {
          Text(this.resource.favoriteCount.toString()).fontSize(19).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('收藏').fontSize(11).fontColor(COLOR_MUTED)
        }.layoutWeight(1)
        Column({ space: 3 }) {
          Text(this.resource.averageRating.toString()).fontSize(19).fontWeight(FontWeight.Bold).fontColor(COLOR_AMBER)
          Text(`${this.resource.ratingCount} 人评分`).fontSize(11).fontColor(COLOR_MUTED)
        }.layoutWeight(1)
      }
      .width('100%')
      Text('我的评分').fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
      Row({ space: 5 }) {
        ForEach([1, 2, 3, 4, 5], (score: number) => {
          Button(score.toString())
            .width(34).height(34).fontSize(12)
            .fontColor(this.selectedRating === score ? '#FFFFFF' : COLOR_AMBER)
            .backgroundColor(this.selectedRating === score ? COLOR_AMBER : COLOR_AMBER_SOFT)
            .borderRadius(17)
            .onClick(() => {
              this.interact(() => { this.onRate(score); }, `已提交 ${score} 分评价`);
            })
        }, (score: number) => score.toString())
      }
      Button(this.isSaved ? '取消收藏' : '收藏资源')
        .width('100%').height(40).fontSize(13).fontColor(COLOR_PRIMARY).backgroundColor(COLOR_PRIMARY_SOFT).borderRadius(4)
        .onClick(() => {
          this.interact(() => { this.onFavorite(); }, this.isSaved ? '已取消收藏' : '已加入收藏');
        })
      if (this.hasAttachment()) {
        Button('保存 PDF 附件')
          .width('100%').height(42).fontSize(13).fontColor('#FFFFFF').backgroundColor(COLOR_PRIMARY).borderRadius(4)
          .onClick(() => { this.saveAttachment(); })
      } else {
        Button('演示包未附带附件')
          .width('100%').height(42).fontSize(13).fontColor(COLOR_MUTED).backgroundColor('#E9EDE9').borderRadius(4)
          .enabled(false)
      }
      Button(this.isReported ? '已举报，等待处理' : '举报资源')
        .width('100%').height(38).fontSize(12).fontColor(COLOR_RED).backgroundColor(COLOR_RED_SOFT).borderRadius(4)
        .enabled(!this.isReported)
        .onClick(() => {
          this.interact(() => { this.onReport(); }, '举报已提交，管理员会保存证据后处理');
        })
    }
    .width('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER })
    .borderRadius(6)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  Comments() {
    Column({ space: 12 }) {
      Row() {
        Text('评论').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Blank()
        Text(`${this.comments.length} 条`).fontSize(12).fontColor(COLOR_MUTED)
      }
      .width('100%')
      Row({ space: 10 }) {
        TextArea({ placeholder: '写下使用体验或补充说明', text: this.commentText })
          .layoutWeight(1).height(74).backgroundColor('#F8FAF7').border({ width: 1, color: COLOR_BORDER }).borderRadius(4)
          .onChange((value: string) => { this.commentText = value; })
        Button('发布评论')
          .width(92).height(40).fontSize(13).fontColor('#FFFFFF').backgroundColor(COLOR_PRIMARY).borderRadius(4)
          .onClick(() => {
            if (!this.isLoggedIn) {
              this.onRequireLogin();
            } else if (this.commentText.trim().length > 0) {
              this.onComment(this.commentText.trim());
              this.commentText = '';
              this.notice = '评论已发布';
            }
          })
      }
      .width('100%')
      ForEach(this.comments, (comment: ResourceComment) => {
        Column({ space: 5 }) {
          Row() {
            Text(comment.author).fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
            Blank()
            Text(comment.createdAt).fontSize(11).fontColor(COLOR_MUTED)
          }
          .width('100%')
          Text(comment.content).fontSize(13).lineHeight(20).fontColor(COLOR_MUTED)
        }
        .width('100%')
        .padding({ top: 10, bottom: 10 })
        .border({ width: { top: 1 }, color: COLOR_BORDER })
        .alignItems(HorizontalAlign.Start)
      }, (comment: ResourceComment) => comment.id)
    }
    .width('100%')
    .padding(18)
    .backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER })
    .borderRadius(6)
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Column({ space: 14 }) {
      Button('返回资源库').height(34).fontSize(13).fontColor(COLOR_PRIMARY).backgroundColor(Color.Transparent)
        .onClick(() => { this.onBack(); })
      Row() {
        Column({ space: 5 }) {
          Row({ space: 8 }) {
            StatusPill({ text: this.resource.category, fillColor: COLOR_BLUE_SOFT, textColor: COLOR_BLUE })
            StatusPill({ text: this.resource.resourceType, fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
          }
          Text(this.resource.title).fontSize(this.isWide ? 24 : 21).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text(`${this.resource.author} · ${this.resource.createdAt}`).fontSize(12).fontColor(COLOR_MUTED)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      if (this.notice.length > 0) {
        Text(this.notice).width('100%').fontSize(13).fontColor(COLOR_PRIMARY).padding(12)
          .backgroundColor(COLOR_PRIMARY_SOFT).borderRadius(4)
      }
      if (this.isWide) {
        Row({ space: 14 }) {
          Column() { this.MainDetail() }.layoutWeight(2)
          Column() { this.SideActions() }.layoutWeight(1)
        }
        .width('100%').alignItems(VerticalAlign.Top)
      } else {
        this.MainDetail()
        this.SideActions()
      }
      this.Comments()
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
