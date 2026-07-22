import { RecruitmentKind, RecruitmentPost } from '../../../domain/WorkflowModels';

export enum RecruitmentScope {
  ALL = '全部机会',
  APPROACHING = '即将截止',
  RELATED = '与我相关'
}

export enum RecruitmentDeadlineState {
  UNKNOWN = '时间待确认',
  OPEN = '招募中',
  SOON = '即将截止',
  URGENT = '紧急',
  EXPIRED = '已截止'
}

const HOUR_MS: number = 60 * 60 * 1000;
const DAY_MS: number = 24 * HOUR_MS;
const MAX_SORT_TIME: number = 9007199254740991;

export function parseRecruitmentDeadline(deadline: string): number {
  const parts: string[] = deadline.trim().split(' ');
  if (parts.length !== 2) {
    return -1;
  }
  const dateParts: string[] = parts[0].split('-');
  const timeParts: string[] = parts[1].split(':');
  if (dateParts.length !== 3 || timeParts.length !== 2) {
    return -1;
  }
  const year: number = Number(dateParts[0]);
  const month: number = Number(dateParts[1]);
  const day: number = Number(dateParts[2]);
  const hour: number = Number(timeParts[0]);
  const minute: number = Number(timeParts[1]);
  if (year < 2000 || month < 1 || month > 12 || day < 1 || day > 31 ||
    hour < 0 || hour > 24 || minute < 0 || minute > 59 || (hour === 24 && minute !== 0)) {
    return -1;
  }
  return new Date(year, month - 1, day, hour, minute, 0, 0).getTime();
}

export function recruitmentDeadlineState(deadline: string, nowMs: number): RecruitmentDeadlineState {
  const deadlineMs: number = parseRecruitmentDeadline(deadline);
  if (deadlineMs < 0) {
    return RecruitmentDeadlineState.UNKNOWN;
  }
  const remaining: number = deadlineMs - nowMs;
  if (remaining < 0) {
    return RecruitmentDeadlineState.EXPIRED;
  }
  if (remaining <= 72 * HOUR_MS) {
    return RecruitmentDeadlineState.URGENT;
  }
  if (remaining <= 7 * DAY_MS) {
    return RecruitmentDeadlineState.SOON;
  }
  return RecruitmentDeadlineState.OPEN;
}

export function recruitmentDeadlineLabel(deadline: string, nowMs: number): string {
  const state: RecruitmentDeadlineState = recruitmentDeadlineState(deadline, nowMs);
  if (state === RecruitmentDeadlineState.UNKNOWN) {
    return '截止时间待确认';
  }
  if (state === RecruitmentDeadlineState.EXPIRED) {
    return '已截止';
  }
  const remaining: number = parseRecruitmentDeadline(deadline) - nowMs;
  if (remaining <= 72 * HOUR_MS) {
    const hours: number = Math.max(1, Math.ceil(remaining / HOUR_MS));
    return `剩余 ${hours} 小时`;
  }
  if (remaining <= 7 * DAY_MS) {
    const days: number = Math.max(1, Math.ceil(remaining / DAY_MS));
    return `剩余 ${days} 天`;
  }
  return '招募中';
}

export function isRecruitmentExpired(deadline: string, nowMs: number): boolean {
  return recruitmentDeadlineState(deadline, nowMs) === RecruitmentDeadlineState.EXPIRED;
}

export function matchesRecruitmentQuery(post: RecruitmentPost, query: string): boolean {
  const keyword: string = query.trim().toLowerCase();
  if (keyword.length === 0) {
    return true;
  }
  const searchable: string = [
    post.title,
    post.summary,
    post.publisher,
    post.organization,
    post.requiredRole,
    post.schedule,
    post.location,
    post.tags.join(' ')
  ].join(' ').toLowerCase();
  return searchable.includes(keyword);
}

export function isRecruitmentRelated(post: RecruitmentPost, accountId: string,
  relatedPostIds: string[]): boolean {
  return accountId.length > 0 && (post.createdBy === accountId || relatedPostIds.indexOf(post.id) >= 0);
}

export function discoverRecruitments(posts: RecruitmentPost[], kind: RecruitmentKind, query: string,
  scope: RecruitmentScope, accountId: string, relatedPostIds: string[], nowMs: number): RecruitmentPost[] {
  return posts.filter((post: RecruitmentPost) => {
    if (post.kind !== kind || !matchesRecruitmentQuery(post, query)) {
      return false;
    }
    const state: RecruitmentDeadlineState = recruitmentDeadlineState(post.deadline, nowMs);
    if (scope === RecruitmentScope.APPROACHING) {
      return state === RecruitmentDeadlineState.URGENT || state === RecruitmentDeadlineState.SOON;
    }
    if (scope === RecruitmentScope.RELATED) {
      return isRecruitmentRelated(post, accountId, relatedPostIds);
    }
    return true;
  }).slice().sort((left: RecruitmentPost, right: RecruitmentPost) => {
    const leftTime: number = parseRecruitmentDeadline(left.deadline);
    const rightTime: number = parseRecruitmentDeadline(right.deadline);
    const leftSort: number = leftTime < nowMs ? MAX_SORT_TIME : leftTime;
    const rightSort: number = rightTime < nowMs ? MAX_SORT_TIME : rightTime;
    return leftSort - rightSort;
  });
}
