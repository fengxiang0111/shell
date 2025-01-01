#!/bin/bash

# 检查是否以 root 权限运行
if [ "$EUID" -ne 0 ]; then
  echo "请以 root 用户运行此脚本。"
  exit 1
fi

# 服务名称
SERVICE_NAME="V2bX.service"

# 检查服务是否存在
if ! systemctl list-units --type=service --all | grep -q "$SERVICE_NAME"; then
  echo "服务 $SERVICE_NAME 不存在，请检查服务名称是否正确。"
  exit 1
fi

# 确保 cron 服务已安装并运行
if ! systemctl is-active --quiet cron; then
  echo "cron 服务未运行，正在启动..."
  systemctl enable cron
  systemctl start cron
fi

# 设置定时任务
echo "正在设置每小时以 root 用户权限重启 $SERVICE_NAME 的任务..."
CRON_JOB="0 * * * * /bin/systemctl restart $SERVICE_NAME"

# 添加到 root 用户的 crontab
( crontab -u root -l 2>/dev/null | grep -v "/bin/systemctl restart $SERVICE_NAME"; echo "$CRON_JOB" ) | crontab -u root -

if [ $? -eq 0 ]; then
  echo "定时任务设置成功！每小时将自动重启 $SERVICE_NAME。"
else
  echo "定时任务设置失败，请检查系统配置。"
  exit 1
fi
