# 前后端集成指南 (Frontend-Backend Integration Guide)

本文档详细说明如何将前端项目静态文件与后端项目 `Berkeley062/go_binance_futures` 集成。

## 概述

前端项目已配置为使用相对路径API调用，这意味着前端页面将向同一域名发起API请求。

## 集成步骤

### 1. 前端项目配置已完成
- ✅ API配置已设置为使用相对路径 (`.env.production` 中 `VUE_APP_BASE_API = ''`)
- ✅ 静态文件已成功构建到 `dist/` 目录
- ✅ 构建配置已优化（`publicPath: '/'`，`outputDir: 'dist'`，`assetsDir: 'static'`）

### 2. 复制静态文件到后端项目

将前端构建的静态文件复制到后端项目的 `static` 目录：

```bash
# 假设后端项目路径为 ../go_binance_futures
cp -r dist/* ../go_binance_futures/static/
```

或者使用以下脚本：

```bash
#!/bin/bash
# copy_static_files.sh

# 后端项目路径 (请根据实际情况修改)
BACKEND_PATH="../go_binance_futures"

# 检查后端项目是否存在
if [ ! -d "$BACKEND_PATH" ]; then
    echo "错误: 后端项目路径不存在: $BACKEND_PATH"
    echo "请修改 BACKEND_PATH 变量为正确的后端项目路径"
    exit 1
fi

# 创建static目录 (如果不存在)
mkdir -p "$BACKEND_PATH/static"

# 复制静态文件
echo "正在复制静态文件到后端项目..."
cp -r dist/* "$BACKEND_PATH/static/"

echo "静态文件复制完成!"
echo "文件已复制到: $BACKEND_PATH/static/"
```

### 3. 后端项目静态资源配置

后端项目需要配置静态资源服务。以下是常见的Go Web框架配置示例：

#### Gin框架示例：
```go
// main.go
package main

import (
    "github.com/gin-gonic/gin"
)

func main() {
    r := gin.Default()
    
    // 配置静态文件服务
    r.Static("/static", "./static")
    
    // 设置前端页面路由 - 将所有非API路由指向index.html
    r.StaticFile("/", "./static/index.html")
    r.NoRoute(func(c *gin.Context) {
        // 如果请求路径不是API路径，则返回index.html
        if !strings.HasPrefix(c.Request.URL.Path, "/api") {
            c.File("./static/index.html")
        } else {
            c.JSON(404, gin.H{"error": "API endpoint not found"})
        }
    })
    
    // API路由组
    api := r.Group("/api")
    {
        api.GET("/features", getFeatures)
        api.PUT("/features/:id", updateFeature)
        api.POST("/features", createFeature)
        api.DELETE("/features/:id", deleteFeature)
        // ... 其他API路由
    }
    
    r.Run(":8080")
}
```

#### Fiber框架示例：
```go
package main

import (
    "github.com/gofiber/fiber/v2"
    "github.com/gofiber/fiber/v2/middleware/filesystem"
)

func main() {
    app := fiber.New()
    
    // 配置静态文件服务
    app.Use("/static", filesystem.New(filesystem.Config{
        Root: "./static",
    }))
    
    // 前端页面路由
    app.Static("/", "./static")
    
    // API路由组
    api := app.Group("/api")
    api.Get("/features", getFeatures)
    api.Put("/features/:id", updateFeature)
    // ... 其他API路由
    
    // 将所有非API路由指向index.html (SPA支持)
    app.Use(func(c *fiber.Ctx) error {
        return c.SendFile("./static/index.html")
    })
    
    app.Listen(":8080")
}
```

### 4. API路径映射

前端项目中的API调用路径需要与后端路由匹配：

#### 前端API调用示例：
```javascript
// src/api/trade.js
export function getFeatures() {
  return request({
    url: '/features',        // 将请求 http://yourdomain.com/features
    method: 'get'
  })
}

export function getConfig() {
  return request({
    url: '/config',          // 将请求 http://yourdomain.com/config
    method: 'get'
  })
}
```

