import { DISCUSSION_BOARDS, DISCUSSION_POSTS, DISCUSSION_REPLIES } from '../../../data/MockCampusData';
import { DiscussionPost, DiscussionReply } from '../../../domain/WorkflowModels';
import { StatusPill } from '../../../shared/components/StatusPill';
import {
  COLOR_BLUE,
  COLOR_BLUE_SOFT,
  COLOR_BORDER,
  COLOR_MUTED,
  COLOR_PRIMARY,
  COLOR_PRIMARY_SOFT,
  COLOR_SURFACE,
  COLOR_TEXT,
  PAGE_MAX_WIDTH
} from '../../../shared/Theme';

@Component
export struct DiscussionFeed {
  @Prop query: string = '';
  @Prop isLoggedIn: boolean = false;
  @Prop isWide: boolean = false;
  @Prop extraPosts: DiscussionPost[] = [];
  @State selectedBoard: string = '全部';
  @State selectedPostId: string = '';
  @State replyText: string = '';
  @State replies: DiscussionReply[] = DISCUSSION_REPLIES;
  @State notice: string = '';
  onRequireLogin: () => void = () => {};

  private posts(): DiscussionPost[] {
    const keyword: string = this.query.trim();
    return DISCUSSION_POSTS.concat(this.extraPosts).filter((post: DiscussionPost) => {
      const boardMatched: boolean = this.selectedBoard === '全部' || post.board === this.selectedBoard;
      const keywordMatched: boolean = keyword.length === 0 || post.title.includes(keyword) ||
        post.content.includes(keyword) || post.tags.join(' ').includes(keyword);
      return boardMatched && keywordMatched;
    });
  }

  private selectedPost(): DiscussionPost | undefined {
    return this.posts().find((post: DiscussionPost) => post.id === this.selectedPostId);
  }

  private postReplies(postId: string): DiscussionReply[] {
    return this.replies.filter((reply: DiscussionReply) => reply.postId === postId);
  }

  @Builder
  BoardFilters() {
    Row({ space: 8 }) {
      ForEach(['全部'].concat(DISCUSSION_BOARDS), (board: string) => {
        Button(board)
          .height(34).fontSize(12)
          .fontColor(this.selectedBoard === board ? COLOR_PRIMARY : COLOR_MUTED)
          .backgroundColor(this.selectedBoard === board ? COLOR_PRIMARY_SOFT : COLOR_SURFACE)
          .border({ width: 1, color: this.selectedBoard === board ? COLOR_PRIMARY : COLOR_BORDER })
          .borderRadius(4)
          .onClick(() => { this.selectedBoard = board; })
      }, (board: string) => board)
    }
    .width('100%')
  }

