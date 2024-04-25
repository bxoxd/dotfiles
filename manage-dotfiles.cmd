@echo off
setlocal enabledelayedexpansion

REM 设置原文件列表
set "source_files=C:\Users\legion\vimfiles\vimrc,C:\Users\legion\.gitconfig"
REM 设置目标目录
set "destination_dir=C:\Users\legion\dotfiles"

REM 将逗号分隔的文件路径分割成数组
for %%F in ("%source_files:,=" "%") do (
    REM 获取原文件的文件名
    set "filename=%%~nxF"
    
    REM 构建目标文件的完整路径
    set "destination_file=%destination_dir%\!filename!"

    REM 检查目标文件是否存在
    if exist "!destination_file!" (
        REM 获取原文件和目标文件的最后修改时间
        for %%A in ("%%F") do (
            set "source_time=%%~tA"
        )
        for %%B in ("!destination_file!") do (
            set "destination_time=%%~tB"
        )

        REM 比较最后修改时间
        if "!source_time!" gtr "!destination_time!" (
            REM 如果原文件更新，则复制到目标目录
            copy /Y "%%F" "!destination_file!"
            echo Updated: %%F
        ) else (
            echo Skipped: %%F
        )
    ) else (
        REM 如果目标文件不存在，则直接复制
        copy /Y "%%F" "!destination_file!"
        echo Copied: %%F
    )
)

echo Copied.

rem 切换到目标目录
cd /d "%destination_dir%"

rem 将所有修改添加到暂存区
git add .

rem 获取当前系统时间作为提交注释
for /f "tokens=2 delims==." %%a in ('wmic OS Get localdatetime /value') do set "datetime=%%a"
set "datestamp=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2% %datetime:~8,2%:%datetime:~10,2%:%datetime:~12,2%"
set "comment=Auto commit at %datestamp%"

rem 提交修改到仓库
git commit -m "%comment%"

git push origin main

echo Pushed.

pause