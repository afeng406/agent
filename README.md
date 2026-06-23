# 千言 · AI 智能助手 (InfiniteChat-Agent)

基于 **Java 17 + Spring Boot 3.5.9 + LangChain4j** 构建的智能 Agent 系统，深度整合 RAG、MCP 协议、分布式记忆与工具调用。

## 📋 项目概览

```
├── src/main/java/com/shanyangcode/infintechatagent/
│   ├── ai/                  # AI 对话核心逻辑
│   ├── config/              # 配置类（模型、RAG、MCP、Redis、CORS）
│   ├── controller/          # 接口层
│   ├── guardrail/           # 安全拦截（输入/输出双检）
│   ├── job/                 # 定时任务（RAG 数据加载）
│   ├── model/dto/           # 数据传输对象
│   ├── tool/                # 工具层（邮件、时间、RAG 查询）
│   ├── Monitor/             # Prometheus 监控指标
│   └── common/              # 通用响应封装
├── src/main/resources/
│   ├── application.yml      # 主配置
│   ├── application-dev.yml  # 开发环境配置
│   ├── application-prod.yml # 生产环境配置
│   ├── front/               # 前端页面
│   ├── system-prompt/       # 系统提示词
│   └── docs/                # 知识文档（RAG 知识源）
├── docker-monitor/          # Prometheus + Grafana 监控
└── Dockerfile               # 容器化部署
```

## ✨ 核心功能

### 🤖 AI 对话引擎
- 基于 LangChain4j + Qwen 系列模型
- 支持流式输出（SSE），打字机效果实时展示
- 双环境配置（dev/prod），灵活切换

### 📚 RAG 检索增强生成
- **PgVector** 向量数据库，存储文档语义向量
- **text-embedding-v4** 模型进行语义切片与向量化
- 多粒度分块策略 + 混合检索（向量相似度 + BM25）
- 动态知识植入：用户可通过自然语言指令实时更新知识库

### 🧠 分布式会话记忆
- 基于 **Redis** 的多轮对话记忆存储
- 会话隔离，支持多用户并发
- 可配置的上下文窗口（4K~32K tokens）

### 🛠️ 工具调用（Function Calling）
- 联网搜索
- 天气查询
- 实时时间查询
- 智能邮件发送
- RAG 知识库查询

### 🔒 安全护航
- **Guardrail** 输入/输出双层合规拦截
- 防止 Prompt 注入与敏感信息泄露

### 📊 可观测性
- **Prometheus** 指标采集（调用量、延迟、Token 消耗等）
- **Grafana** 可视化监控面板
- Spring Boot Actuator（health、info、prometheus 端点）

## 🚀 快速开始

### 环境要求

| 环境 | 版本 |
|------|------|
| Java | 17+ |
| Maven | 3.8+ |
| PostgreSQL | 14+（需启用 pgvector 插件） |
| Redis | 6+ |

### 配置

1. 修改 `application.yml`，填入以下配置项：

```yaml
langchain4j:
  community:
    dashscope:
      chat-model:
        api-key: 你的阿里云 DashScope API Key
      embedding-model:
        api-key: 你的阿里云 DashScope API Key

spring:
  mail:
    username: 你的邮箱
    password: 邮箱授权码

bigmodel:
  api-key: 同上（与 DashScope API Key 一致）
```

2. 配置数据库连接（`application-dev.yml` / `application-prod.yml`）

### 本地运行

```bash
# 克隆项目
git clone git@github.com:afeng406/agent.git
cd agent

# 编译
./mvnw clean package -DskipTests

# 运行
java -jar target/InfinteChat-Agent-0.0.1-SNAPSHOT.jar

# 默认地址：http://localhost:10010/api
```

### Docker 部署

```bash
# 构建镜像
docker build -t infinitechat-agent .

# 运行
docker run -p 10010:10010 \
  -e DASHSCOPE_API_KEY=your_key \
  -e SPRING_MAIL_USERNAME=your_email \
  -e SPRING_MAIL_PASSWORD=your_password \
  infinitechat-agent
```

### 启动监控

```bash
cd docker-monitor
docker-compose up -d
# Prometheus: http://localhost:9091
# Grafana:   http://localhost:3001  (admin/admin)
```

## 🔌 API 接口

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/api/chat` | AI 对话（流式 SSE 输出） |
| POST | `/api/chat/knowledge/save` | 动态知识植入 |
| POST | `/api/chat/tools/email` | 发送智能邮件 |
| GET  | `/api/chat/tools/time` | 获取实时时间 |

## 🛠️ 技术栈

| 技术 | 用途 |
|------|------|
| Java 17 | 开发语言 |
| Spring Boot 3.5.9 | 应用框架 |
| LangChain4j | AI/LLM 集成框架 |
| PostgreSQL + PgVector | 向量数据库 |
| Redis | 会话记忆存储 |
| Alibaba Qwen (DashScope) | LLM 与 Embedding 模型 |
| MCP 协议 | 工具调用协议 |
| Docker | 容器化部署 |
| Prometheus + Grafana | 监控与可视化 |

## 📝 项目状态

> ⚠️ 当前版本：0.0.1-SNAPSHOT · 个人项目，持续迭代中

## License

MIT