  @Builder
  List() {
    if (this.posts().length === 0) {
      Text('没有匹配的讨论').width('100%').padding(28).textAlign(TextAlign.Center).fontSize(14).fontColor(COLOR_MUTED)
    } else {
      Column({ space: 10 }) {
        ForEach(this.posts(), (post: DiscussionPost) => {
          Row({ space: 14 }) {
            Column({ space: 7 }) {
              Row({ space: 8 }) {
                StatusPill({ text: post.board, fillColor: COLOR_BLUE_SOFT, textColor: COLOR_BLUE })
                StatusPill({ text: post.postType, fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
              }
              Text(post.title).fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
              Text(post.content).fontSize(13).lineHeight(20).fontColor(COLOR_MUTED).maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Row({ space: 10 }) {
                Text(`${post.author} · ${post.createdAt}`).fontSize(11).fontColor(COLOR_MUTED)
                Text(`${post.viewCount} 浏览`).fontSize(11).fontColor(COLOR_MUTED)
                Text(`${post.replyCount} 回复`).fontSize(11).fontColor(COLOR_MUTED)
              }
              .width('100%')
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)
            Text('查看').fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_PRIMARY)
          }
          .width('100%')
          .padding(16)
          .backgroundColor(COLOR_SURFACE)
          .border({ width: 1, color: COLOR_BORDER })
          .borderRadius(6)
          .onClick(() => { this.selectedPostId = post.id; })
        }, (post: DiscussionPost) => post.id)
      }
      .width('100%')
    }
  }

  @Builder
  Detail(post: DiscussionPost) {
    Column({ space: 14 }) {
      Button('返回讨论列表').height(34).fontSize(13).fontColor(COLOR_PRIMARY).backgroundColor(Color.Transparent)
        .onClick(() => { this.selectedPostId = ''; })
      Column({ space: 10 }) {
        Row({ space: 8 }) {
          StatusPill({ text: post.board, fillColor: COLOR_BLUE_SOFT, textColor: COLOR_BLUE })
          StatusPill({ text: post.status, fillColor: COLOR_PRIMARY_SOFT, textColor: COLOR_PRIMARY })
        }
        Text(post.title).fontSize(this.isWide ? 24 : 21).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
        Text(`${post.author} · ${post.createdAt} · ${post.viewCount} 浏览`).fontSize(12).fontColor(COLOR_MUTED)
        Divider().color(COLOR_BORDER)
        Text(post.content).fontSize(14).lineHeight(24).fontColor(COLOR_TEXT)
        Row({ space: 6 }) {
          ForEach(post.tags, (tag: string) => {
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
      if (this.notice.length > 0) {
        Text(this.notice).width('100%').fontSize(13).fontColor(COLOR_PRIMARY).padding(12)
          .backgroundColor(COLOR_PRIMARY_SOFT).borderRadius(4)
      }
      Column({ space: 12 }) {
        Row() {
          Text('回复').fontSize(16).fontWeight(FontWeight.Bold).fontColor(COLOR_TEXT)
          Blank()
          Text(`${this.postReplies(post.id).length} 条`).fontSize(12).fontColor(COLOR_MUTED)
        }
        .width('100%')
        Row({ space: 10 }) {
          TextArea({ placeholder: '补充思路、示例或资料说明', text: this.replyText })
            .layoutWeight(1).height(76).backgroundColor('#F8FAF7').border({ width: 1, color: COLOR_BORDER }).borderRadius(4)
            .onChange((value: string) => { this.replyText = value; })
          Button('回复').width(72).height(40).fontSize(13).fontColor('#FFFFFF').backgroundColor(COLOR_PRIMARY).borderRadius(4)
            .onClick(() => {
              if (!this.isLoggedIn) {
                this.onRequireLogin();
              } else if (this.replyText.trim().length > 0) {
                const reply: DiscussionReply = {
                  id: `reply-local-${this.replies.length}`,
                  postId: post.id,
                  author: '当前账号',
                  content: this.replyText.trim(),
                  createdAt: '刚刚'
                };
                this.replies = this.replies.concat([reply]);
                this.replyText = '';
                this.notice = '回复已发布';
              }
            })
        }
        .width('100%')
        ForEach(this.postReplies(post.id), (reply: DiscussionReply) => {
          Column({ space: 5 }) {
            Row() {
              Text(reply.author).fontSize(13).fontWeight(FontWeight.Medium).fontColor(COLOR_TEXT)
              Blank()
              Text(reply.createdAt).fontSize(11).fontColor(COLOR_MUTED)
            }
            .width('100%')
            Text(reply.content).fontSize(13).lineHeight(20).fontColor(COLOR_MUTED)
          }
          .width('100%')
          .padding({ top: 10, bottom: 10 })
          .border({ width: { top: 1 }, color: COLOR_BORDER })
          .alignItems(HorizontalAlign.Start)
        }, (reply: DiscussionReply) => reply.id)
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

  build() {
    Column({ space: 14 }) {
      if (this.selectedPostId.length > 0 && this.selectedPost() !== undefined) {
        this.Detail(this.selectedPost() as DiscussionPost)
      } else {
        Row() {
          Text('技术讨论').fontSize(17).fontWeight(FontWeight.Bold).fontColor(COLOR_PRIMARY)
          Blank()
          Text(`${this.posts().length} 个帖子`).fontSize(12).fontColor(COLOR_MUTED)
        }
        .width('100%')
        this.BoardFilters()
        this.List()
      }
    }
    .width('100%')
    .constraintSize({ maxWidth: PAGE_MAX_WIDTH })
    .padding({ left: this.isWide ? 28 : 18, right: this.isWide ? 28 : 18 })
  }
}
