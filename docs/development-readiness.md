# 校汇通开发就绪与竞赛交付清单

## 1. 当前结论

- 产品、需求、创意和技术栈文档已形成 V1.6 开发基线。
- 原生 HarmonyOS 工程位于 `E:\UN\XiaoHuiTong`，已完成可点击的 M0 黄金链路首版。
- DevEco Studio 6.1.1.280、HarmonyOS SDK 6.1.1/API 24 和内置 JBR 21 已安装。
- ArkTS 编译和 HAP 打包已验证通过，产物为 `entry-default-unsigned.hap`。
- V1.6 文档已归入工程并初始化 Git；首次安装验收前仍须完成自动签名配置。
- P0 工程当前声明 `phone`、`tablet`、`2in1`；窗口达到 `960vp` 时切换 PC 侧栏工作区。

## 2. 竞赛硬约束

| 项目 | 规程要求 | 本项目处理 |
| --- | --- | --- |
| 参赛方向 | 应用创新 | 原生 HarmonyOS 应用，AI 驱动机会履约与协作 |
| 队伍 | 最多 3 名学生，每人只参加一个队伍 | 报名前核对成员和队伍唯一性 |
| 指导老师 | 必须是队长所在学校正式教师 | 报名前确定并留出签字/盖章时间 |
| 鸿蒙特性 | 建议集成 3 个及以上 | P0 使用应用接续、服务卡片、Push Kit、Scan Kit 和多设备布局 |
| 初赛截止 | 2026-07-26 24:00 | M0 只做材料和最小 HAP，不追求完成全部 P0 |
| 复赛截止 | 2026-09-30 24:00 | 完成签名 HAP、5 分钟内视频和作品说明文档 |
| 原创性 | 核心创意和主要开发过程在赛期内独立完成 | Git 保留提交时间线，第三方依赖记录许可证 |

## 3. 各阶段提交物

### M0 初赛

- 一句话描述关键创新点。
- 创意效果图或交互流程图。
- 800 字内作品介绍，包含痛点、核心功能、交互/技术路径和市场前景。
- 最小 HAP 为可选项，但建议提交以争取实际应用价值附加分。

### P0 复赛

- 一句话创新点、设计稿和官方模板作品说明文档。
- 可安装并完成黄金链路的签名 HAP。
- 5 分钟以内 MP4 演示视频。
- HAP/工程文件按规程命名并压缩为 zip。

### 决赛

- 在复赛材料基础上增加项目演示 PPT。
- 准备离线演示数据和无网络降级路径。

## 4. 评分对齐

| 评分项 | 分值 | 开发策略 |
| --- | --- | --- |
| 创新性 | 50 | 突出“机会条件到知识、人员、任务和成果”的可追溯履约链，以及鸿蒙跨端执行 |
| 完备度 | 20 | 先完成一条稳定黄金链路，再扩展社区和活动，不做大量不可点击页面 |
| 前景评估 | 20 | 用真实高校机会、组队失败和活动协调案例证明需求和社会价值 |
| 规范性 | 10 | 统一术语、状态和演示数据，文档、视频、HAP 名称遵循规程 |
| 实际应用价值 | 附加 20 | 提交可安装 HAP，完成真实设备或模拟器演示，保留测试记录 |

## 5. 工程环境

| 项目 | 状态 | 路径/版本 |
| --- | --- | --- |
| DevEco Studio | 可用 | `E:\UN\hongmeng IDE\DevEco Studio`，6.1.1.280 |
| HarmonyOS SDK | 可用 | `E:\UN\hongmeng IDE\DevEco Studio\sdk`，6.1.1/API 24 |
| DevEco JBR | 可用 | JBR 21 |
| HarmonyOS 工程 | 可用 | `E:\UN\XiaoHuiTong` |
| HAP 构建 | 已通过 | `entry\build\default\outputs\default\entry-default-unsigned.hap` |
| 本地单元测试 | 已通过 | 11/11 领域规则测试通过；整体行覆盖率 56.47%，函数覆盖率 58.33%，分支覆盖率 61.54% |
| HAP 签名 | 未完成 | 需要在 DevEco Studio 中配置自动签名/证书 |
| Git | 已初始化 | 尚未创建首次提交 |
| Docker | 已安装、守护进程未启动 | 后端开发前启动 Docker Desktop |
| 系统 Java | 配置异常 | 命令行构建必须优先使用 DevEco 内置 JBR |
| 模板占位 | 已替换 | 应用名、vendor、模块描述和首页均已替换 |

