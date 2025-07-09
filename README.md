# 币安量化交易 - 前端界面

币安期货量化交易系统的前端用户界面。

## 开发环境

- Node.js v18.x 或更高版本
- npm 或 pnpm 包管理器

## 安装依赖

使用 npm:
```bash
npm install --legacy-peer-deps
```

或使用 pnpm:
```bash
pnpm install
```

## 开发

启动开发服务器:
```bash
npm run dev
# 或
pnpm dev
```

默认在 http://localhost:9528 启动，API请求会代理到 http://localhost:3333

## 构建

构建生产版本:
```bash
npm run build
# 或
pnpm run build
```

构建文件将生成在 `dist/` 目录中。

## 前后端集成

### 快速集成

1. 构建前端项目:
   ```bash
   npm run build
   ```

2. 使用自动化部署脚本:
   ```bash
   ./deploy.sh
   ```

3. 或手动复制静态文件:
   ```bash
   ./copy_to_backend.sh
   ```

### 详细集成说明

查看 [BACKEND_INTEGRATION.md](./BACKEND_INTEGRATION.md) 获取完整的集成指南，包括:

- API配置说明
- 后端静态资源配置
- 路由配置示例
- 故障排除指南

## API配置

- 开发环境: API请求发送到 `http://localhost:3333`
- 生产环境: 使用相对路径，与后端服务部署在同一域名下

## 项目结构

```
src/
├── api/                 # API接口定义
├── components/          # 可复用组件
├── layout/             # 布局组件
├── router/             # 路由配置
├── store/              # Vuex状态管理
├── styles/             # 全局样式
├── utils/              # 工具函数
└── views/              # 页面组件
```

## 功能特性

- 合约账户管理
- 期货交易功能
- 订单管理
- 策略配置
- 实时行情监控
- 系统配置管理

## 技术栈

- Vue.js 2.6
- Vue Router
- Vuex
- Element UI
- Axios
- ECharts

