export enum WorkflowStep {
  IMPORT = 0,
  REVIEW = 1,
  FEASIBILITY = 2,
  TEAM = 3,
  PROJECT_PLAN = 4,
  BOARD = 5
}

export enum FeasibilityState {
  MET = '符合',
  MISSING = '缺少',
  RISK = '风险',
  UNKNOWN = '无法判断'
}

export enum RecruitmentKind {
  COMPETITION = '比赛招募',
  ACTIVITY = '校园活动'
}

export enum AccountRole {
  STUDENT = '学生',
  TEACHER = '老师',
  ADMIN = '管理员'
}

export enum DemoAccount {
  STUDENT_APPLICANT = '申请学生',
  STUDENT_SECONDARY = '学生账号',
  TEACHER = '指导老师',
  ADMIN = '平台管理员'
}

export enum ApplicationState {
  NONE = '未申请',
  PENDING = '待审批',
  APPROVED = '已通过',
  REJECTED = '未通过'
}

export interface OpportunityField {
  id: string;
  label: string;
  value: string;
  confidence: number;
  source: string;
}

export interface FeasibilityItem {
  id: string;
  title: string;
  state: FeasibilityState;
  evidence: string;
  action: string;
}

export interface TeamCandidate {
  id: string;
  name: string;
  role: string;
  evidence: string;
  availability: string;
}

export interface ProjectTask {
  id: string;
  title: string;
  owner: string;
  dueDate: string;
  acceptance: string;
}

export interface KnowledgePost {
  id: string;
  category: string;
  title: string;
  author: string;
  summary: string;
}

export interface KnowledgeResource {
  id: string;
  category: string;
  resourceType: string;
  title: string;
  summary: string;
  author: string;
  courseName: string;
  college: string;
  major: string;
  teacherName: string;
  permission: string;
  tags: string[];
  viewCount: number;
  downloadCount: number;
  favoriteCount: number;
  averageRating: number;
  ratingCount: number;
  createdAt: string;
  fileName: string;
}

export interface ResourceComment {
  id: string;
  resourceId: string;
  author: string;
  content: string;
  createdAt: string;
}

export interface DiscussionPost {
  id: string;
  board: string;
  postType: string;
  title: string;
  content: string;
  author: string;
  tags: string[];
  status: string;
  viewCount: number;
  replyCount: number;
  createdAt: string;
}

export interface DiscussionReply {
  id: string;
  postId: string;
  author: string;
  content: string;
  createdAt: string;
}

export interface RecruitmentPost {
  id: string;
  createdBy: string;
  kind: RecruitmentKind;
  title: string;
  summary: string;
  publisher: string;
  publisherRole: string;
  organization: string;
  requiredRole: string;
  deadline: string;
  schedule: string;
  location: string;
  progress: string;
  approval: string;
  tags: string[];
  advisorId?: string;
  advisorName?: string;
  advisorStatus?: string;
}

export interface UserProfile {
  accountId: string;
  displayName: string;
  college: string;
  grade: string;
  major: string;
  availability: string;
}

export interface TeamMember {
  id: string;
  name: string;
  role: string;
  status: string;
  isLeader: boolean;
}

export interface TeamOverview {
  id: string;
  name: string;
  opportunity: string;
  teacher: string;
  teacherStatus: string;
  members: TeamMember[];
}
