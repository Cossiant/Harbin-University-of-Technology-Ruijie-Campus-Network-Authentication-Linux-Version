#! /bin/bash

# 检查是否具有root权限
if [[ $EUID -ne 0 ]]; then
    echo "正在请求root权限..."
    exec sudo "$0" "$@"
    exit $?
fi

echo "√ 已获取root权限"

# 读取用户名
read -p "请输入您的校园网账号：" username

# 读取并确认密码
while true; do
    read -sp "请输入密码：" password
    echo
    read -sp "请再次输入密码：" password_confirm
    echo
    if [ "$password" != "$password_confirm" ]; then
        echo "× 两次密码不一致，请重新输入！"
    else
        break
    fi
done

# 使用 nohup 后台运行，并避免密码出现在命令行参数
{
    echo "$password" | sudo -S ./rjsupplicant.sh -d 1 -u "$username" -p "$password"
} > /dev/null 2>&1 &

# 清理敏感变量
unset password password_confirm

echo "✔ 已启动校园网认证（后台运行）"
echo "如需查看日志，请检查 nohup.out 或运行: journalctl -u rjsupplicant"
