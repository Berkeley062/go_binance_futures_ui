#!/bin/bash
set -e

echo "前后端集成自动化脚本"
echo "======================"

# 配置变量
BACKEND_PATH="../go_binance_futures"
CURRENT_DIR=$(pwd)

# 检查是否在正确的目录
if [ ! -f "package.json" ]; then
    echo "错误: 请在前端项目根目录运行此脚本"
    exit 1
fi

# 1. 构建前端项目
echo "1. 正在构建前端项目..."
npm run build

# 2. 检查构建是否成功
if [ ! -d "dist" ]; then
    echo "错误: 构建失败，dist目录不存在"
    exit 1
fi

echo "   ✅ 前端构建成功"

# 3. 检查后端项目路径
if [ ! -d "$BACKEND_PATH" ]; then
    echo "警告: 默认后端项目路径不存在: $BACKEND_PATH"
    echo "请手动将 dist/ 目录中的文件复制到后端项目的 static/ 目录"
    echo ""
    echo "构建文件位置: $CURRENT_DIR/dist/"
    echo "目标位置: [后端项目]/static/"
    echo ""
    echo "手动复制命令示例:"
    echo "  cp -r dist/* /path/to/go_binance_futures/static/"
    exit 0
fi

# 4. 备份现有静态文件
if [ -d "$BACKEND_PATH/static" ]; then
    backup_name="static.backup.$(date +%Y%m%d_%H%M%S)"
    echo "2. 备份现有静态文件到: $backup_name"
    mv "$BACKEND_PATH/static" "$BACKEND_PATH/$backup_name"
fi

# 5. 复制新的静态文件
echo "3. 复制静态文件到后端项目..."
mkdir -p "$BACKEND_PATH/static"
cp -r dist/* "$BACKEND_PATH/static/"

echo "   ✅ 静态文件复制完成"

# 6. 验证文件
echo "4. 验证复制的文件..."
if [ -f "$BACKEND_PATH/static/index.html" ]; then
    echo "   ✅ index.html 存在"
else
    echo "   ❌ index.html 不存在"
    exit 1
fi

if [ -d "$BACKEND_PATH/static/static" ]; then
    echo "   ✅ 静态资源目录存在"
else
    echo "   ❌ 静态资源目录不存在"
    exit 1
fi

# 7. 显示完成信息
echo ""
echo "🎉 前后端集成完成!"
echo "======================"
echo "静态文件位置: $BACKEND_PATH/static/"
echo ""
echo "下一步:"
echo "1. 启动后端服务"
echo "2. 访问前端页面测试功能"
echo "3. 检查API调用是否正常"
echo ""
echo "文件结构:"
echo "$BACKEND_PATH/static/"
echo "├── index.html"
echo "├── favicon.ico"
echo "└── static/"
echo "    ├── css/"
echo "    ├── js/"
echo "    └── ..."