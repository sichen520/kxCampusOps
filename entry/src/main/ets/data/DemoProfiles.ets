import { DemoAccount, UserProfile } from '../domain/WorkflowModels';
import { accountIdForDemoAccount, defaultDisplayNameForDemoAccount } from '../domain/WorkflowRules';

export const DEFAULT_USER_PROFILES: UserProfile[] = [
  {
    accountId: 'liran',
    displayName: '李然',
    college: '计算机与人工智能学院',
    grade: '2024 级',
    major: '计算机科学与技术',
    availability: '工作日晚间、周五下午'
  },
  {
    accountId: 'wangchen',
    displayName: '王晨',
    college: '计算机与人工智能学院',
    grade: '2023 级',
    major: '软件工程',
    availability: '周三晚、周末半天'
  },
  {
    accountId: 'liuteacher',
    displayName: '刘老师',
    college: '校级创新实践中心',
    grade: '教师',
    major: '创新项目指导',
    availability: '工作日 14:00 - 18:00'
  },
  {
    accountId: 'admin',
    displayName: '平台管理员',
    college: '校汇通项目组',
    grade: '平台账号',
    major: '内容审核与平台治理',
    availability: '工作日'
  }
];

export function defaultProfileForDemoAccount(account: DemoAccount): UserProfile {
  const accountId: string = accountIdForDemoAccount(account);
  const matched: UserProfile | undefined = DEFAULT_USER_PROFILES.find((profile: UserProfile) =>
    profile.accountId === accountId);
  if (matched !== undefined) {
    return matched;
  }
  return {
    accountId: accountId,
    displayName: defaultDisplayNameForDemoAccount(account),
    college: '待补充学院',
    grade: '待补充年级',
    major: '待补充专业',
    availability: '待补充时间'
  };
}
