@echo off
setlocal

REM ===== 출력 폴더 생성 (YYYYMMDD) =====
for /f "tokens=1-3 delims=/- " %%a in ("%date%") do (
    set YYYY=%%c
    set MM=%%a
    set DD=%%b
)
set "OUTDIR=IR_Output_%YYYY%%MM%%DD%"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"

REM ===== 0. 날짜/시간 기록 =====
echo ========= 초기 분석 점검 날짜 =========> "%OUTDIR%\00_datetime.txt"
date /t >> "%OUTDIR%\00_datetime.txt"
echo ========= 초기 분석 점검 시간 =========>> "%OUTDIR%\00_datetime.txt"
time /t >> "%OUTDIR%\00_datetime.txt"

REM ===== 1. 시스템 기본 정보 (psinfo) =====
echo ========= 시스템 기본 정보 (psinfo) =========> "%OUTDIR%\01_psinfo.txt"
psinfo -h -s -d >> "%OUTDIR%\01_psinfo.txt" 2>&1

REM ===== 2. 부팅 시간 정보 (uptime) =====
echo ========= 부팅 시간 정보 (uptime) =========> "%OUTDIR%\02_uptime.txt"
uptime >> "%OUTDIR%\02_uptime.txt" 2>&1

REM ===== 3. IP 구성 (ipconfig /all) =====
echo ========= IP 정보 (ipconfig /all) =========> "%OUTDIR%\03_ipconfig_all.txt"
ipconfig /all >> "%OUTDIR%\03_ipconfig_all.txt" 2>&1

REM ===== 4. 세션 정보 (net sess) =====
echo ========= 세션 정보 (net sess) =========> "%OUTDIR%\04_net_session.txt"
net sess >> "%OUTDIR%\04_net_session.txt" 2>&1

REM ===== 5. 포트 정보 (netstat -na) =====
echo ========= 포트 정보 (netstat -na) =========> "%OUTDIR%\05_netstat_na.txt"
netstat -na >> "%OUTDIR%\05_netstat_na.txt" 2>&1

REM ===== 6. 로그온 사용자 정보 (ntlast -f) =====
echo ========= 로그온 사용자 정보 (ntlast -f) =========> "%OUTDIR%\06_ntlast.txt"
ntlast -f >> "%OUTDIR%\06_ntlast.txt" 2>&1

REM ===== 7. 포트별 서비스 정보 (fport /i) =====
echo ========= 포트별 서비스 정보 (fport /i) =========> "%OUTDIR%\07_fport_i.txt"
fport /i >> "%OUTDIR%\07_fport_i.txt" 2>&1

REM ===== 8. NIC Promiscuous 모드 (promiscdetect) =====
echo ========= Promiscuous 모드 정보 (promiscdetect) =========> "%OUTDIR%\08_promiscdetect.txt"
promiscdetect >> "%OUTDIR%\08_promiscdetect.txt" 2>&1

REM ===== 9. 로컬 서비스 목록 (net start) =====
echo ========= 로컬 서비스 정보 (net start) =========> "%OUTDIR%\09_net_start.txt"
net start >> "%OUTDIR%\09_net_start.txt" 2>&1

REM ===== 10. 프로세스 트리 (pslist -t) =====
echo ========= 프로세스 기본 정보 (pslist -t) =========> "%OUTDIR%\10_pslist_t.txt"
pslist -t >> "%OUTDIR%\10_pslist_t.txt" 2>&1

REM ===== 11. 로드된 DLL (listdlls) =====
echo ========= DLL 정보 (listdlls) =========> "%OUTDIR%\11_listdlls.txt"
listdlls >> "%OUTDIR%\11_listdlls.txt" 2>&1

REM ===== 12. 핸들 정보 (handle) =====
echo ========= 핸들 정보 (handle) =========> "%OUTDIR%\12_handle.txt"
handle >> "%OUTDIR%\12_handle.txt" 2>&1

echo.
echo [완료] 초기 IR 수집이 끝났습니다. 결과: "%OUTDIR%"
echo.
endlocal
