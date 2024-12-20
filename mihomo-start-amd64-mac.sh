#!/usr/bin/env bash
clear

# 当前路径
PWD=$(pwd)/sources
mkdir -pv "${PWD}"
cd "${PWD}"

echo "开始吧小老弟！"
echo "当前目录${PWD}"

yamledit() {
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
        "tun:\\
  enable: false\\
  device: Mihomo\\
  stack: mixed\\
  auto-route: true\\
  auto-redirect: false\\
  auto-detect-interface: true\\
  dns-hijack:\\
    - any:53\\
  route-exclude-address: []\\
  mtu: 1500"
    )

    for param in "${delete_params[@]}"; do
        echo "删除 ${config_file} 中开头为 \"${param}\" 的行："
        sed -i '' "/^${param}/d" "${config_file}"
    done

    for ((i=0; i<${#add_params[@]}; i++)); do
        echo "在第$((i+1))行开头添加 ${add_params[i]}"
        sed -i '' "$((i+1))i\\
${add_params[i]}\\
" "${config_file}"
    done
}


startmihomo(){
echo "等待软件启动，请稍候..."
echo "可能需要输入密码来干掉工具、edge和chrome(chromium)浏览器"
sudo kill -9 `ps -ef | grep -v grep | grep "mihomo-darwin-amd64" | awk '{print $2}'`
kill -9 `ps -ef | grep -v grep | grep "mihomo-darwin-amd64" | awk '{print $2}'`
kill -9 `ps -ef | grep -v grep | grep "Google Chrome" | awk '{print $2}'`
kill -9 `ps -ef | grep -v grep | grep "Microsoft Edge" | awk '{print $2}'`
kill -9 `ps -ef | grep -v grep | grep "tail" | awk '{print $2}'`
rm -rfv "*.log" chrome-user-data/SingletonLock edge-user-data/SingletonLock

chmod u+x mihomo-darwin-amd64
nohup sudo ${PWD}/mihomo-darwin-amd64 -d ${PWD}/.config/mihomo --ext-ui ${PWD}/.config/mihomo/ui -f ${PWD}/.config/mihomo/config.yaml > mihomo-darwin-amd64.log 2>&1 &
if [ -e /Applications/Microsoft\ Edge.app/Contents/MacOS/Microsoft\ Edge ];then 
echo "true"
nohup /Applications/Microsoft\ Edge.app/Contents/MacOS/Microsoft\ Edge --user-data-dir="${PWD}/edge-user-data" --proxy-server=http://127.0.0.1:7891 "https://www.youtube.com/results?search_query=免费节点&sp=EgQIAxAB" > edge.log 2>&1 &
elif [ -e /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome ];then 
echo "true"
nohup /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="${PWD}/chrome-user-data" --proxy-server=http://127.0.0.1:7891 "https://www.youtube.com/results?search_query=免费节点&sp=EgQIAxAB" > chrome.log 2>&1 &
else 
echo Chrome/Edge浏览器不存在或没有正确安装，请尝试重新安装Chrome/Edge浏览器
fi
tail -200f mihomo-darwin-amd64.log
}

choices(){
echo 说明
echo 一、此脚本支持chrome/edge浏览器，所以需要安装chrome/edge浏览器，如果有兴趣可以自己DIY别的浏览器。
echo "输入 1..12 通过联网更新文件使用，输入 13 随机执行现有文件:"
read choice
if [ $choice -eq 1 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经1启动程序！
startmihomo
elif [ $choice -eq 2 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/13/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经2启动程序！
startmihomo
elif [ $choice -eq 3 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/15/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经3启动程序！
startmihomo
elif [ $choice -eq 4 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/1/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经4启动程序！
startmihomo
elif [ $choice -eq 5 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/2/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经5启动程序！
startmihomo
elif [ $choice -eq 6 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/3/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经6启动程序！
startmihomo
elif [ $choice -eq 7 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/13/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经7启动程序！
startmihomo
elif [ $choice -eq 8 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/15/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经8启动程序！
startmihomo
elif [ $choice -eq 9 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经9启动程序！
startmihomo
elif [ $choice -eq 10 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/1/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经10启动程序！
startmihomo
elif [ $choice -eq 11 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/2/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经11启动程序！
startmihomo
elif [ $choice -eq 12 ];then
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/3/config.yaml" -o ".config/mihomo/config.yaml" -O
yamledit ".config/mihomo/config.yaml"
echo 已经12启动程序！
startmihomo
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
startmihomo
else
echo "what's up?"
choices
fi
}

choices
