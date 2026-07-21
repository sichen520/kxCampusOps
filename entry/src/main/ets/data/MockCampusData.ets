import {
  DiscussionPost,
  DiscussionReply,
  FeasibilityItem,
  FeasibilityState,
  KnowledgePost,
  KnowledgeResource,
  OpportunityField,
  ProjectTask,
  RecruitmentKind,
  RecruitmentPost,
  ResourceComment,
  TeamCandidate,
  TeamOverview
} from '../domain/WorkflowModels';

export const OPPORTUNITY_FIELDS: OpportunityField[] = [
  {
    id: 'name',
    label: '机会名称',
    value: '2026 中国高校计算机大赛 - 鸿蒙高校创新赛',
    confidence: 0.98,
    source: '竞赛规程第 1 页标题'
  },
  {
    id: 'track',
    label: '参赛方向',
    value: '应用创新赛道',
    confidence: 0.96,
    source: '竞赛规程“竞赛方向”章节'
  },
  {
    id: 'team',
    label: '队伍限制',
    value: '最多 3 名学生，必须设队长和指导老师',
    confidence: 0.94,
    source: '竞赛规程“参赛对象及要求”章节'
  },
  {
    id: 'deadline',
    label: '初赛截止',
    value: '2026-07-26 24:00',
    confidence: 0.99,
    source: '竞赛规程“赛程安排”章节'
  }
];

export const FEASIBILITY_ITEMS: FeasibilityItem[] = [
  {
    id: 'identity',
    title: '高校在校学生身份',
    state: FeasibilityState.MET,
    evidence: '能力护照：本校 2024 级本科生',
    action: '报名时再次核对学籍信息'
  },
  {
    id: 'development',
    title: 'HarmonyOS 原生开发能力',
    state: FeasibilityState.MET,
    evidence: '已创建 API 24 ArkTS 工程并完成构建',
    action: '保留构建记录和 HAP 版本'
  },
  {
    id: 'design',
    title: '产品设计与交互证据',
    state: FeasibilityState.MISSING,
    evidence: '当前队伍没有公开的完整交互作品',
    action: '招募 1 名产品设计成员'
  },
  {
    id: 'schedule',
    title: '初赛时间窗口',
    state: FeasibilityState.RISK,
    evidence: '距离 2026-07-26 截止时间较近',
    action: '先完成唯一黄金链路和 800 字说明'
  },
  {
    id: 'teacher',
    title: '正式指导老师',
    state: FeasibilityState.UNKNOWN,
    evidence: '尚未上传老师确认记录',
    action: '由队长联系本校正式教师确认'
  }
];

export const TEAM_CANDIDATE: TeamCandidate = {
  id: 'candidate-linxiao',
  name: '林晓',
  role: '产品设计',
  evidence: '2 项移动端原型作品，1 次竞赛路演经历',
  availability: '周三晚、周五下午可投入'
};

export const CURRENT_TEAM: TeamOverview = {
  id: 'team-campusops',
  name: '可行 CampusOps 小组',
  opportunity: '鸿蒙高校创新赛 · 应用创新赛道',
  teacher: '指导老师待确认',
  teacherStatus: '需要队长补充确认',
  members: [
    {
      id: 'member-wangchen',
      name: '王晨',
      role: '队长 · HarmonyOS 开发',
      status: '已确认',
      isLeader: true
    },
    {
      id: 'member-linxiao',
      name: '林晓',
      role: '队员 · 产品设计与交互',
      status: '已确认',
      isLeader: false
    },
    {
      id: 'member-current',
      name: '当前账号',
      role: '队员 · AI 应用与材料整理',
      status: '已确认',
      isLeader: false
    }
  ]
};

