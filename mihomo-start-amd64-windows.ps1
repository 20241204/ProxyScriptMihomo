# 清屏
Clear-Host

# 设置控制台颜色
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

# 设置工作目录
$SourceDir = "$PSScriptRoot\sources"
Set-Location -Path $SourceDir

Write-Host "当前目录: $SourceDir"
Write-Host "开始吧小老弟！"

Write-Host "说明"
Write-Host "一、此脚本支持Chrome浏览器，所以需要安装Chrome浏览器，如果有兴趣可以自己DIY别的浏览器。"
Write-Host "二、使用时请将防火墙关闭，并允许专用网络和公用网络"
Write-Host "三、也可以将谷歌浏览器程序放到 sources\Google\Chrome\Application\ 路径中，这样即使没有安装 chrome 也可以直接使用，自行意会吧"

# 用户选择
function Get-UserChoice {
    param (
        [string[]]$Choices
    )

    Write-Host "输入 1..12 通过联网更新文件使用，输入 13 随机执行现有文件:"

    $choice = Read-Host
    if ($Choices -contains $choice) {
        return $choice
    } else {
        Write-Host "没有这个选项，请按回车键或空格键重试！"
        Read-Host
        return Get-UserChoice -Choices $Choices
    }
}

$Choices = 1..13 | ForEach-Object { $_.ToString() }
$choice = Get-UserChoice -Choices $Choices

# 下载文件函数
function Download-File {
    param (
        [string]$Url,
        [string]$OutputPath
    )

    Write-Host "Downloading $Url to $OutputPath"
    Invoke-WebRequest -Uri $Url -OutFile $OutputPath -Headers @{"Connection"="keep-alive"} -SkipCertificateCheck -TimeoutSec 60 -ErrorAction Stop
}

# 编辑 YAML 配置文件函数
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

# 下载和编辑配置文件
switch ($choice) {
    1 { Download-File -Url "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/config.yaml" -OutputPath ".config\mihomo\config.yaml" }
    2 { Download-File -Url "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/13/config.yaml" -OutputPath ".config\mihomo\config.yaml" }
    3 { Download-File -Url "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/15/config.yaml" -OutputPath ".config\mihomo\config.yaml" }
    4 { Download-File -Url "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/1/config.yaml" -OutputPath ".config\mihomo\config.yaml" }
    5 { Download-File -Url "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/2/config.yaml" -OutputPath ".config\mihomo\config.yaml" }
    6 { Download-File -Url "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/3/config.yaml" -OutputPath ".config\mihomo\config.yaml" }
    7 { Download-File -Url "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/13/config.yaml" -OutputPath ".config\mihomo\config.yaml" }
    8 { Download-File -Url "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash/15/config.yaml" -OutputPath ".config\mihomo\config.yaml" }
    9 { Download-File -Url "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/config.yaml" -OutputPath ".config\mihomo\config.yaml" }
    10 { Download-File -Url "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/1/config.yaml" -OutputPath ".config\mihomo\config.yaml" }
    11 { Download-File -Url "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/2/config.yaml" -OutputPath ".config\mihomo\config.yaml" }
    12 { Download-File -Url "https://fastly.jsdelivr.net/gh/Alvin9999/pac2@latest/clash.meta2/3/config.yaml" -OutputPath ".config\mihomo\config.yaml" }
    13 {
        $pmin = 1
        $pmax = 12
        $pnum = Get-Random -Minimum $pmin -Maximum ($pmax + 1)
        $configFile = "config$pnum.yaml"
        Copy-Item -Path $configFile -Destination ".config\mihomo\config.yaml" -Force
        Write-Host "已经随机使用文件 $configFile"
    }
}

if ($choice -ne 13) {
    Edit-Yaml -FilePath ".config\mihomo\config.yaml"
}

Write-Host "等待软件启动，请稍候..."
Write-Host "可能需要管理员权限来干掉工具、edge和chrome(chromium)浏览器"

Stop-Process -Name "mihomo-windows*" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "chrome*" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "msedge*" -Force -ErrorAction SilentlyContinue

Write-Host "启动工具"
Start-Process -FilePath "$SourceDir\mihomo-windows-amd64.exe" -ArgumentList "-d $SourceDir\.config\mihomo -ext-ui $SourceDir\.config\mihomo\ui -f $SourceDir\.config\mihomo\config.yaml"

# 检查 Chrome 和 Edge 浏览器是否存在并启动

# 检查 Chrome 浏览器
if (Test-Path "$SourceDir\Google\Chrome\Application\chrome.exe") {
    Write-Host "Chrome浏览器在 $SourceDir\Google\Chrome\Application 中"
    Start-Process -FilePath "$SourceDir\Google\Chrome\Application\chrome.exe" -ArgumentList "--user-data-dir=$SourceDir\chrome-user-data --proxy-server=http://127.0.0.1:7891 https://www.youtube.com/results?search_query=免费节点&sp=EgQIAxAB"
} else {
    Write-Host "Chrome浏览器不在 $SourceDir\Google\Chrome\Application 中，请检查是否存在 chrome.exe"
    if (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" -ErrorAction SilentlyContinue) {
        Write-Host "Chrome浏览器在 C:\Program Files\Google\Chrome\Application 中"
        Start-Process -FilePath "chrome.exe" -ArgumentList "--user-data-dir=$SourceDir\chrome-user-data --proxy-server=http://127.0.0.1:7891 https://www.youtube.com/results?search_query=免费节点&sp=EgQIAxAB"
    } else {
        Write-Host "Chrome浏览器不存在或没有正确安装，请尝试重新安装Chrome浏览器"
        
        # 检查 Edge 浏览器
        if (Test-Path "$SourceDir\Microsoft\Edge\Application\msedge.exe") {
            Write-Host "Edge浏览器在 $SourceDir\Microsoft\Edge\Application 中"
            Start-Process -FilePath "$SourceDir\Microsoft\Edge\Application\msedge.exe" -ArgumentList "--user-data-dir=$SourceDir\edge-user-data --proxy-server=http://127.0.0.1:7891 https://www.youtube.com/results?search_query=免费节点&sp=EgQIAxAB"
        } else {
            Write-Host "Edge浏览器不在 $SourceDir\Microsoft\Edge\Application 中，请检查是否存在 msedge.exe"
            if (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" -ErrorAction SilentlyContinue) {
                Write-Host "Edge浏览器在 C:\Program Files (x86)\Microsoft\Edge\Application 中"
                Start-Process -FilePath "msedge.exe" -ArgumentList "--user-data-dir=$SourceDir\edge-user-data --proxy-server=http://127.0.0.1:7891 https://www.youtube.com/results?search_query=免费节点&sp=EgQIAxAB"
            } else {
                Write-Host "Edge浏览器不存在或没有正确安装，请尝试重新安装Edge浏览器"
            }
        }
    }
}
cd $PSScriptRoot
Write-Host "已经执行，请按回车键或空格键关闭此窗口！"
Read-Host
