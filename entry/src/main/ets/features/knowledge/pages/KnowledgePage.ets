import {
  DISCUSSION_POSTS,
  KNOWLEDGE_RESOURCES,
  RESOURCE_CATEGORIES,
  RESOURCE_COMMENTS,
  RESOURCE_TYPES
} from '../../../data/MockCampusData';
import {
  DiscussionPost,
  KnowledgeResource,
  ResourceComment
} from '../../../domain/WorkflowModels';
import { DiscussionFeed } from '../components/DiscussionFeed';
import { KnowledgeComposer } from '../components/KnowledgeComposer';
import { ResourceCard } from '../components/ResourceCard';
import { ResourceDetail } from '../components/ResourceDetail';
import {
  ResourceInteraction,
  applyToResource,
  empty,
  findOrCreate,
  rate,
  recordDownload,
  recordView,
  report,
  toggleFavorite as toggleResourceFavorite,
  upsert
} from '../domain/KnowledgeInteractions';
import { formatLocalMinute } from '../../../shared/DateTime';
import {
  COLOR_BLUE,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  COLOR_SURFACE_ALT,
  COLOR_TEXT,
  PAGE_MAX_WIDTH
} from '../../../shared/Theme';

PersistentStorage.persistProp<ResourceInteraction[]>('kxCampusOps.knowledge.interactions.v1', []);
PersistentStorage.persistProp<ResourceComment[]>('kxCampusOps.knowledge.comments.v1', []);

@Component
export struct KnowledgePage {
  @Prop isWide: boolean = false;
  @Prop isLoggedIn: boolean = false;
  @Prop extraResources: KnowledgeResource[] = [];
  @Prop extraDiscussions: DiscussionPost[] = [];
  @State activeMode: number = 0;
  @State query: string = '';
  @State selectedCategory: string = '全部主题';
  @State selectedType: string = '全部类型';
  @State selectedResourceId: string = '';
  @StorageLink('kxCampusOps.knowledge.interactions.v1') interactions: ResourceInteraction[] = [];
  @StorageLink('kxCampusOps.knowledge.comments.v1') localComments: ResourceComment[] = [];
  @State showComposer: boolean = false;
  onRequireLogin: () => void = () => {};
  onResourcePublished: (resource: KnowledgeResource) => void = (_resource: KnowledgeResource) => {};
  onDiscussionPublished: (post: DiscussionPost) => void = (_post: DiscussionPost) => {};

  private allResources(): KnowledgeResource[] {
    return KNOWLEDGE_RESOURCES.concat(this.extraResources).map((resource: KnowledgeResource) =>
      this.resourceWithInteraction(resource));
  }

  private resources(): KnowledgeResource[] {
    const keyword: string = this.query.trim().toLowerCase();
    return this.allResources().filter((resource: KnowledgeResource) => {
      const categoryMatched: boolean = this.selectedCategory === '全部主题' ||
        (this.selectedCategory === '其他' ? RESOURCE_CATEGORIES.indexOf(resource.category) < 0 || resource.category === '其他' :
          resource.category === this.selectedCategory);
      const typeMatched: boolean = this.selectedType === '全部类型' ||
        (this.selectedType === '其他' ? RESOURCE_TYPES.indexOf(resource.resourceType) < 0 || resource.resourceType === '其他' :
          resource.resourceType === this.selectedType);
      const searchableText: string =
        `${resource.title} ${resource.summary} ${resource.tags.join(' ')} ${resource.courseName}`.toLowerCase();
      const keywordMatched: boolean = keyword.length === 0 || searchableText.includes(keyword);
      return categoryMatched && typeMatched && keywordMatched;
    });
  }

  private interaction(resourceId: string): ResourceInteraction {
    return findOrCreate(this.interactions, resourceId);
  }

  private resourceWithInteraction(resource: KnowledgeResource): KnowledgeResource {
    return applyToResource(resource, empty(resource.id), this.interaction(resource.id));
  }

