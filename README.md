# Windows IR Quick Collect

초기 침해사고 대응(Incident Response)을 위해 윈도우 라이브 증거를 신속하게 수집하는 스크립트 세트입니다.  
동일한 수집 항목을 배치(.bat)와 PowerShell(.ps1)로 제공합니다.

⚠️ 관리자 권한으로 실행하세요. 결과물은 날짜 기준 폴더에 개별 텍스트 파일로 저장됩니다.


## 수집 항목

- 시스템/부팅 정보: `psinfo`, `uptime`
- 네트워크 구성/연결: `ipconfig /all`, `net sess`, `netstat -na`, `fport /i`, `promiscdetect`
- 로그인 이력: `ntlast -f`
- 서비스/프로세스/DLL/핸들: `net start`, `pslist -t`, `listdlls`, `handle`
- 실행 시각 기록: 날짜/시간 헤더

## 필요 조건(도구)

- OS 기본: `date`, `time`, `ipconfig`, `net`, `netstat`
- Sysinternals: `psinfo.exe`, `uptime.exe`, `pslist.exe`, `listdlls.exe`, `handle.exe`
- Foundstone: `ntlast.exe`
- TSecurity: `promiscdetect.exe`
- Foundstone: `fport.exe`

> `scripts`와 같은 상위 디렉터리(예: 레포 루트 또는 `tools/`)에 EXE들을 둔 뒤 PATH 또는 절대경로로 호출하세요.

## 사용법

### 1) BAT
```cmd
git clone <this-repo-url>
cd windows-ir-quickcollect\scripts
win_ir_collect.bat

### 2) Powershell
git clone <this-repo-url>
cd windows-ir-quickcollect/scripts

# 필요 시 현재 세션만 실행 허용
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

.\win_ir_collect.ps1

