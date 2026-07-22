# 校汇通

基于 HarmonyOS 的高校机会履约与多人协同应用。它不只帮助学生发现比赛、项目和校园活动，还把资格判断、组队审批、资源补齐、任务分工和执行跟踪连接成一条完整流程。

> 当前仓库是竞赛 Demo。核心业务链路、PC/移动端响应式页面和本地持久化已经实现；真实账号、服务端数据库、OCR/大模型服务、Scan Kit、服务卡片和跨设备接续仍属于后续接入范围。

## 项目定位

高校中的比赛通知、项目招募、活动岗位、学习资料和协作过程通常分散在群聊、公众号和不同系统中。校汇通将这些信息转化为可判断、可申请、可审批、可执行和可追踪的行动对象。

核心链路：

```text
发现机会 -> AI 解析与原文核对 -> 可行性分析 -> 创建/申请队伍
-> 队长或指导老师审批 -> AI/人工分工 -> 项目执行 -> 成果沉淀
```

## 当前功能

| 模块 | 已实现内容 |
| --- | --- |
| 首页 | 游客浏览、搜索、比赛招募与校园活动分栏、详情查看 |
| 可行 | 机会导入、结构化解析核对、资格与缺口分析、行动建议 |
| 队伍 | 创建比赛队伍、可选指导老师、成员申请、队长/老师审批、角色展示 |
| 项目执行 | AI 辅助分工、人工任务编排、负责人确认、项目任务看板 |
| 知享 | 分类资源、技术讨论、搜索筛选、资源详情、发布与互动 |
| 我的 | 个人资料、申请与活动记录、队伍/项目入口、通知、隐私、设备与反馈设置 |
| 管理后台 | 资源审核、举报处理、身份认证和平台统计演示 |
| 数据状态 | 使用 `PersistentStorage` 保存招募、申请、资料和主要设置，支持跨页面与重启测试 |

### 关键业务规则

- 账号本身不携带“队长”身份，创建队伍的人才是队长。
- 学生申请加入比赛队伍后，必须由队长审批。
- 比赛队伍可以不选择指导老师；老师接受邀请后，与队长共享成员管理和项目分工权限。
- 校园活动与比赛队伍使用不同流程，活动报名由活动负责老师审批。
- AI 只生成分析和分工草案，录取成员与发布任务必须由负责人确认。
- 未登录用户可以浏览公开内容，但不能申请、报名、发布或进入个人工作区。

## 技术栈

- HarmonyOS 6.1.1 / API 24
- ArkTS、ArkUI、Stage 模型
- Hvigor、OHPM
- `PersistentStorage` 本地演示数据
- phone、tablet、2in1 多设备声明
- `960vp` 响应式断点，桌面端使用独立侧栏工作区
- Hypium 单元测试

后续部署计划包含 PostgreSQL、Redis、MinIO、服务端 API、OCR/大模型服务，以及 HarmonyOS Scan Kit、Push Kit、服务卡片和应用接续。

## 工程结构

```text
XiaoHuiTong/
├─ AppScope/                         # 应用级配置与资源
├─ docs/                             # 需求、产品、创意、技术与协作文档
├─ entry/
│  └─ src/main/ets/
│     ├─ data/                       # Demo 数据与默认资料
│     ├─ domain/                     # 领域模型和可测试业务规则
│     ├─ features/                   # 按业务域拆分的页面与组件
│     │  ├─ activity/                # 校园活动
│     │  ├─ competition/             # 比赛招募
│     │  ├─ feasibility/             # 可行性分析
│     │  ├─ home/                    # 首页聚合
│     │  ├─ knowledge/               # 知享资源与讨论
│     │  ├─ profile/                 # 个人中心及独立设置模块
│     │  ├─ project/                 # AI/人工分工与项目看板
│     │  └─ team/                    # 队伍创建、成员与指导老师
│     ├─ pages/Index.ets             # 应用壳、导航和共享状态装配
│     └─ shared/                     # 主题与通用组件
└─ build-profile.json5               # HarmonyOS 构建配置
```

新增功能必须放入对应 `features/<domain>/pages` 或 `components` 文件，不要继续把业务代码堆进 `Index.ets`。完整代码边界见 [代码结构与协作约定](docs/code-structure.md)。

## 本地运行

### 环境要求

- DevEco Studio 6.1.1 或兼容版本
- HarmonyOS SDK 6.1.1（API 24）
- DevEco Studio 内置 JBR 21

### 启动步骤

1. 克隆仓库：

   ```bash
   git clone https://github.com/sichen520/XiaoHuiTong.git XiaoHuiTong
   cd XiaoHuiTong
   ```

2. 使用 DevEco Studio 打开仓库根目录，等待 OHPM 和 Hvigor 同步完成。
3. 选择 `entry` 模块与 `default` 产品运行 Preview。
4. 需要安装到模拟器或真机时，在 DevEco Studio 中配置自动签名后再运行。

当前工程已验证：

- `assembleHap` 构建成功。
- 11 项领域规则测试全部通过。
- 未签名 HAP 由本地构建生成，不提交到 Git 仓库。

## Demo 身份

登录页直接选择身份，不需要密码：

| 身份 | 用途 |
| --- | --- |
| 李然 | 申请加入比赛队伍、报名校园活动 |
| 王晨 | 申请队伍或创建自己的比赛招募 |
| 刘老师 | 接受指导邀请、发布活动、审批活动报名 |
| 平台管理员 | 演示资源审核、举报处理和身份认证 |

建议使用不同身份依次完成“创建招募 -> 提交申请 -> 负责人审批 -> 团队分工”的跨账号演示。

## 小组协作

不要直接在 `main` 分支上并行开发。每项功能建立独立分支：

```bash
git switch main
git pull --rebase origin main
git switch -c feature/功能名称

# 完成开发后
git add .
git commit -m "feat: 功能说明"
git push -u origin feature/功能名称
```

随后在 GitHub 创建 Pull Request 合并到 `main`。提交前必须：

1. 同步最新 `main` 并处理冲突。
2. 运行 `assembleHap` 和 `test`。
3. 确认没有提交证书、私钥、`local.properties`、构建目录和 IDE 本地配置。
4. 新功能使用独立文件，并同时检查窄屏和 PC 布局。

## 项目文档

- [产品功能规格](docs/product-functional-spec.md)
- [软件需求规格说明书](docs/software-requirements-specification.md)
- [开发就绪与竞赛交付清单](docs/development-readiness.md)
- [代码结构与多人协作约定](docs/code-structure.md)
- [项目创意展示](docs/project-concept.html)
- [技术栈说明](docs/tech-stack.html)

## 当前边界

- 当前登录身份为受控 Demo，不代表已接入华为账号服务。
- 当前数据以本地持久化为主，尚未实现多用户服务端实时同步。
- AI 分析使用可演示流程和数据，尚未接入正式模型供应商与隐私授权链路。
- 设备管理、通知和反馈为本地 Demo 行为，正式部署时需要对接相应平台服务。
