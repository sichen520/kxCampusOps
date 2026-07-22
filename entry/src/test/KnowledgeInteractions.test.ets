import { describe, expect, it } from '@ohos/hypium';
import { KnowledgeResource } from '../main/ets/domain/WorkflowModels';
import {
  ResourceInteraction,
  applyToResource,
  empty,
  findOrCreate,
  rate,
  recordDownload,
  recordView,
  report,
  toggleFavorite,
  upsert
} from '../main/ets/features/knowledge/domain/KnowledgeInteractions';

function resource(): KnowledgeResource {
  return {
    id: 'resource-1',
    category: '课程资料',
    resourceType: 'PDF',
    title: '离散数学复习提纲',
    summary: '章节重点',
    author: '李然',
    courseName: '离散数学',
    college: '计算机学院',
    major: '软件工程',
    teacherName: '张老师',
    permission: '校内可见',
    tags: ['期末'],
    viewCount: 10,
    downloadCount: 4,
    favoriteCount: 3,
    averageRating: 4,
    ratingCount: 2,
    createdAt: '2026-07-21',
    fileName: 'review.pdf',
    attachmentRawFile: 'review.pdf'
  };
}

export default function knowledgeInteractionsTest() {
  describe('knowledgeInteractions', () => {
    it('createsEmptyStateAndNormalizesId', 0, () => {
      const state: ResourceInteraction = empty('  resource-1  ');
      expect(state.resourceId).assertEqual('resource-1');
      expect(state.viewRecorded).assertEqual(false);
      expect(state.downloadCount).assertEqual(0);
      expect(state.favorite).assertEqual(false);
      expect(state.rating).assertEqual(0);
      expect(state.reported).assertEqual(false);
      expect(empty('   ').resourceId).assertEqual('');
    });

    it('findsACopyOrCreatesMissingState', 0, () => {
      const stored: ResourceInteraction = rate(toggleFavorite(empty('resource-1')), 4);
      const states: ResourceInteraction[] = [stored];
      const found: ResourceInteraction = findOrCreate(states, ' resource-1 ');
      found.favorite = false;
      expect(stored.favorite).assertEqual(true);
      expect(found.rating).assertEqual(4);
      expect(findOrCreate(states, 'resource-2').resourceId).assertEqual('resource-2');
      expect(findOrCreate(states, '').resourceId).assertEqual('');
      expect(states.length).assertEqual(1);
    });

    it('upsertsWithoutMutatingAndRemovesDuplicateOrEmptyEntries', 0, () => {
      const original: ResourceInteraction = empty('resource-1');
      const duplicate: ResourceInteraction = toggleFavorite(original);
      const invalid: ResourceInteraction = empty('');
      const replacement: ResourceInteraction = rate(duplicate, 5);
      const result: ResourceInteraction[] = upsert([original, duplicate, invalid], replacement);
      expect(result.length).assertEqual(1);
      expect(result[0].favorite).assertEqual(true);
      expect(result[0].rating).assertEqual(5);
      expect(original.favorite).assertEqual(false);
      expect(upsert(result, empty('resource-2')).length).assertEqual(2);
      expect(upsert(result, invalid).length).assertEqual(1);
    });

    it('recordsViewOnlyOnceAndKeepsInputImmutable', 0, () => {
      const original: ResourceInteraction = empty('resource-1');
      const viewed: ResourceInteraction = recordView(original);
      const viewedAgain: ResourceInteraction = recordView(viewed);
      expect(original.viewRecorded).assertEqual(false);
      expect(viewed.viewRecorded).assertEqual(true);
      expect(viewedAgain.viewRecorded).assertEqual(true);
    });

    it('recordsDownloadsAndSanitizesInvalidCounts', 0, () => {
      const original: ResourceInteraction = empty('resource-1');
      const downloaded: ResourceInteraction = recordDownload(original);
      expect(original.downloadCount).assertEqual(0);
      expect(downloaded.downloadCount).assertEqual(1);
      const invalidCount: ResourceInteraction = {
        resourceId: 'resource-1', viewRecorded: false, downloadCount: -3,
        favorite: false, rating: 0, reported: false
      };
      expect(recordDownload(invalidCount).downloadCount).assertEqual(1);
      expect(recordDownload(empty('')).downloadCount).assertEqual(0);
    });

    it('togglesFavoriteWithoutChangingInvalidResource', 0, () => {
      const original: ResourceInteraction = empty('resource-1');
      expect(toggleFavorite(original).favorite).assertEqual(true);
      expect(toggleFavorite(toggleFavorite(original)).favorite).assertEqual(false);
      expect(toggleFavorite(empty('')).favorite).assertEqual(false);
      expect(original.favorite).assertEqual(false);
    });

    it('acceptsOnlyIntegerRatingsFromOneToFive', 0, () => {
      const original: ResourceInteraction = rate(empty('resource-1'), 3);
      expect(original.rating).assertEqual(3);
      expect(rate(original, 1).rating).assertEqual(1);
      expect(rate(original, 5).rating).assertEqual(5);
      expect(rate(original, 0).rating).assertEqual(3);
      expect(rate(original, 6).rating).assertEqual(3);
      expect(rate(original, 2.5).rating).assertEqual(3);
      expect(rate(empty(''), 4).rating).assertEqual(0);
    });

    it('reportsIdempotently', 0, () => {
      const original: ResourceInteraction = empty('resource-1');
      const reported: ResourceInteraction = report(original);
      const reportedAgain: ResourceInteraction = report(reported);
      expect(original.reported).assertEqual(false);
      expect(reported.reported).assertEqual(true);
      expect(reportedAgain.reported).assertEqual(true);
      expect(report(empty('')).reported).assertEqual(false);
    });

    it('appliesNewInteractionToResourceStatistics', 0, () => {
      const originalResource: KnowledgeResource = resource();
      let next: ResourceInteraction = empty(originalResource.id);
      next = recordView(next);
      next = recordDownload(next);
      next = toggleFavorite(next);
      next = rate(next, 5);
      const result: KnowledgeResource = applyToResource(originalResource, empty(originalResource.id), next);
      expect(result.viewCount).assertEqual(11);
      expect(result.downloadCount).assertEqual(5);
      expect(result.favoriteCount).assertEqual(4);
      expect(result.ratingCount).assertEqual(3);
      expect(result.averageRating).assertEqual(4.33);
      expect(originalResource.viewCount).assertEqual(10);
      expect(result.attachmentRawFile).assertEqual('review.pdf');
      result.tags.push('new');
      expect(originalResource.tags.length).assertEqual(1);
    });

    it('appliesRatingChangesWithoutAddingAnotherRater', 0, () => {
      const originalResource: KnowledgeResource = resource();
      const before: ResourceInteraction = rate(empty(originalResource.id), 3);
      const after: ResourceInteraction = rate(before, 5);
      const result: KnowledgeResource = applyToResource(originalResource, before, after);
      expect(result.ratingCount).assertEqual(2);
      expect(result.averageRating).assertEqual(5);
      const sameResult: KnowledgeResource = applyToResource(originalResource, before, before);
      expect(sameResult.ratingCount).assertEqual(2);
      expect(sameResult.averageRating).assertEqual(4);
    });

    it('ignoresMismatchedAndEmptyResourceIdsSafely', 0, () => {
      const originalResource: KnowledgeResource = resource();
      const other: ResourceInteraction = rate(recordView(empty('resource-2')), 5);
      const unchanged: KnowledgeResource = applyToResource(originalResource, empty(''), other);
      expect(unchanged.viewCount).assertEqual(10);
      expect(unchanged.ratingCount).assertEqual(2);
      expect(unchanged.averageRating).assertEqual(4);
      originalResource.id = '';
      expect(applyToResource(originalResource, empty(''), other).viewCount).assertEqual(10);
    });
  });
}