export const PROJECT_TASKS: ProjectTask[] = [
  {
    id: 'task-concept',
    title: '收口一句话创新点',
    owner: '队长',
    dueDate: '07-21 20:00',
    acceptance: '不超过 60 字，说明用户、问题和关键创新'
  },
  {
    id: 'task-prototype',
    title: '完成黄金链路交互稿',
    owner: '林晓',
    dueDate: '07-22 22:00',
    acceptance: '覆盖扫描、判断、组队和项目看板'
  },
  {
    id: 'task-hap',
    title: '构建并安装最小 HAP',
    owner: '开发成员',
    dueDate: '07-24 18:00',
    acceptance: '手机和平板可启动，关键页面可点击'
  }
];

export const KNOWLEDGE_POSTS: KnowledgePost[] = [
  {
    id: 'post-arkts',
    category: '计算机与人工智能 / HarmonyOS',
    title: 'ArkTS 状态管理 V2 的项目落地笔记',
    author: '周同学',
    summary: '从页面状态、领域状态到持久化的分层示例。'
  },
  {
    id: 'post-demo',
    category: '竞赛经验 / 演示设计',
    title: '五分钟作品视频如何讲清一条闭环',
    author: '创新实验室',
    summary: '用问题、行动、结果三段式组织演示材料。'
  }
];

export const RESOURCE_CATEGORIES: string[] = [
  'HarmonyOS 开发',
  '人工智能',
  '软件工程',
  '计算机基础',
  '竞赛与升学',
  '其他'
];

export const RESOURCE_TYPES: string[] = [
  '课件',
  '笔记',
  '试卷',
  '实验报告',
  '源码',
  '电子书',
  '其他'
];

