import { describe, expect, it } from '@ohos/hypium';
import {
  FeedbackRecord,
  createFeedbackRecord,
  enqueueFeedback,
  feedbackValidationMessage
} from '../main/ets/features/profile/domain/FeedbackQueue';

export default function feedbackQueueTest() {
  describe('feedbackQueue', () => {
    it('validatesFeedbackContentBoundaries', 0, () => {
      expect(feedbackValidationMessage('')).assertEqual('请填写问题说明。');
      expect(feedbackValidationMessage('太短')).assertEqual('请至少填写 5 个字的问题说明。');
      expect(feedbackValidationMessage('页面提交后没有反馈提示')).assertEqual('');
      expect(feedbackValidationMessage('问'.repeat(501))).assertEqual('问题说明不能超过 500 个字。');
    });

    it('createsNormalizedPendingRecord', 0, () => {
      const record: FeedbackRecord = createFeedbackRecord(
        ' XHT-1 ', ' 功能问题 ', '  页面无法提交  ', ' 13800000000 ', '2026-07-21 18:00');
      expect(record.id).assertEqual('XHT-1');
      expect(record.category).assertEqual('功能问题');
      expect(record.content).assertEqual('页面无法提交');
      expect(record.contact).assertEqual('13800000000');
      expect(record.syncState).assertEqual('待同步');
    });

    it('placesNewestFeedbackFirstAndDeduplicatesReceipt', 0, () => {
      const first: FeedbackRecord = createFeedbackRecord('XHT-1', '功能问题', '第一个有效反馈', '', '18:00');
      const replacement: FeedbackRecord = createFeedbackRecord('XHT-1', '数据问题', '更新后的有效反馈', '', '18:01');
      const second: FeedbackRecord = createFeedbackRecord('XHT-2', '界面问题', '第二个有效反馈', '', '18:02');
      const records: FeedbackRecord[] = enqueueFeedback(enqueueFeedback([first], replacement), second);
      expect(records.length).assertEqual(2);
      expect(records[0].id).assertEqual('XHT-2');
      expect(records[1].content).assertEqual('更新后的有效反馈');
      expect(first.content).assertEqual('第一个有效反馈');
    });

    it('keepsAtMostTwentyValidRecords', 0, () => {
      let records: FeedbackRecord[] = [];
      for (let index: number = 0; index < 25; index += 1) {
        records = enqueueFeedback(records, createFeedbackRecord(
          `XHT-${index}`, '建议与需求', `这是第 ${index} 条有效反馈`, '', index.toString()));
      }
      expect(records.length).assertEqual(20);
      expect(records[0].id).assertEqual('XHT-24');
      expect(records[19].id).assertEqual('XHT-5');
    });
  });
}
