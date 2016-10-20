::邮件服务器工作状态监测通知脚本
::zpblog.cn
@echo off & setlocal enabledelayedexpansion
 
rem 要检测的IP和端口
set server_ip=192.168.1.8,218.218.218.218
set serverport=25,110
 
rem 模块化调用
set count=0
call :check
call :notice
::****其他代码略****
 
:check
rem ※端口检测模块--PortQry※
for /f "tokens=1,* delims=," %%i in ("!server_ip!") do (
  for %%a in (!serverport!) do (
    echo 正在检测 %%i 的 %%a 端口...
      rem 这是端口的检测代码：
      "C:\PortQryV2\PortQry.exe" -n %%i -e %%a | find ": LISTENING" >nul && (
        echo 【成功】：可以连接到 %%i:%%a
        ) || (        
        echo 【失败】：无法连通 %%i:%%a
        set status=!status! 【失败】：无法连通 %%i:%%a
        set /a count+=1
        )
      echo=
  )
  set server_ip=%%j
  goto check
)
goto :eof
:notice
rem ※判断是否通知--自己发挥吧※
if %count% GEQ 1 (
call :msg
call :mail
) else (
echo 一切正常
)
goto :eof
:mail
rem ※邮件通知模块--sendMail※
"C:\WINDOWS\system32\cmd.exe" /c C:\sendEmail\sendEmail.exe -f 123456789@qq.com -t 987654321@vip.qq.com -u  Mail Server Fault %DATE:~0,10% %TIME% -m %status% -s smtp.qq.com:587 -xu 123456789@qq.com -xp asdfghjasdfghj
goto :eof
:msg
rem ※弹框通知模块--msg※
msg  %username% /time 1800 "邮件服务器出现故障，请立即协助通知系统管理员处理。联系电话:1234567890"
goto :eof
::****其他代码略****
