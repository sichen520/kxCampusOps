import { describe, expect, it } from '@ohos/hypium';
import { RECRUITMENT_POSTS } from '../main/ets/data/MockCampusData';
import { RecruitmentKind, RecruitmentPost } from '../main/ets/domain/WorkflowModels';
import {
  discoverRecruitments,
  isRecruitmentExpired,
  matchesRecruitmentQuery,
  parseRecruitmentDeadline,
  recruitmentDeadlineLabel,
  RecruitmentScope
} from '../main/ets/features/home/domain/RecruitmentDiscovery';

export default function recruitmentDiscoveryTest() {
  describe('recruitmentDiscovery', () => {
    it('parsesEndOfDayDeadline', 0, () => {
      const expected: number = new Date(2026, 6, 27, 0, 0, 0, 0).getTime();
      expect(parseRecruitmentDeadline('2026-07-26 24:00')).assertEqual(expected);
      expect(parseRecruitmentDeadline('2026/07/26')).assertEqual(-1);
    });

    it('searchesOrganizationTagsLocationAndEnglishText', 0, () => {
      const competition: RecruitmentPost = RECRUITMENT_POSTS[0];
      const activity: RecruitmentPost = RECRUITMENT_POSTS[5];
      expect(matchesRecruitmentQuery(competition, 'harmonyos')).assertEqual(true);
      expect(matchesRecruitmentQuery(activity, '创新实验室')).assertEqual(true);
      expect(matchesRecruitmentQuery(activity, '大学生活动中心')).assertEqual(true);
      expect(matchesRecruitmentQuery(activity, '不存在的关键词')).assertEqual(false);
    });

    it('filtersApproachingDeadlinesAndSortsSoonestFirst', 0, () => {
      const nowMs: number = new Date(2026, 6, 21, 12, 0, 0, 0).getTime();
      const approaching: RecruitmentPost[] = discoverRecruitments(
        RECRUITMENT_POSTS,
        RecruitmentKind.COMPETITION,
        '',
        RecruitmentScope.APPROACHING,
        '',
        [],
        nowMs
      );
      const all: RecruitmentPost[] = discoverRecruitments(
        RECRUITMENT_POSTS,
        RecruitmentKind.COMPETITION,
        '',
        RecruitmentScope.ALL,
        '',
        [],
        nowMs
      );
      expect(approaching.length).assertEqual(1);
      expect(approaching[0].id).assertEqual('competition-campus-ai');
      expect(all.length).assertEqual(3);
      expect(all[0].id).assertEqual('competition-campus-ai');
      expect(all[1].id).assertEqual('competition-vision');
      expect(all[2].id).assertEqual('competition-open-source');
    });

    it('findsRecruitmentsRelatedToPublisherOrApplicant', 0, () => {
      const nowMs: number = new Date(2026, 6, 21, 12, 0, 0, 0).getTime();
      const published: RecruitmentPost[] = discoverRecruitments(
        RECRUITMENT_POSTS,
        RecruitmentKind.ACTIVITY,
        '',
        RecruitmentScope.RELATED,
        'liuteacher',
        [],
        nowMs
      );
      const applied: RecruitmentPost[] = discoverRecruitments(
        RECRUITMENT_POSTS,
        RecruitmentKind.ACTIVITY,
        '',
        RecruitmentScope.RELATED,
        'liran',
        ['activity-demo-day'],
        nowMs
      );
      expect(published.length).assertEqual(1);
      expect(published[0].id).assertEqual('activity-harmony-workshop');
      expect(applied.length).assertEqual(1);
      expect(applied[0].id).assertEqual('activity-demo-day');
    });

    it('labelsAndBlocksExpiredRecruitment', 0, () => {
      const afterDeadline: number = new Date(2026, 6, 24, 19, 0, 0, 0).getTime();
      expect(isRecruitmentExpired('2026-07-24 18:00', afterDeadline)).assertEqual(true);
      expect(recruitmentDeadlineLabel('2026-07-24 18:00', afterDeadline)).assertEqual('已截止');
    });
  });
}
