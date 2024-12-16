#!/usr/bin/env bash
# 当前路径
PWD=$(pwd)/sources
mkdir -pv "${PWD}"
cd "${PWD}"

# mac配置文件处理函数
function mac_process_config {
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

# linux配置文件处理函数
function linux_process_config {
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

# 更新url节点
function update_url(){
  urls=(
    "https://raw.githubusercontent.com/Alvin9999/pac2/master/clash/config.yaml"
    "https://raw.githubusercontent.com/Alvin9999/pac2/master/clash.meta2/13/config.yaml"
    "https://raw.githubusercontent.com/Alvin9999/pac2/master/clash.meta2/15/config.yaml"
    "https://raw.githubusercontent.com/Alvin9999/pac2/master/clash/1/config.yaml"
    "https://raw.githubusercontent.com/Alvin9999/pac2/master/clash/2/config.yaml"
    "https://raw.githubusercontent.com/Alvin9999/pac2/master/clash/3/config.yaml"
    "https://raw.githubusercontent.com/Alvin9999/pac2/master/clash/13/config.yaml"
    "https://raw.githubusercontent.com/Alvin9999/pac2/master/clash/15/config.yaml"
    "https://raw.githubusercontent.com/Alvin9999/pac2/master/clash.meta2/config.yaml"
    "https://raw.githubusercontent.com/Alvin9999/pac2/master/clash.meta2/1/config.yaml"
    "https://raw.githubusercontent.com/Alvin9999/pac2/master/clash.meta2/2/config.yaml"
    "https://raw.githubusercontent.com/Alvin9999/pac2/master/clash.meta2/3/config.yaml"
  )
  
  config_files=("config1.yaml" "config2.yaml" "config3.yaml" "config4.yaml" "config5.yaml" "config6.yaml" "config7.yaml" "config8.yaml" "config9.yaml" "config10.yaml" "config11.yaml" "config12.yaml")
  
  index=0
  for url in "${urls[@]}"; do
    echo "${config_files[$index]}" \<- "Updating ${url}"
    curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 \
      --retry 2 -H "Connection: keep-alive" -k "$url" -o "${config_files[$index]}" -O
    # 获取操作系统类型
    os_type="$(uname)"

    # 设置 sed 命令的参数
    if [[ "$os_type" == "Linux" ]]; then
        # 调用函数，并传入config_files数组和索引
        linux_process_config "${config_files[$index]}"
    elif [[ "$os_type" == "Darwin" ]]; then
        # 调用函数，并传入config_files数组和索引
        mac_process_config "${config_files[$index]}"
    else
        echo "不支持的操作系统"
        exit 1
    fi

    let index++
  done
}

update_url