export const KNOWLEDGE_RESOURCES: KnowledgeResource[] = [
  {
    id: 'resource-arkts-state',
    category: 'HarmonyOS 开发',
    resourceType: '笔记',
    title: 'ArkTS 状态管理 V2 项目落地笔记',
    summary: '从页面状态、领域状态到持久化，整理常见状态同步问题和可运行示例。',
    author: '周同学',
    courseName: 'HarmonyOS 应用开发',
    college: '计算机与人工智能学院',
    major: '软件工程',
    teacherName: '刘老师',
    permission: '全校公开',
    tags: ['ArkTS', '状态管理', 'HarmonyOS'],
    viewCount: 143,
    downloadCount: 48,
    favoriteCount: 25,
    averageRating: 4.8,
    ratingCount: 19,
    createdAt: '2026-07-08',
    fileName: 'ArkTS-State-V2-Notes.pdf'
  },
  {
    id: 'resource-harmony-ui',
    category: 'HarmonyOS 开发',
    resourceType: '课件',
    title: 'ArkUI 响应式布局课堂示例',
    summary: '覆盖手机、平板和 2in1 的断点布局、栅格与组件复用方式。',
    author: '移动开发实验室',
    courseName: '移动应用开发',
    college: '计算机与人工智能学院',
    major: '计算机科学与技术',
    teacherName: '陈老师',
    permission: '仅本校',
    tags: ['ArkUI', '响应式', '2in1'],
    viewCount: 96,
    downloadCount: 31,
    favoriteCount: 18,
    averageRating: 4.6,
    ratingCount: 12,
    createdAt: '2026-07-07',
    fileName: 'ArkUI-Responsive-Examples.zip'
  },
  {
    id: 'resource-ai-evaluation',
    category: '人工智能',
    resourceType: '实验报告',
    title: '分类模型评估实验报告模板',
    summary: '包含数据划分、混淆矩阵、精确率召回率和误差分析，不包含现成实验结论。',
    author: '孙同学',
    courseName: '机器学习',
    college: '计算机与人工智能学院',
    major: '人工智能',
    teacherName: '王老师',
    permission: '全校公开',
    tags: ['机器学习', '模型评估', '实验报告'],
    viewCount: 121,
    downloadCount: 54,
    favoriteCount: 30,
    averageRating: 4.7,
    ratingCount: 21,
    createdAt: '2026-07-06',
    fileName: 'ML-Evaluation-Report.docx'
  },
  {
    id: 'resource-spring-structure',
    category: '软件工程',
    resourceType: '源码',
    title: 'Vue3 + Spring Boot 课程设计结构参考',
    summary: '前后端分离目录、接口分层、权限校验和 Docker 部署说明，适合作为答辩项目骨架参考。',
    author: '软件工程协会',
    courseName: '软件工程综合实践',
    college: '软件学院',
    major: '软件工程',
    teacherName: '赵老师',
    permission: '全校公开',
    tags: ['Vue3', 'SpringBoot', 'Docker'],
    viewCount: 318,
    downloadCount: 102,
    favoriteCount: 66,
    averageRating: 4.9,
    ratingCount: 41,
    createdAt: '2026-07-05',
    fileName: 'Course-Design-Structure.zip'
  },
  {
    id: 'resource-network-lab',
    category: '计算机基础',
    resourceType: '实验报告',
    title: '计算机网络抓包实验报告模板',
    summary: '包含实验目的、环境、抓包截图位置、结果分析和总结格式，不包含现成答案。',
    author: '李同学',
    courseName: '计算机网络',
    college: '计算机与人工智能学院',
    major: '网络工程',
    teacherName: '吴老师',
    permission: '仅本校',
    tags: ['Wireshark', '网络实验', '报告模板'],
    viewCount: 205,
    downloadCount: 84,
    favoriteCount: 39,
    averageRating: 4.5,
    ratingCount: 17,
    createdAt: '2026-07-04',
    fileName: 'Network-Lab-Template.docx'
  },
  {
    id: 'resource-database-review',
    category: '计算机基础',
    resourceType: '笔记',
    title: '数据库事务与索引复习提纲',
    summary: '把隔离级别、MVCC、B+ 树索引和 SQL 优化放在一份提纲里，配有课堂例题。',
    author: '数据库课程小组',
    courseName: '数据库原理',
    college: '计算机与人工智能学院',
    major: '计算机科学与技术',
    teacherName: '黄老师',
    permission: '全校公开',
    tags: ['数据库', 'MVCC', '索引'],
    viewCount: 276,
    downloadCount: 93,
    favoriteCount: 58,
    averageRating: 4.8,
    ratingCount: 33,
    createdAt: '2026-07-03',
    fileName: 'Database-Review.pdf'
  },
  {
    id: 'resource-java-notes',
    category: '计算机基础',
    resourceType: '笔记',
    title: 'Java 面向对象课堂笔记整理',
    summary: '整理继承、多态、接口和常见易错点，适合期末前快速过一遍概念。',
    author: '郑同学',
    courseName: 'Java 程序设计',
    college: '信息工程学院',
    major: '信息管理',
    teacherName: '何老师',
    permission: '全校公开',
    tags: ['Java', '面向对象', '期末复习'],
    viewCount: 167,
    downloadCount: 47,
    favoriteCount: 22,
    averageRating: 4.4,
    ratingCount: 16,
    createdAt: '2026-07-02',
    fileName: 'Java-OOP-Notes.pdf'
  },
  {
    id: 'resource-presentation',
    category: '竞赛与升学',
    resourceType: '课件',
    title: '五分钟竞赛演示视频结构拆解',
    summary: '用问题、行动、结果三段式组织演示材料，附镜头清单和讲稿检查表。',
    author: '创新实验室',
    courseName: '创新项目实践',
    college: '创新创业学院',
    major: '跨专业',
    teacherName: '罗老师',
    permission: '全校公开',
    tags: ['竞赛', '演示视频', '答辩'],
    viewCount: 231,
    downloadCount: 76,
    favoriteCount: 49,
    averageRating: 4.9,
    ratingCount: 29,
    createdAt: '2026-07-01',
    fileName: 'Demo-Video-Checklist.pptx'
  }
];

