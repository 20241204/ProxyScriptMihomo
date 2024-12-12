#!/usr/bin/env bash
clear

# 当前路径
PWD=$(pwd)/sources
mkdir -pv "${PWD}"
cd "${PWD}"

echo "开始吧小老弟！"
echo "当前目录${PWD}"

yamledit(){
    # 删除替换修改 port: 7891 socks-port: 7892 nmixed-port: 7893 external-controller: :7894 redir-port: 7895 tproxy-port: 7896 allow-lan: true mode: rule log-level: debug secret: 
    local config_file=$1

    echo "正在编辑 ${config_file}，请稍候..."

    declare -a delete_params=(
    "port: "
    "mixed-port: "
    "socks-port: "
    "allow-lan: "
    "external-controller: "
    "mode: "
    "log-level: "
    "redir-port: "
    "tproxy-port: "
    "secret: "
    "external-ui: "
    "external-ui-name: "
    "external-ui-url: "
    "tun:"
    "[[:space:]]*enable: "
    "[[:space:]]*device: "
    "[[:space:]]*stack: "
    "[[:space:]]*auto-route: "
    "[[:space:]]*auto-redirect: "
    "[[:space:]]*auto-detect-interface: "
    "[[:space:]]*dns-hijack:"
    "[[:space:]]*- any:"
    "[[:space:]]*route-exclude-address: "
    "[[:space:]]*mtu: "
    )

    declare -a add_params=(
    "port: 7891"
    "socks-port: 7892"
    "mixed-port: 7893"
    "external-controller: :7894"
    "external-ui: ui"
    "external-ui-name: xd"
    "external-ui-url: https://github.com/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.zip"
    "redir-port: 7895"
    "tproxy-port: 7896"
    "allow-lan: true"
    "mode: rule"
    "log-level: debug"
    "tun:\n  enable: false\n  device: Mihomo\n  stack: mixed\n  auto-route: true\n  auto-redirect: false\n  auto-detect-interface: true\n  dns-hijack:\n    - any:53\n  route-exclude-address: []\n  mtu: 1500"
    )

    for param in "${delete_params[@]}"; do
        echo "删除 ${config_file} 中开头为 \"${param}\" 的行："
        sed -i "/^${param}/d" "${config_file}"
        echo sed -i "/^${param}/d" "${config_file}"
    done

    for ((i=0; i<${#add_params[@]}; i++)); do
        echo "在第$((i+1))行开头添加 ${add_params[i]}"
        sed -i "$((i+1))i${add_params[i]}" "${config_file}"
        echo sed -i "$((i+1))i${add_params[i]}" "${config_file}"
    done
}

startclash(){
echo "等待软件启动，请稍候..."
echo "可能需要输入密码来干掉工具、edge和chrome(chromium)浏览器"
sudo kill -9 `ps -ef | grep -v grep | grep mihomo-linux-arm64 | awk '{print $2}'`
kill -9 `ps -ef | grep -v grep | grep mihomo-linux-arm64 | awk '{print $2}'`
kill -9 `ps -ef | grep -v grep | grep chromium | awk '{print $2}'`
kill -9 `ps -ef | grep -v grep | grep chromium-browser | awk '{print $2}'`
kill -9 `ps -ef | grep -v grep | grep tail | awk '{print $2}'`
rm -rfv "*.log" chrome-user-data/SingletonLock
chmod u+x mihomo-linux-arm64
nohup sudo ${PWD}/mihomo-linux-arm64 -d ${PWD}/.config/mihomo --ext-ui ${PWD}/.config/mihomo/ui -f ${PWD}/.config/mihomo/config.yaml > mihomo-linux-arm64.log 2>&1 &
if [ -e /usr/lib/chromium-browser/chromium-browser ];then
echo "true"
nohup /usr/lib/chromium-browser/chromium-browser --no-sandbox --disable-gpu --disable-software-rasterizer --user-data-dir="${PWD}/chrome-user-data" --proxy-server=http://127.0.0.1:7891 "https://www.youtube.com/results?search_query=免费节点&sp=EgQIAxAB" > chromium.log 2>&1 & disown
elif [ -e /usr/bin/chromium ];then
echo "true"
nohup /usr/bin/chromium --no-sandbox --disable-gpu --disable-software-rasterizer --user-data-dir="${PWD}/chrome-user-data" --proxy-server=http://127.0.0.1:7891 "https://www.youtube.com/results?search_query=免费节点&sp=EgQIAxAB" > chromium.log 2>&1 &
elif [ -e /usr/bin/chromium-browser ];then
echo "true"
nohup /usr/bin/chromium-browser --no-sandbox --disable-gpu --disable-software-rasterizer --user-data-dir="${PWD}/chrome-user-data" --proxy-server=http://127.0.0.1:7891 "https://www.youtube.com/results?search_query=免费节点&sp=EgQIAxAB" > chromium.log 2>&1 &
elif [ -e /usr/lib64/chromium-browser/chromium-browser ];then
echo "true"
nohup /usr/lib64/chromium-browser/chromium-browser --no-sandbox --disable-gpu --disable-software-rasterizer --user-data-dir="${PWD}/chrome-user-data" --proxy-server=http://127.0.0.1:7891 "https://www.youtube.com/results?search_query=免费节点&sp=EgQIAxAB" > chrome.log 2>&1 &
else 
echo -e "chromium浏览器不存在或没有正确安装，请尝试重新安装chromium浏览器\n或者您可以通过安装snap来安装chromium，这样会比较好"
fi
unset PWD
# armv8 变成 arm64 了
# tail -200f clash-linux-armv8.log
tail -200f mihomo-linux-arm64.log
}

choices(){
echo 说明
echo 一、此脚本支持chromium浏览器，所以需要安装chromium浏览器，如果有兴趣可以自己DIY别的浏览器。
echo "输入 1..12 通过联网更新文件使用，输入 13 随机执行现有文件:"
read choice
if [ $choice -eq 1 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经1启动程序！
startclash
elif [ $choice -eq 2 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/13/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经2启动程序！
startclash
elif [ $choice -eq 3 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/15/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经3启动程序！
startclash
elif [ $choice -eq 4 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/1/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经4启动程序！
startclash
elif [ $choice -eq 5 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/2/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经5启动程序！
startclash
elif [ $choice -eq 6 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/3/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经6启动程序！
startclash
elif [ $choice -eq 7 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/13/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经7启动程序！
startclash
elif [ $choice -eq 8 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/15/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经8启动程序！
startclash
elif [ $choice -eq 9 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经9启动程序！
startclash
elif [ $choice -eq 10 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/1/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经10启动程序！
startclash
elif [ $choice -eq 11 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/2/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经11启动程序！
startclash
elif [ $choice -eq 12 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/3/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经12启动程序！
startclash
elif [ $choice -eq 13 ];then
pool=(1 2 3 4 5 6 7 8 9 10 11 12)
num=${#pool[*]}
pn=${pool[$((RANDOM%num+1))]}
echo $pn
if [ "$pn" = "" ]; then
	cp -r -v config1.yaml ".config/mihomo/config.yaml"
else
	cp -r -v config$pn.yaml ".config/mihomo/config.yaml"
fi

echo 已经随机启动程序！
startclash
else
echo "what's up?"
choices
fi
}

choices
