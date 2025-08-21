<#
Windows IR Quick Collect (PowerShell)
- 관리자 권한 권장
- 외부 도구(EXE)는 현재 디렉터리 또는 PATH 내 위치
#>

$ErrorActionPreference = 'Continue'

# ===== 출력 폴더 생성 (YYYYMMDD) =====
$today = Get-Date -Format 'yyyyMMdd'
$outDir = "IR_Output_$today"
if (-not (Test-Path $outDir)) { New-Item -Path $outDir -ItemType Directory | Out-Null }

# 공용 실행 헬퍼
function Invoke-And-Capture {
    param(
        [Parameter(Mandatory=$true)][string]$Command,
        [string[]]$Args = @(),
        [Parameter(Mandatory=$true)][string]$OutFile,
        [string]$Header = ""
    )
    if ($Header) { $Header | Out-File -FilePath $OutFile -Encoding UTF8 }

    # 명령 경로 탐색 (현재 폴더 포함)
    $cmdPath = $Command
    if (-not (Get-Command $Command -ErrorAction SilentlyContinue)) {
        $local = Join-Path -Path (Get-Location) -ChildPath $Command
        if (Test-Path $local) { $cmdPath = $local }
    }
    if (-not (Get-Command $cmdPath -ErrorAction SilentlyContinue)) {
        "[WARN] Command not found: $Command" | Out-File -FilePath $OutFile -Append -Encoding UTF8
        return
    }

    try {
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = $cmdPath
        $psi.Arguments = ($Args -join ' ')
        $psi.RedirectStandardOutput = $true
        $psi.RedirectStandardError  = $true
        $psi.UseShellExecute = $false
        $p = [System.Diagnostics.Process]::Start($psi)
        $stdout = $p.StandardOutput.ReadToEnd()
        $stderr = $p.StandardError.ReadToEnd()
        $p.WaitForExit()

        $stdout | Out-File -FilePath $OutFile -Append -Encoding UTF8
        if ($stderr) { "`n--- STDERR ---`n$stderr" | Out-File -FilePath $OutFile -Append -Encoding UTF8 }
    } catch {
        "[ERROR] $($_.Exception.Message)" | Out-File -FilePath $OutFile -Append -Encoding UTF8
    }
}

# ===== 0. 날짜/시간 기록 =====
$dtFile = Join-Path $outDir '00_datetime.txt'
"========= 초기 분석 점검 날짜 =========" | Out-File $dtFile -Encoding UTF8
(Get-Date -Format 'yyyy-MM-dd') | Out-File $dtFile -Append -Encoding UTF8
"========= 초기 분석 점검 시간 =========" | Out-File $dtFile -Append -Encoding UTF8
(Get-Date -Format 'HH:mm:ss') | Out-File $dtFile -Append -Encoding UTF8

# ===== 1~12. 수집 =====
Invoke-And-Capture -Command 'psinfo.exe'       -Args @('-h','-s','-d') -OutFile (Join-Path $outDir '01_psinfo.txt')        -Header '========= 시스템 기본 정보 (psinfo) ========='
Invoke-And-Capture -Command 'uptime.exe'       -Args @()                -OutFile (Join-Path $outDir '02_uptime.txt')        -Header '========= 부팅 시간 정보 (uptime) ========='
Invoke-And-Capture -Command 'ipconfig.exe'     -Args @('/all')          -OutFile (Join-Path $outDir '03_ipconfig_all.txt')  -Header '========= IP 정보 (ipconfig /all) ========='
Invoke-And-Capture -Command 'net.exe'          -Args @('sess')          -OutFile (Join-Path $outDir '04_net_session.txt')   -Header '========= 세션 정보 (net sess) ========='
Invoke-And-Capture -Command 'netstat.exe'      -Args @('-na')           -OutFile (Join-Path $outDir '05_netstat_na.txt')    -Header '========= 포트 정보 (netstat -na) ========='
Invoke-And-Capture -Command 'ntlast.exe'       -Args @('-f')            -OutFile (Join-Path $outDir '06_ntlast.txt')        -Header '========= 로그온 사용자 정보 (ntlast -f) ========='
Invoke-And-Capture -Command 'fport.exe'        -Args @('/i')            -OutFile (Join-Path $outDir '07_fport_i.txt')       -Header '========= 포트별 서비스 정보 (fport /i) ========='
Invoke-And-Capture -Command 'promiscdetect.exe'-Args @()                -OutFile (Join-Path $outDir '08_promiscdetect.txt') -Header '========= Promiscuous 모드 정보 (promiscdetect) ========='
Invoke-And-Capture -Command 'net.exe'          -Args @('start')         -OutFile (Join-Path $outDir '09_net_start.txt')     -Header '========= 로컬 서비스 정보 (net start) ========='
Invoke-And-Capture -Command 'pslist.exe'       -Args @('-t')            -OutFile (Join-Path $outDir '10_pslist_t.txt')      -Header '========= 프로세스 기본 정보 (pslist -t) ========='
Invoke-And-Capture -Command 'listdlls.exe'     -Args @()                -OutFile (Join-Path $outDir '11_listdlls.txt')      -Header '========= DLL 정보 (listdlls) ========='
Invoke-And-Capture -Command 'handle.exe'       -Args @()                -OutFile (Join-Path $outDir '12_handle.txt')        -Header '========= 핸들 정보 (handle) ========='

Write-Host "`n[완료] 초기 IR 수집이 끝났습니다. 결과: $outDir`n"
