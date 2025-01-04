#!/bin/bash

# 日志文件路径
LOG_FILE="/var/log/v2bx_restart.log"

# 确保日志目录存在
mkdir -p "$(dirname "$LOG_FILE")"

# 写入日志函数
log() {
 echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# 无限循环，每 10 分钟重启一次服务
while true; do 
 log "尝试重启 V2bX.service 服务..."
  if systemctl restart V2bX.service; then 
 log "成功重启 V2bX.service 服务。"
else
 log "重启 V2bX.service 服务失败，请检查服务状态！"
fi

  sleep 600 # 每 10 分钟运行一次
done