  private categoryCount(category: string): number {
    if (category === '全部主题') {
      return this.allResources().length;
    }
    return this.allResources().filter((resource: KnowledgeResource) => {
      return category === '其他' ? RESOURCE_CATEGORIES.indexOf(resource.category) < 0 || resource.category === '其他' :
        resource.category === category;
    }).length;
  }

  private typeCount(type: string): number {
    if (type === '全部类型') {
      return this.allResources().length;
    }
    return this.allResources().filter((resource: KnowledgeResource) => {
      return type === '其他' ? RESOURCE_TYPES.indexOf(resource.resourceType) < 0 || resource.resourceType === '其他' :
        resource.resourceType === type;
    }).length;
  }

  private resourceComments(resourceId: string): ResourceComment[] {
    return this.localComments.concat(RESOURCE_COMMENTS)
      .filter((comment: ResourceComment) => comment.resourceId === resourceId);
  }

  private isSaved(resourceId: string): boolean {
    return this.interaction(resourceId).favorite;
  }

  private selectedRating(resourceId: string): number {
    return this.interaction(resourceId).rating;
  }

  private isReported(resourceId: string): boolean {
    return this.interaction(resourceId).reported;
  }

  private favoriteCount(): number {
    return this.interactions.filter((interaction: ResourceInteraction) => interaction.favorite).length;
  }

  private recordResourceView(resourceId: string): void {
    this.interactions = upsert(this.interactions, recordView(this.interaction(resourceId)));
  }

  private recordResourceDownload(resourceId: string): void {
    this.interactions = upsert(this.interactions, recordDownload(this.interaction(resourceId)));
  }

  private toggleFavorite(resourceId: string): void {
    this.interactions = upsert(this.interactions,
      toggleResourceFavorite(this.interaction(resourceId)));
  }

  private rateResource(resourceId: string, score: number): void {
    this.interactions = upsert(this.interactions, rate(this.interaction(resourceId), score));
  }

  private reportResource(resourceId: string): void {
    this.interactions = upsert(this.interactions, report(this.interaction(resourceId)));
  }

  private openComposer(): void {
    if (!this.isLoggedIn) {
      this.onRequireLogin();
    } else {
      this.showComposer = true;
    }
  }

  @Builder
  ModeBar() {
    Row({ space: 28 }) {
      Button('资源库')
        .height(42)
        .padding({ left: 8, right: 8 })
        .fontSize(14)
        .fontWeight(this.activeMode === 0 ? FontWeight.Bold : FontWeight.Medium)
        .fontColor(this.activeMode === 0 ? COLOR_PRIMARY : COLOR_MUTED)
        .backgroundColor(Color.Transparent)
        .border({ width: { bottom: this.activeMode === 0 ? 2 : 0 }, color: COLOR_PRIMARY })
        .borderRadius(0)
        .onClick(() => { this.activeMode = 0; })
      Button('技术讨论')
        .height(42)
        .padding({ left: 8, right: 8 })
        .fontSize(14)
        .fontWeight(this.activeMode === 1 ? FontWeight.Bold : FontWeight.Medium)
        .fontColor(this.activeMode === 1 ? COLOR_PRIMARY : COLOR_MUTED)
        .backgroundColor(Color.Transparent)
        .border({ width: { bottom: this.activeMode === 1 ? 2 : 0 }, color: COLOR_PRIMARY })
        .borderRadius(0)
        .onClick(() => { this.activeMode = 1; })
    }
    .width('100%')
    .border({ width: { bottom: 1 }, color: COLOR_BORDER })
  }