export const RESOURCE_COMMENTS: ResourceComment[] = [
  {
    id: 'comment-1',
    resourceId: 'resource-arkts-state',
    author: '陈思',
    content: '状态同步部分很实用，建议后续补一个跨设备状态恢复示例。',
    createdAt: '2026-07-09 10:20'
  },
  {
    id: 'comment-2',
    resourceId: 'resource-spring-structure',
    author: '林晓',
    content: '目录划分清楚，Docker 部署说明帮我们省了不少排查时间。',
    createdAt: '2026-07-07 18:42'
  }
];

export const DISCUSSION_BOARDS: string[] = ['HarmonyOS', '人工智能', '软件工程', '课程答疑', '竞赛交流'];

export const DISCUSSION_POSTS: DiscussionPost[] = [
  {
    id: 'discussion-distributed-state',
    board: 'HarmonyOS',
    postType: '技术讨论',
    title: '多端接续时，页面草稿状态应该放在哪一层？',
    content: '目前手机端采集机会后会在平板继续编辑。页面状态、业务状态和持久化状态应该怎样拆分，才能避免接续后数据重复？',
    author: '周同学',
    tags: ['ArkTS', '多端接续', '状态管理'],
    status: '讨论中',
    viewCount: 128,
    replyCount: 3,
    createdAt: '2026-07-10 19:30'
  },
  {
    id: 'discussion-ai-evidence',
    board: '人工智能',
    postType: '技术讨论',
    title: '资格判断如何保留可追溯证据？',
    content: '不希望只展示一个推荐分数。现在考虑给每条判断保留原文位置、置信度和人工确认状态，欢迎讨论更合理的数据结构。',
    author: '王晨',
    tags: ['可解释性', 'RAG', '人工确认'],
    status: '讨论中',
    viewCount: 96,
    replyCount: 2,
    createdAt: '2026-07-09 14:12'
  },
  {
    id: 'discussion-demo-help',
    board: '竞赛交流',
    postType: '需求求助',
    title: '五分钟演示里应该保留哪些核心页面？',
    content: '当前功能比较多，准备只演示机会导入、资格判断、组队审批和项目执行。哪些页面最能说明鸿蒙多端协同价值？',
    author: '陈思',
    tags: ['竞赛', '演示', '产品表达'],
    status: '已解决',
    viewCount: 187,
    replyCount: 5,
    createdAt: '2026-07-08 21:05'
  },
  {
    id: 'discussion-course-share',
    board: '课程答疑',
    postType: '资源分享',
    title: '整理了一份数据库索引复习提纲',
    content: '把事务隔离、MVCC 和 B+ 树索引放在一起整理了，已经上传到资源库，欢迎补充课堂例题。',
    author: '数据库课程小组',
    tags: ['数据库', '复习资料'],
    status: '讨论中',
    viewCount: 212,
    replyCount: 4,
    createdAt: '2026-07-07 16:18'
  }
];

export const DISCUSSION_REPLIES: DiscussionReply[] = [
  {
    id: 'reply-1',
    postId: 'discussion-distributed-state',
    author: '移动开发实验室',
    content: '建议页面只保留输入态，业务草稿进入 Repository；接续时以业务草稿版本号做冲突判断。',
    createdAt: '2026-07-10 20:05'
  },
  {
    id: 'reply-2',
    postId: 'discussion-ai-evidence',
    author: '孙同学',
    content: '可以把结论、原文片段、来源位置、模型版本和人工确认人作为一条判断记录保存。',
    createdAt: '2026-07-09 15:40'
  }
];

