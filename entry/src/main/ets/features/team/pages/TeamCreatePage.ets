import { AccountRole, DemoAccount, RecruitmentPost } from '../../../domain/WorkflowModels';
import { RecruitmentComposer } from '../../home/components/RecruitmentComposer';
import { PageTitle } from '../../../shared/components/PageTitle';
import { PAGE_MAX_WIDTH } from '../../../shared/Theme';

@Component
export struct TeamCreatePage {
  @Prop accountRole: AccountRole = AccountRole.STUDENT;
  @Prop demoAccount: DemoAccount = DemoAccount.STUDENT_APPLICANT;
  @Prop isWide: boolean = false;
  @Prop suggestedTitle: string = '';
  onClose: () => void = () => {};
  onCreated: (post: RecruitmentPost) => void = (_post: RecruitmentPost) => {};

  build() {
    Scroll() {
      Row() {
        Column({ space: 18 }) {
          PageTitle({
            eyebrow: '队伍 · 创建招募',
            title: '创建一支比赛队伍',
            description: '发布人只在这支新队伍中成为创建者和临时队长，其他学生账号不会因此获得队长权限。'
          })
          RecruitmentComposer({
            accountRole: this.accountRole,
            demoAccount: this.demoAccount,
            initialTitle: this.suggestedTitle,
            backLabel: '返回队伍状态',
            onClose: () => {
              this.onClose();
            },
            onPublished: (post: RecruitmentPost) => {
              this.onCreated(post);
            }
          })
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
