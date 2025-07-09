#!/bin/bash
# copy_to_backend.sh - 将构建好的静态文件复制到后端项目

# 设置后端项目路径 (请根据实际情况修改)
BACKEND_PATH="../go_binance_futures"

echo "复制静态文件到后端项目..."

# 检查后端项目是否存在
if [ ! -d "$BACKEND_PATH" ]; then
    echo "错误: 后端项目路径不存在: $BACKEND_PATH"
    echo "请修改脚本中的 BACKEND_PATH 变量为正确路径"
    exit 1
fi

# 检查dist目录是否存在
if [ ! -d "dist" ]; then
    echo "错误: dist目录不存在，请先运行 npm run build"
    exit 1
fi

# 创建static目录 (如果不存在)
mkdir -p "$BACKEND_PATH/static"

# 备份现有文件
if [ "$(ls -A $BACKEND_PATH/static 2>/dev/null)" ]; then
    backup_dir="$BACKEND_PATH/static_backup_$(date +%Y%m%d_%H%M%S)"
    echo "备份现有文件到: $backup_dir"
    cp -r "$BACKEND_PATH/static" "$backup_dir"
fi

# 复制新文件
echo "复制文件中..."
rm -rf "$BACKEND_PATH/static"/*
cp -r dist/* "$BACKEND_PATH/static/"

echo "✅ 复制完成!"
echo "静态文件已复制到: $BACKEND_PATH/static/"

# 列出复制的文件
echo ""
echo "复制的文件:"
ls -la "$BACKEND_PATH/static/"