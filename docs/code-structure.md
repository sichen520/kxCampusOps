# 校汇通代码结构与多人协作约定

## 1. 基本原则

- `pages/Index.ets` 只负责应用壳、响应式导航和共享状态装配，不允许继续添加具体业务页面。
- 每个功能页面只能放在自己的 `features/<domain>/pages` 目录中。
- 跨功能通用组件放在 `shared/components`，颜色和尺寸只在 `shared/Theme.ets` 维护。
- 业务状态、实体和规则分别放在 `domain`；模拟和真实数据访问放在 `data`。
- 修改公共文件前必须先同步其他成员，避免多人同时编辑 `Index.ets`、`Theme.ets` 和领域模型。

## 2. 当前目录归属

| 功能 | 主要文件 | 建议负责人边界 |
| --- | --- | --- |
| 应用壳与 PC 响应式 | `pages/Index.ets` | 架构负责人维护，其他成员不直接加入业务代码 |
| 首页聚合 | `features/home/pages/HomePage.ets` | 首页搜索、比赛/活动切换、游客浏览和登录边界 |
| 招募卡片与详情 | `features/home/components/RecruitmentCard.ets`、`RecruitmentDetail.ets` | 公开信息展示、查看详情、申请状态展示 |
| 发布招募 | `features/home/components/RecruitmentComposer.ets` | 学生比赛招募、老师活动发布、表单校验和角色权限 |
| 比赛招募 | `features/competition/components/CompetitionFeed.ets` | 队伍申请、队长审批状态和“可行”评估入口 |
| 校园活动 | `features/activity/components/ActivityFeed.ets` | 活动报名、老师审批状态和岗位展示 |
| 登录与身份 | `features/auth/pages/LoginPage.ets` | 游客转登录、两个普通学生、指导老师和管理员演示身份；账号本身不携带队长身份 |
| 管理后台 | `features/admin/pages/AdminConsolePage.ets` | 资源审核、举报处理、身份认证和平台治理 |
| 我的队伍 | `features/team/pages/MyTeamPage.ets`、`TeamCreatePage.ets` | 独立创建入口、队长/队员关系、指导邀请和老师接受确认 |
| 机会导入 | `features/opportunity/pages/OpportunityImportPage.ets` | 扫描、文件选择、原始资料 |
| AI 结果核对 | `features/opportunity/pages/OpportunityReviewPage.ets` | 字段确认、引用、置信度 |
| 可行性报告 | `features/feasibility/pages/FeasibilityPage.ets` | 条件判断、行动清单 |
| 组队审批 | `features/collaboration/pages/TeamPage.ets` | 申请、队长审批、团队成立 |
| 项目计划路由 | `features/project/pages/ProjectPlanPage.ets` | 分工模式切换、权限提示和发布状态装配 |
| AI 辅助分工 | `features/project/components/AiAssignmentPanel.ets` | 完整上下文、成员证据、分析侧重点、匹配理由和风险确认 |
| 人工任务编排 | `features/project/components/ManualAssignmentPanel.ets` | 任务列表、逐项编辑、负责人/截止/优先级/验收和成员负载 |
| 项目看板 | `features/project/pages/ProjectBoardPage.ets` | 任务状态、PC 看板 |
| 知享入口 | `features/knowledge/pages/KnowledgePage.ets` | 资源库/技术讨论切换、搜索、筛选和页面装配 |
| 资源卡片与详情 | `features/knowledge/components/ResourceCard.ets`、`ResourceDetail.ets` | 资源元数据、收藏、下载、评分、评论和举报 |
| 技术讨论 | `features/knowledge/components/DiscussionFeed.ets` | 版块分类、帖子详情和回复 |
| 知享发布 | `features/knowledge/components/KnowledgeComposer.ets` | 资源与讨论发布表单 |
| 个人中心 | `features/profile/pages/ProfilePage.ets` | 资料、申请、队伍、项目、活动记录、证据和账号设置 |
| 个人中心子功能 | `features/profile/components/ProfileApplicationsPanel.ets`、`ProfileActivityPanel.ets`、`NotificationSettingsPanel.ets`、`PrivacySettingsPanel.ets`、`DeviceManagementPanel.ets`、`FeedbackPanel.ets` | 申请记录、活动记录、通知、隐私、设备和反馈分别独立维护 |
| 流程路由 | `features/workflow/pages/WorkflowPage.ets` | 只负责机会履约页面切换 |

## 3. 公共目录

| 目录 | 责任 |
| --- | --- |
| `domain/WorkflowModels.ets` | 机会、招募、账号角色、审批状态和工作流实体 |
| `domain/WorkflowRules.ets` | 不依赖 UI 的可测试业务规则 |
| `data/MockCampusData.ets` | Demo 模拟数据，后续由 Repository 替换 |
| `shared/Theme.ets` | 全局颜色、尺寸和页面最大宽度 |
| `shared/components` | 标题、状态标签、移动端标题栏、PC 侧栏等通用组件 |

## 4. 合并要求

1. 每个分支只修改自己负责的 feature，公共文件修改单独提交。
2. 提交前运行 `assembleHap` 和 `test`。
3. 禁止把证书、私钥、构建目录和 `local.properties` 提交到 Git。
4. 新页面必须同时检查窄屏与 `960vp` 以上宽屏，不得只做一种布局。
5. AI 建议、队伍录取、老师审批和任务指派必须保留人工确认边界。
6. 首页公开内容允许匿名查看详情；申请比赛队伍、报名活动、发布招募、进入“可行”、进入队伍、进入项目执行、收藏知享内容和进入“我的”必须经过登录。
7. 比赛招募与校园活动共享首页入口但不共享审批规则：比赛由队长审批，活动由负责老师审批；发布权限也必须按学生/老师身份区分。
8. Demo 账号切换不得清空申请状态：申请学生提交后，该招募的创建者或活动负责老师必须能读取并处理同一条记录；管理员不得代替业务负责人审批。
9. 知享资源必须同时支持主题分类和资料类型筛选，资源卡片必须可进入详情；互动操作需要登录，公开浏览不需要登录。
10. 队长是队伍内关系，只能由招募创建关系或已确认移交产生；第二个学生演示账号不得被硬编码为队长。
11. 比赛队伍可不选指导老师；选择后先产生待确认邀请，老师接受后才与队长共享成员管理和任务分工权限。
12. 当前 Demo 使用 `PersistentStorage` 保存招募、申请、资料和账号档案，保证切换页面及重启后可继续测试；生产部署由 Repository 替换为后端关系数据库。
13. 所有带箭头的菜单行和操作按钮必须连接真实页面、状态变化或持久化操作；菜单回调不允许使用空实现占位。
