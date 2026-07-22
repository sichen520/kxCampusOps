const MAX_FEEDBACK_RECORDS: number = 20;

export interface FeedbackRecord {
  id: string;
  category: string;
  content: string;
  contact: string;
  createdAt: string;
  syncState: string;
}

function copyRecord(record: FeedbackRecord): FeedbackRecord {
  return {
    id: record.id.trim(),
    category: record.category.trim().length > 0 ? record.category.trim() : '其他',
    content: record.content.trim(),
    contact: record.contact.trim(),
    createdAt: record.createdAt,
    syncState: record.syncState.trim().length > 0 ? record.syncState : '待同步'
  };
}

export function feedbackValidationMessage(content: string): string {
  const normalized: string = content.trim();
  if (normalized.length === 0) {
    return '请填写问题说明。';
  }
  if (normalized.length < 5) {
    return '请至少填写 5 个字的问题说明。';
  }
  if (normalized.length > 500) {
    return '问题说明不能超过 500 个字。';
  }
  return '';
}

export function createFeedbackRecord(
  id: string,
  category: string,
  content: string,
  contact: string,
  createdAt: string
): FeedbackRecord {
  return copyRecord({
    id: id,
    category: category,
    content: content,
    contact: contact,
    createdAt: createdAt,
    syncState: '待同步'
  });
}

export function enqueueFeedback(
  records: FeedbackRecord[],
  record: FeedbackRecord
): FeedbackRecord[] {
  const candidate: FeedbackRecord = copyRecord(record);
  if (candidate.id.length === 0 || feedbackValidationMessage(candidate.content).length > 0) {
    return records.map((item: FeedbackRecord) => copyRecord(item));
  }
  const remaining: FeedbackRecord[] = records
    .filter((item: FeedbackRecord) => item.id.trim() !== candidate.id)
    .map((item: FeedbackRecord) => copyRecord(item));
  return [candidate].concat(remaining).slice(0, MAX_FEEDBACK_RECORDS);
}