  @Builder
  SearchAndAction() {
    if (this.isWide) {
      Row({ space: 10 }) {
        TextInput({
          placeholder: this.activeMode === 0 ? '搜索标题、作者、课程或关键词' : '搜索主题、内容或作者',
          text: this.query
        })
          .width(360)
          .height(42)
          .fontSize(13)
          .backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER })
          .borderRadius(3)
          .onChange((value: string) => { this.query = value; })
        Button(this.activeMode === 0 ? '分享资源' : '发布讨论')
          .width(106)
          .height(42)
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor('#FFFFFF')
          .backgroundColor(COLOR_PRIMARY)
          .borderRadius(3)
          .onClick(() => { this.openComposer(); })
      }
    } else {
      Column({ space: 10 }) {
        TextInput({
          placeholder: this.activeMode === 0 ? '搜索标题、作者、课程或关键词' : '搜索主题、内容或作者',
          text: this.query
        })
          .width('100%')
          .height(42)
          .fontSize(13)
          .backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER })
          .borderRadius(3)
          .onChange((value: string) => { this.query = value; })
        Button(this.activeMode === 0 ? '分享资源' : '发布讨论')
          .width('100%')
          .height(42)
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor('#FFFFFF')
          .backgroundColor(COLOR_PRIMARY)
          .borderRadius(3)
          .onClick(() => { this.openComposer(); })
      }
      .width('100%')
    }
  }

  @Builder
  PageHeader() {
    if (this.isWide) {
      Row() {
        Column({ space: 3 }) {
          Text('资源库与技术讨论').fontSize(22).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('课程资料、可复用成果与校园实践经验').fontSize(12).fontColor(COLOR_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        this.SearchAndAction()
      }
      .width('100%')
      .padding({ top: 2, bottom: 6 })
    } else {
      Column({ space: 14 }) {
        Column({ space: 3 }) {
          Text('知享').fontSize(22).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Text('查找资料，继续讨论').fontSize(12).fontColor(COLOR_MUTED)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        this.SearchAndAction()
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
  }

  @Builder
  DesktopFilterRail() {
    Column({ space: 0 }) {
      Text('主题').fontSize(14).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        .width('100%').padding({ bottom: 9 })
      ForEach(['全部主题'].concat(RESOURCE_CATEGORIES), (category: string) => {
        Row({ space: 9 }) {
          Text(this.selectedCategory === category ? '■' : '□')
            .width(15)
            .fontSize(13)
            .fontColor(this.selectedCategory === category ? COLOR_PRIMARY : COLOR_MUTED)
          Text(category).layoutWeight(1).fontSize(12).fontColor(this.selectedCategory === category ? COLOR_TEXT : COLOR_MUTED)
          Text(this.categoryCount(category).toString()).fontSize(11).fontColor(COLOR_MUTED)
        }
        .width('100%')
        .height(34)
        .padding({ left: 7, right: 7 })
        .backgroundColor(this.selectedCategory === category ? COLOR_PRIMARY_SOFT : Color.Transparent)
        .borderRadius(2)
        .onClick(() => { this.selectedCategory = category; })
      }, (category: string) => category)

      Divider().color(COLOR_BORDER).margin({ top: 14, bottom: 14 })
      Text('资料类型').fontSize(14).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        .width('100%').padding({ bottom: 9 })
      ForEach(['全部类型'].concat(RESOURCE_TYPES), (type: string) => {
        Row({ space: 9 }) {
          Text(this.selectedType === type ? '■' : '□')
            .width(15)
            .fontSize(13)
            .fontColor(this.selectedType === type ? COLOR_PRIMARY : COLOR_MUTED)
          Text(type).layoutWeight(1).fontSize(12).fontColor(this.selectedType === type ? COLOR_TEXT : COLOR_MUTED)
          Text(this.typeCount(type).toString()).fontSize(11).fontColor(COLOR_MUTED)
        }
        .width('100%')
        .height(34)
        .padding({ left: 7, right: 7 })
        .backgroundColor(this.selectedType === type ? COLOR_PRIMARY_SOFT : Color.Transparent)
        .borderRadius(2)
        .onClick(() => { this.selectedType = type; })
      }, (type: string) => type)
    }
    .width(196)
    .padding({ right: 16 })
    .border({ width: { right: 1 }, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  MobileFilters() {
    Column({ space: 10 }) {
      Text('主题').fontSize(12).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
        ForEach(['全部主题'].concat(RESOURCE_CATEGORIES), (category: string) => {
          Button(category)
            .height(30)
            .fontSize(11)
            .fontColor(this.selectedCategory === category ? '#FFFFFF' : COLOR_MUTED)
            .backgroundColor(this.selectedCategory === category ? COLOR_PRIMARY : COLOR_SURFACE)
            .border({ width: 1, color: this.selectedCategory === category ? COLOR_PRIMARY : COLOR_BORDER })
            .borderRadius(2)
            .margin({ right: 6, bottom: 6 })
            .onClick(() => { this.selectedCategory = category; })
        }, (category: string) => category)
      }
      .width('100%')
      Text('资料类型').fontSize(12).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
        ForEach(['全部类型'].concat(RESOURCE_TYPES), (type: string) => {
          Button(type)
            .height(30)
            .fontSize(11)
            .fontColor(this.selectedType === type ? '#FFFFFF' : COLOR_MUTED)
            .backgroundColor(this.selectedType === type ? COLOR_PRIMARY : COLOR_SURFACE)
            .border({ width: 1, color: this.selectedType === type ? COLOR_PRIMARY : COLOR_BORDER })
            .borderRadius(2)
            .margin({ right: 6, bottom: 6 })
            .onClick(() => { this.selectedType = type; })
        }, (type: string) => type)
      }
      .width('100%')
    }
    .width('100%')
    .padding({ top: 14, bottom: 8 })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  ResourceList() {
    if (this.resources().length === 0) {
      Column({ space: 7 }) {
        Text('没有匹配的资源').fontSize(14).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
        Text('调整主题、类型或搜索词后再试。').fontSize(12).fontColor(COLOR_MUTED)
      }
      .width('100%')
      .padding({ top: 42, bottom: 42 })
    } else {
      Column({ space: 0 }) {
        ForEach(this.resources(), (resource: KnowledgeResource) => {
          ResourceCard({
            resource: resource,
            isWide: this.isWide,
            onOpen: () => {
              this.recordResourceView(resource.id);
              this.selectedResourceId = resource.id;
            }
          })
        }, (resource: KnowledgeResource) => resource.id)
      }
      .width('100%')
    }
  }

  @Builder
  DesktopResourceTable() {
    Column({ space: 0 }) {
      Row() {
        Text('资源').width('48%').fontSize(11).fontWeight(FontWeight.Medium).fontColor(COLOR_MUTED)
        Text('课程与作者').width('25%').fontSize(11).fontWeight(FontWeight.Medium).fontColor(COLOR_MUTED)
        Text('使用情况').width('19%').fontSize(11).fontWeight(FontWeight.Medium).fontColor(COLOR_MUTED)
        Text('操作').width('8%').textAlign(TextAlign.End)
          .fontSize(11).fontWeight(FontWeight.Medium).fontColor(COLOR_MUTED)
      }
      .width('100%')
      .height(42)
      .padding({ left: 16, right: 16 })
      .backgroundColor(COLOR_SURFACE_ALT)
      .border({ width: { bottom: 1 }, color: COLOR_BORDER })
      this.ResourceList()
    }
    .width('100%')
    .backgroundColor(COLOR_SURFACE)
    .border({ width: 1, color: COLOR_BORDER })
    .borderRadius(3)
  }

  @Builder
  ResourceActionRail() {
    Column({ space: 0 }) {
      Text('我的知享').fontSize(14).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        .width('100%').padding({ bottom: 12 })
      Divider().color(COLOR_BORDER)
      Row() {
        Text('已收藏').fontSize(12).fontColor(COLOR_MUTED)
        Blank()
        Text(this.favoriteCount().toString()).fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      }
      .width('100%').padding({ top: 14, bottom: 14 })
      Row() {
        Text('本页资源').fontSize(12).fontColor(COLOR_MUTED)
        Blank()
        Text(this.resources().length.toString()).fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      }
      .width('100%').padding({ bottom: 14 })
      Row() {
        Text('我的贡献').fontSize(12).fontColor(COLOR_MUTED)
        Blank()
        Text(this.extraResources.length.toString()).fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
      }
      .width('100%').padding({ bottom: 14 })
      Divider().color(COLOR_BORDER).margin({ bottom: 16 })
      Button('分享资源')
        .width('100%').height(40).fontSize(13).fontWeight(FontWeight.Medium)
        .fontColor(COLOR_PRIMARY).backgroundColor(COLOR_SURFACE)
        .border({ width: 1, color: COLOR_PRIMARY }).borderRadius(3)
        .onClick(() => { this.openComposer(); })
      Text('公开资源会保留作者、课程与文件信息。')
        .width('100%').fontSize(11).lineHeight(17).fontColor(COLOR_MUTED).margin({ top: 12 })
    }
    .width(208)
    .padding({ left: 18 })
    .border({ width: { left: 1 }, color: COLOR_BORDER })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  ResourceWorkspace() {
    if (this.isWide) {
      Row({ space: 0 }) {
        this.DesktopFilterRail()
        Column({ space: 10 }) {
          Row() {
            Text('校园资源').fontSize(15).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
            Blank()
            Text(`${this.resources().length} 份`).fontSize(11).fontColor(COLOR_MUTED)
          }
          .width('100%')
          this.DesktopResourceTable()
        }
        .layoutWeight(1)
        .padding({ left: 18, right: 18 })
        .alignItems(HorizontalAlign.Start)
        this.ResourceActionRail()
      }
      .width('100%')
      .padding({ top: 18 })
      .alignItems(VerticalAlign.Top)
    } else {
      Column({ space: 8 }) {
        this.MobileFilters()
        Row() {
          Text('校园资源').fontSize(15).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Blank()
          Text(`${this.resources().length} 份`).fontSize(11).fontColor(COLOR_MUTED)
        }
        .width('100%')
        this.ResourceList()
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
  }

  @Builder
  Detail() {
    ForEach(this.allResources(), (resource: KnowledgeResource) => {
      if (resource.id === this.selectedResourceId) {
        ResourceDetail({
          resource: resource,
          isLoggedIn: this.isLoggedIn,
          isWide: this.isWide,
          isSaved: this.isSaved(resource.id),
          isReported: this.isReported(resource.id),
          selectedRating: this.selectedRating(resource.id),
          comments: this.resourceComments(resource.id),
          onBack: () => { this.selectedResourceId = ''; },
          onRequireLogin: () => { this.onRequireLogin(); },
          onFavorite: () => { this.toggleFavorite(resource.id); },
          onDownload: () => { this.recordResourceDownload(resource.id); },
          onRate: (score: number) => {
            this.rateResource(resource.id, score);
          },
          onComment: (content: string) => {
            const comment: ResourceComment = {
              id: `comment-local-${Date.now()}`,
              resourceId: resource.id,
              author: '当前账号',
              content: content,
              createdAt: formatLocalMinute(new Date())
            };
            this.localComments = [comment].concat(this.localComments);
          },
          onReport: () => { this.reportResource(resource.id); }
        })
      }
    }, (resource: KnowledgeResource) => resource.id)
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 16 }) {
          if (this.showComposer) {
            KnowledgeComposer({
              isResource: this.activeMode === 0,
              onClose: () => { this.showComposer = false; },
              onResourcePublished: (resource: KnowledgeResource) => {
                this.onResourcePublished(resource);
                this.showComposer = false;
              },
              onDiscussionPublished: (post: DiscussionPost) => {
                this.onDiscussionPublished(post);
                this.showComposer = false;
              }
            })
          } else if (this.selectedResourceId.length > 0) {
            this.Detail()
          } else {
            this.PageHeader()
            this.ModeBar()
            if (this.activeMode === 0) {
              this.ResourceWorkspace()
            } else {
              DiscussionFeed({
                query: this.query,
                isLoggedIn: this.isLoggedIn,
                isWide: this.isWide,
                extraPosts: this.extraDiscussions,
                onRequireLogin: () => { this.onRequireLogin(); }
              })
            }
          }
        }
        .width('100%')
        .constraintSize({ maxWidth: PAGE_MAX_WIDTH })
        .padding({ left: this.isWide ? 24 : 16, right: this.isWide ? 24 : 16, top: 20, bottom: 28 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
  }
}