#### 建议的后端路由配置：
```go
// 直接路由 (如果前端API调用不带/api前缀)
r.GET("/features", getFeatures)
r.GET("/config", getConfig)
r.PUT("/config", updateConfig)
r.POST("/start", startService)
r.POST("/stop", stopService)

// 或者使用API前缀 (需要修改前端配置)
api := r.Group("/api")
api.GET("/features", getFeatures)
api.GET("/config", getConfig)
// ...
```

### 5. 如果使用API前缀

如果后端使用 `/api` 前缀，需要修改前端配置：

```bash
# 修改 .env.production
VUE_APP_BASE_API = '/api'
```

然后重新构建：
```bash
npm run build
```

### 6. 目录结构示例

集成后的后端项目目录结构应该如下：

```
go_binance_futures/
├── main.go
├── static/
│   ├── index.html          # 前端主页面
│   ├── favicon.ico         # 网站图标
│   └── static/            # 前端静态资源
│       ├── css/           # 样式文件
│       ├── js/            # JavaScript文件
│       ├── img/           # 图片资源
│       └── fonts/         # 字体文件
├── handlers/              # API处理器
└── ...                    # 其他后端文件
```

### 7. 测试集成

1. 启动后端服务（假设在8080端口）
2. 访问 `http://localhost:8080` 应该能看到前端页面
3. 检查浏览器网络面板，确认API调用正常
4. 验证所有功能是否正常工作

### 8. 生产环境部署注意事项

1. **域名配置**: 确保前端页面和API使用相同的域名
2. **HTTPS**: 生产环境建议使用HTTPS
3. **缓存配置**: 为静态资源设置适当的缓存头
4. **CORS配置**: 如果需要跨域访问，确保后端正确配置CORS

### 9. 故障排除

#### 常见问题：

1. **API调用失败**
   - 检查后端路由是否正确配置
   - 确认API路径是否匹配
   - 检查网络面板中的请求URL

2. **静态资源加载失败**
   - 确认静态文件已正确复制
   - 检查静态文件服务配置
   - 验证文件路径是否正确

3. **页面刷新后404错误**
   - 确保配置了SPA路由回退到index.html
   - 检查NoRoute处理器配置

#### 调试步骤：

1. 检查浏览器控制台是否有错误
2. 查看网络面板的请求状态
3. 确认后端日志中的请求记录
4. 验证静态文件是否存在于正确位置

---

## 自动化脚本

为了简化部署过程，您可以创建自动化脚本：

### build_and_deploy.sh
```bash
#!/bin/bash
set -e

echo "开始前端构建和后端集成..."

# 1. 构建前端项目
echo "1. 构建前端项目..."
npm run build

# 2. 检查构建是否成功
if [ ! -d "dist" ]; then
    echo "错误: 构建失败，dist目录不存在"
    exit 1
fi

# 3. 设置后端项目路径
BACKEND_PATH="../go_binance_futures"
if [ ! -d "$BACKEND_PATH" ]; then
    echo "错误: 后端项目路径不存在: $BACKEND_PATH"
    echo "请修改BACKEND_PATH变量"
    exit 1
fi

# 4. 备份现有静态文件
if [ -d "$BACKEND_PATH/static" ]; then
    echo "2. 备份现有静态文件..."
    mv "$BACKEND_PATH/static" "$BACKEND_PATH/static.backup.$(date +%Y%m%d_%H%M%S)"
fi

# 5. 复制新的静态文件
echo "3. 复制静态文件到后端项目..."
mkdir -p "$BACKEND_PATH/static"
cp -r dist/* "$BACKEND_PATH/static/"

echo "4. 集成完成!"
echo "静态文件已复制到: $BACKEND_PATH/static/"
echo "现在可以启动后端服务进行测试"
```

使用方法：
```bash
chmod +x build_and_deploy.sh
./build_and_deploy.sh
```

这样就完成了前后端的完整集成！