export const RECRUITMENT_POSTS: RecruitmentPost[] = [
  {
    id: 'competition-campus-ai',
    createdBy: 'wangchen',
    kind: RecruitmentKind.COMPETITION,
    title: '鸿蒙高校创新赛 · 可行 CampusOps',
    summary: '已有 ArkTS 工程和产品主线，招募一名产品设计成员共同完成交互稿和演示表达。',
    publisher: '王晨',
    publisherRole: '学生 · 队伍创建者',
    organization: '计算机与人工智能学院',
    requiredRole: '产品设计 / 交互表达',
    deadline: '2026-07-24 20:00',
    schedule: '工作日晚间、周五下午',
    location: '线上协作，必要时校内见面',
    progress: '1 / 3 名学生',
    approval: '申请需队长批准',
    tags: ['HarmonyOS', 'ArkTS', 'AI 应用']
  },
  {
    id: 'competition-vision',
    createdBy: 'chensi',
    kind: RecruitmentKind.COMPETITION,
    title: 'AI 创意赛视觉与路演小组',
    summary: '围绕真实社会痛点完成 AI 应用 Demo，寻找有用户研究或答辩经验的队友。',
    publisher: '陈思',
    publisherRole: '学生 · 队伍创建者',
    organization: '创新实践中心',
    requiredRole: '用户研究 / 答辩表达',
    deadline: '2026-08-02 18:00',
    schedule: '周三晚、周末半天',
    location: '校内创新实验室',
    progress: '2 / 3 名学生',
    approval: '申请需队长批准',
    tags: ['AI 创意', '用户研究', '路演']
  },
  {
    id: 'competition-open-source',
    createdBy: 'open-source-club',
    kind: RecruitmentKind.COMPETITION,
    title: '开源鸿蒙应用创新协作招募',
    summary: '已有需求文档和服务端原型，欢迎熟悉数据可视化或测试的同学参与。',
    publisher: '开源鸿蒙社',
    publisherRole: '学生组织创建者',
    organization: '开源鸿蒙学生社团',
    requiredRole: '数据可视化 / 测试',
    deadline: '2026-08-10 24:00',
    schedule: '每周一次线上例会',
    location: '线上协作',
    progress: '3 / 5 名学生',
    approval: '申请需负责人确认',
    tags: ['开源', '数据可视化', '测试']
  },
  {
    id: 'activity-harmony-workshop',
    createdBy: 'liuteacher',
    kind: RecruitmentKind.ACTIVITY,
    title: 'HarmonyOS 校园开发工作坊志愿者招募',
    summary: '协助指导老师完成签到、设备分发、现场答疑和活动记录。',
    publisher: '刘老师',
    publisherRole: '指导老师',
    organization: '创新创业学院',
    requiredRole: '现场协助 / 技术答疑',
    deadline: '2026-07-23 18:00',
    schedule: '2026-07-25 09:00 - 17:00',
    location: '创新创业学院 202 会议室',
    progress: '6 / 10 个岗位',
    approval: '报名需负责老师批准',
    tags: ['工作坊', '志愿服务', 'HarmonyOS']
  },
  {
    id: 'activity-welcome',
    createdBy: 'zhaoteacher',
    kind: RecruitmentKind.ACTIVITY,
    title: '学院新生技术导览活动岗位',
    summary: '面向计算机学院新生，招募讲解、摄影、签到和设备管理岗位。',
    publisher: '赵老师',
    publisherRole: '学院指导老师',
    organization: '计算机与人工智能学院学生会',
    requiredRole: '讲解 / 摄影 / 签到',
    deadline: '2026-08-18 20:00',
    schedule: '2026-08-20 14:00 - 18:00',
    location: '大学生活动中心',
    progress: '12 / 20 个岗位',
    approval: '报名需负责老师批准',
    tags: ['学院活动', '新生导览', '学生会']
  },
  {
    id: 'activity-demo-day',
    createdBy: 'innovation-lab',
    kind: RecruitmentKind.ACTIVITY,
    title: '创新项目开放日现场协调',
    summary: '负责项目展位、嘉宾引导和现场问题上报，老师会在报名后确认岗位。',
    publisher: '创新实验室',
    publisherRole: '组织负责人',
    organization: '校级创新实验室',
    requiredRole: '展位协调 / 嘉宾引导',
    deadline: '2026-08-25 12:00',
    schedule: '2026-08-30 08:30 - 18:00',
    location: '大学生活动中心一层',
    progress: '4 / 8 个岗位',
    approval: '组织推荐后需老师确认',
    tags: ['项目开放日', '现场协调', '老师审批']
  }
];
