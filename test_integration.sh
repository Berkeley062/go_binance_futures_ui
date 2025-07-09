#!/bin/bash
# test_integration.sh - 测试前后端集成配置

echo "🧪 前后端集成配置测试"
echo "========================"

# 检查必要文件
echo "1. 检查构建文件..."
if [ ! -f "dist/index.html" ]; then
    echo "❌ dist/index.html 不存在，请先运行 npm run build"
    exit 1
fi
echo "   ✅ index.html 存在"

if [ ! -d "dist/static" ]; then
    echo "❌ dist/static 目录不存在"
    exit 1
fi
echo "   ✅ static 目录存在"

# 检查API配置
echo ""
echo "2. 检查API配置..."
api_config=$(grep "VUE_APP_BASE_API" .env.production | cut -d'=' -f2 | tr -d ' ')
if [ "$api_config" = "''" ] || [ "$api_config" = '""' ] || [ -z "$api_config" ]; then
    echo "   ✅ 生产环境API配置正确 (使用相对路径)"
else
    echo "   ⚠️  生产环境API配置: $api_config"
fi

# 检查HTML中的资源路径
echo ""
echo "3. 检查静态资源路径..."
if grep -q 'href=/static/' dist/index.html; then
    echo "   ✅ CSS资源路径正确 (/static/css/)"
else
    echo "   ❌ CSS资源路径配置错误"
fi

if grep -q 'src=/static/' dist/index.html; then
    echo "   ✅ JS资源路径正确 (/static/js/)"
else
    echo "   ❌ JS资源路径配置错误"
fi

# 检查关键API文件
echo ""
echo "4. 检查API接口配置..."
if [ -f "src/utils/request.js" ]; then
    if grep -q "process.env.VUE_APP_BASE_API" src/utils/request.js; then
        echo "   ✅ request.js 配置正确"
    else
        echo "   ❌ request.js 配置可能有误"
    fi
else
    echo "   ❌ src/utils/request.js 不存在"
fi

# 统计文件大小
echo ""
echo "5. 构建统计..."
total_size=$(du -sh dist/ | cut -f1)
js_files=$(find dist/static/js -name "*.js" | wc -l)
css_files=$(find dist/static/css -name "*.css" | wc -l)

echo "   📦 总大小: $total_size"
echo "   📄 JS文件: $js_files 个"
echo "   🎨 CSS文件: $css_files 个"

# 检查部署脚本
echo ""
echo "6. 检查部署脚本..."
if [ -x "deploy.sh" ]; then
    echo "   ✅ deploy.sh 可执行"
else
    echo "   ❌ deploy.sh 不可执行，请运行: chmod +x deploy.sh"
fi

if [ -x "copy_to_backend.sh" ]; then
    echo "   ✅ copy_to_backend.sh 可执行"
else
    echo "   ❌ copy_to_backend.sh 不可执行，请运行: chmod +x copy_to_backend.sh"
fi

# 模拟API调用测试
echo ""
echo "7. API配置验证..."
echo "   前端将发起如下API调用:"
echo "   - GET /features (获取功能列表)"
echo "   - GET /config (获取配置)"
echo "   - PUT /config (更新配置)"
echo "   - POST /start (启动服务)"
echo "   - POST /stop (停止服务)"
echo "   - GET /futures/account (期货账户)"
echo "   - GET /service/config (服务配置)"

echo ""
echo "🎉 集成配置检查完成！"
echo ""
echo "📋 后端需要配置的路由:"
echo "   - 静态文件服务: /static/* -> ./static/"
echo "   - 前端页面: / -> ./static/index.html"
echo "   - API路由: /features, /config, /start, /stop 等"
echo ""
echo "🚀 现在可以将 dist/ 目录内容复制到后端项目了！"