## 6. 可复现构建命令

在 PowerShell 中执行：

```powershell
$env:DEVECO_SDK_HOME='E:\UN\hongmeng IDE\DevEco Studio\sdk'
$env:JAVA_HOME='E:\UN\hongmeng IDE\DevEco Studio\jbr'
$env:PATH="E:\UN\hongmeng IDE\DevEco Studio\jbr\bin;$env:PATH"
& 'E:\UN\hongmeng IDE\DevEco Studio\tools\hvigor\bin\hvigorw.bat' `
  --mode module `
  -p product=default `
  -p module=entry@default `
  -p buildMode=debug `
  assembleHap `
  --no-daemon
```

当前命令会生成未签名 HAP。配置签名后，应同时验证真机或模拟器安装。

## 7. 第一版 HAP 范围

第一版只实现一条黄金链路：

```text
首页 -> 扫描/导入机会（可用模拟图片） -> AI 解析结果核对
-> 个人可行性报告 -> 生成草稿团队 -> 队长批准一名申请者
-> 确认团队 -> 创建校汇通项目 -> 查看任务看板
```

第一版必须满足：

- 页面均可进入和返回，没有纯占位死路。
- AI 不可用时可使用固定演示数据继续流程。
- 报告结论展示原文依据和“无法判断”状态。
- 队伍申请必须经队长批准，任务草案必须经 ProjectOwner 确认。
- 手机和平板布局均可用。
- 至少落地 3 个鸿蒙特性，并在演示脚本中指出触发位置。
- 构建、安装、启动和黄金链路各有一条测试记录。

## 8. 开发启动顺序

1. 将 `E:\UN\XiaoHuiTong` 作为代码主目录，并把本目录 `docs` 归入同一目录，避免双目录文档漂移。
2. 初始化 Git、确认 `.gitignore` 排除签名材料和构建产物，再提交模板工程与 V1.6 文档基线；当前 `.gitignore` 已排除构建目录和常见证书、私钥扩展名。
3. 配置 DevEco 自动签名，安装一次空模板 HAP；证书、私钥和本机签名配置不得提交仓库。
4. 冻结正式 `bundleName` 与 vendor，替换应用名、模块描述和 `Hello World` 占位，再建立 `core`、`feature`、`shared`、`data` 分层和统一路由。
5. 使用本地模拟数据完成黄金链路，再定义 OpenAPI 和后端模块。
6. 启动 Docker Desktop 后搭建 PostgreSQL、Redis、MinIO 和服务端骨架。
7. 最后接入 OCR/大模型、Push、Scan Kit 和跨设备能力，每项保留降级路径。

## 9. 开发前未完成事项

- [ ] 确认最多 3 名参赛成员及队伍唯一性。
- [ ] 确认指导老师及签名/盖章安排。
- [x] 将代码与文档合并到同一仓库。
- [x] 补齐 `.gitignore` 的 `*.p12`、`*.p7b`、`*.cer`、`*.pem`、`*.key`、`*.jks` 等签名材料规则，并检查 `build-profile.json5` 不含本机路径或密钥。
- [ ] 配置 HAP 自动签名并完成安装测试。
- [x] 冻结 `bundleName` 和 vendor，替换应用名、模块描述与 `Hello World` 占位。
- [x] P0 声明 phone/tablet/2in1，并用 `960vp` 响应式断点切换移动端与 PC 工作区。
- [x] 用首批领域模型测试替换模板测试，建立非零业务覆盖率。
- [ ] 后端开发开始前启动 Docker Desktop。
- [ ] 确认华为账号、Push Kit、Scan Kit、OCR 和模型服务所需的应用/云端凭据。
- [ ] 完成初赛一句话创新点、设计稿和 800 字内说明。
