# 清屏
Clear-Host

# 设置控制台颜色
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

# 设置工作目录
$PWD = "$PSScriptRoot\sources"
Set-Location -Path $PWD

Write-Host "当前目录: $PWD"

# 定义 URL 列表和配置文件名列表
$URLS = @(
    "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/config.yaml",
    "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/13/config.yaml",
    "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/15/config.yaml",
    "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/1/config.yaml",
    "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/2/config.yaml",
    "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/3/config.yaml",
    "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/13/config.yaml",
    "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/15/config.yaml",
    "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/config.yaml",
    "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/1/config.yaml",
    "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/2/config.yaml",
    "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/3/config.yaml"
)

$CONFIG_FILES = @(
    "config1.yaml",
    "config2.yaml",
    "config3.yaml",
    "config4.yaml",
    "config5.yaml",
    "config6.yaml",
    "config7.yaml",
    "config8.yaml",
    "config9.yaml",
    "config10.yaml",
    "config11.yaml",
    "config12.yaml"
)

function Edit-Yaml {
    param (
        [string]$FilePath
    )

    Write-Host "正在编辑 $FilePath，请稍候..."
    Write-Host "删除替换修改 port: 7891 socks-port: 7892 mixed-port: 7893 external-controller: :7894 redir-port: 7895 tproxy-port: 7896 allow-lan: true mode: rule log-level: debug secret: ?"
    $content = Get-Content $FilePath | Where-Object { 
        $_ -notmatch "^port: 7890|^mixed-port: 7890|^socks-port: 7891|^allow-lan: |^external-controller: |^mode: |^log-level: |^secret: " 
    }
    $newContent = @("port: 7891", "socks-port: 7892", "mixed-port: 7893", "external-controller: :7894", "external-ui: ui", "external-ui-name: xd", "external-ui-url: https://github.com/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.zip",
    "redir-port: 7895", "tproxy-port: 7896", "allow-lan: true", "mode: rule", "log-level: debug",
    "tun:", "  enable: false", "  device: Mihomo", "  stack: mixed", "  auto-route: true", "  auto-redirect: false", "  auto-detect-interface: true", "  dns-hijack:", "    - any:53", "  route-exclude-address: []", "  mtu: 1500") + $content
    $newContent | Set-Content $FilePath
    Write-Host "替换 utf-8 crlf 为 lf 即 去除每行结尾的 `r"
    (Get-Content $FilePath) -join "`n" | Set-Content -NoNewline $FilePath
}

# 更新配置文件并进行操作
for ($i = 0; $i -lt $URLS.Length; $i++) {
    Write-Host "Updating $($URLS[$i])"
    Invoke-WebRequest -Uri $URLS[$i] -OutFile $CONFIG_FILES[$i] -Verbose

    # 编辑 YAML 文件
    Edit-Yaml -FilePath $CONFIG_FILES[$i]
}
cd $PSScriptRoot
Write-Host "已经完成，请按回车键或空格键关闭此窗口！"
Read-Host
