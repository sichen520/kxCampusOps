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
import { PageTitle } from '../../../shared/components/PageTitle';
import {
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  COLOR_TEXT,
  PAGE_MAX_WIDTH
} from '../../../shared/Theme';

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
  @State savedResourceIds: string[] = [];
  @State ratedResourceId: string = '';
  @State ratedScore: number = 0;
  @State comments: ResourceComment[] = RESOURCE_COMMENTS;
  @State showComposer: boolean = false;
  onRequireLogin: () => void = () => {};
  onResourcePublished: (resource: KnowledgeResource) => void = (_resource: KnowledgeResource) => {};
  onDiscussionPublished: (post: DiscussionPost) => void = (_post: DiscussionPost) => {};

  private resources(): KnowledgeResource[] {
    const keyword: string = this.query.trim();
    return KNOWLEDGE_RESOURCES.concat(this.extraResources).filter((resource: KnowledgeResource) => {
      const categoryMatched: boolean = this.selectedCategory === '全部主题' ||
        (this.selectedCategory === '其他' ? RESOURCE_CATEGORIES.indexOf(resource.category) < 0 || resource.category === '其他' :
          resource.category === this.selectedCategory);
      const typeMatched: boolean = this.selectedType === '全部类型' ||
        (this.selectedType === '其他' ? RESOURCE_TYPES.indexOf(resource.resourceType) < 0 || resource.resourceType === '其他' :
          resource.resourceType === this.selectedType);
      const keywordMatched: boolean = keyword.length === 0 || resource.title.includes(keyword) ||
        resource.summary.includes(keyword) || resource.tags.join(' ').includes(keyword) || resource.courseName.includes(keyword);
      return categoryMatched && typeMatched && keywordMatched;
    });
  }

  private selectedResource(): KnowledgeResource | undefined {
    return this.resources().find((resource: KnowledgeResource) => resource.id === this.selectedResourceId);
  }

  private resourceComments(resourceId: string): ResourceComment[] {
    return this.comments.filter((comment: ResourceComment) => comment.resourceId === resourceId);
  }

  private isSaved(resourceId: string): boolean {
    return this.savedResourceIds.indexOf(resourceId) >= 0;
  }

  private toggleFavorite(resourceId: string): void {
    if (this.isSaved(resourceId)) {
      this.savedResourceIds = this.savedResourceIds.filter((id: string) => id !== resourceId);
    } else {
      this.savedResourceIds = this.savedResourceIds.concat([resourceId]);
    }
  }

  @Builder
  ModeBar() {
    Row({ space: 8 }) {
      Button('资源库')
        .layoutWeight(1).height(42).fontSize(14)
        .fontColor(this.activeMode === 0 ? COLOR_PRIMARY : COLOR_MUTED)
        .backgroundColor(this.activeMode === 0 ? COLOR_PRIMARY_SOFT : COLOR_SURFACE)
        .borderRadius(4).onClick(() => { this.activeMode = 0; })
      Button('技术讨论')
        .layoutWeight(1).height(42).fontSize(14)
        .fontColor(this.activeMode === 1 ? COLOR_PRIMARY : COLOR_MUTED)
        .backgroundColor(this.activeMode === 1 ? COLOR_PRIMARY_SOFT : COLOR_SURFACE)
        .borderRadius(4).onClick(() => { this.activeMode = 1; })
    }
    .width('100%')
    .padding(4)
    .backgroundColor('#E9EDE9')
    .borderRadius(5)
  }

  @Builder
  ResourceFilters() {
    Column({ space: 7 }) {
      Text('主题').fontSize(12).fontWeight(FontWeight.Medium).fontColor(COLOR_MUTED)
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
        ForEach(['全部主题'].concat(RESOURCE_CATEGORIES), (category: string) => {
          Button(category)
            .height(32).fontSize(11)
            .fontColor(this.selectedCategory === category ? COLOR_PRIMARY : COLOR_MUTED)
            .backgroundColor(this.selectedCategory === category ? COLOR_PRIMARY_SOFT : COLOR_SURFACE)
            .border({ width: 1, color: this.selectedCategory === category ? COLOR_PRIMARY : COLOR_BORDER })
            .borderRadius(4)
            .margin({ right: 6, bottom: 6 })
            .onClick(() => { this.selectedCategory = category; })
        }, (category: string) => category)
      }
      .width('100%')
      Text('资料类型').fontSize(12).fontWeight(FontWeight.Medium).fontColor(COLOR_MUTED)
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
        ForEach(['全部类型'].concat(RESOURCE_TYPES), (type: string) => {
          Button(type)
            .height(32).fontSize(11)
            .fontColor(this.selectedType === type ? COLOR_PRIMARY : COLOR_MUTED)
            .backgroundColor(this.selectedType === type ? COLOR_PRIMARY_SOFT : COLOR_SURFACE)
            .border({ width: 1, color: this.selectedType === type ? COLOR_PRIMARY : COLOR_BORDER })
            .borderRadius(4)
            .margin({ right: 6, bottom: 6 })
            .onClick(() => { this.selectedType = type; })
        }, (type: string) => type)
      }
      .width('100%')
    }
    .width('100%')
    .padding({ top: 4, bottom: 2 })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  ResourceList() {
    if (this.resources().length === 0) {
      Text('没有匹配的资源').width('100%').padding(30).textAlign(TextAlign.Center).fontSize(14).fontColor(COLOR_MUTED)
    } else {
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.resources(), (resource: KnowledgeResource) => {
          ResourceCard({
            resource: resource,
            isWide: this.isWide,
            onOpen: () => { this.selectedResourceId = resource.id; }
          })
        }, (resource: KnowledgeResource) => resource.id)
      }
      .width('100%')
    }
  }

  @Builder
  Detail() {
    ForEach(this.resources(), (resource: KnowledgeResource) => {
      if (resource.id === this.selectedResourceId) {
        ResourceDetail({
          resource: resource,
          isLoggedIn: this.isLoggedIn,
          isWide: this.isWide,
          isSaved: this.isSaved(resource.id),
          selectedRating: this.ratedResourceId === resource.id ? this.ratedScore : 0,
          comments: this.resourceComments(resource.id),
          onBack: () => { this.selectedResourceId = ''; },
          onRequireLogin: () => { this.onRequireLogin(); },
          onFavorite: () => { this.toggleFavorite(resource.id); },
          onDownload: () => {},
          onRate: (score: number) => {
            this.ratedResourceId = resource.id;
            this.ratedScore = score;
          },
          onComment: (content: string) => {
            const comment: ResourceComment = {
              id: `comment-local-${this.comments.length}`,
              resourceId: resource.id,
              author: '当前账号',
              content: content,
              createdAt: '刚刚'
            };
            this.comments = this.comments.concat([comment]);
          },
          onReport: () => {}
        })
      }
    }, (resource: KnowledgeResource) => resource.id)
  }

  build() {
    Scroll() {
      Row() {
        Column({ space: 16 }) {
          PageTitle({
            eyebrow: '知享 · 校园知识社区',
            title: this.isWide ? '资源库与技术讨论' : '知享',
            description: '按主题和资料类型查找同学分享的课件、笔记、源码与经验，也可以进入讨论继续交流。'
          })
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
            Row({ space: 10 }) {
              TextInput({ placeholder: this.activeMode === 0 ? '搜索课程、标题、标签' : '搜索帖子、技术点、标签', text: this.query })
                .layoutWeight(1).height(46).fontSize(14).backgroundColor(COLOR_SURFACE)
                .border({ width: 1, color: COLOR_BORDER }).borderRadius(4)
                .onChange((value: string) => { this.query = value; })
              Button(this.activeMode === 0 ? '分享资源' : '发布讨论')
                .height(46).fontSize(13).fontColor(COLOR_PRIMARY).backgroundColor(COLOR_PRIMARY_SOFT).borderRadius(4)
                .onClick(() => {
                  if (!this.isLoggedIn) {
                    this.onRequireLogin();
                  } else {
                    this.showComposer = true;
                  }
                })
            }
            .width('100%')
            this.ModeBar()
            if (this.activeMode === 0) {
              this.ResourceFilters()
              Row() {
                Text('校园资源').fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_PRIMARY)
                Blank()
                Text(`${this.resources().length} 份`).fontSize(12).fontColor(COLOR_MUTED)
              }
              .width('100%')
              this.ResourceList()
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
        .padding({ left: this.isWide ? 28 : 18, right: this.isWide ? 28 : 18, top: 22, bottom: 28 })
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
