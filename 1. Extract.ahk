﻿; 
; Script by alanfox2000
;

#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
if A_Is64bitOS = 1 
{
    7z = %A_WorkingDir%\Tools\7zip\64\7z.exe
}
else
{
    7z = %A_WorkingDir%\Tools\7zip\32\7z.exe
}

sfxsplit =  %A_WorkingDir%\Tools\SfxSplit\SfxSplit.exe
input_dir = %A_WorkingDir%\Temp\Input
output_dir = %A_WorkingDir%\Temp\Output
extract_dir = %A_WorkingDir%\Temp\Extract

Loop, Files, %input_dir%\*.exe, F
{

    FileNameNoExt := StrReplace(A_LoopFileName, "." . A_LoopFileExt)
    NvCplSetupInt = %extract_dir%\%FileNameNoExt%\Display.Driver\NvCplSetupInt.exe
    NvCplSetupIntDir = %extract_dir%\%FileNameNoExt%\NvCplSetupInt
    NvContainerSetup = %extract_dir%\%FileNameNoExt%\Display.Driver\NvContainerSetup.exe
    NvContainerSetupDir = %extract_dir%\%FileNameNoExt%\NvContainerSetup
    NvENC64 = %extract_dir%\%FileNameNoExt%\Display.Driver\nvencodeapi64.dl_
    NvENC32 = %extract_dir%\%FileNameNoExt%\Display.Driver\nvencodeapi.dl_

    ; SFX Extract
    runwait, "%Sign64%" remove /s "%A_LoopFileFullPath%"
    runwait, %ComSpec% /c ""%sfxsplit%" "%A_LoopFileFullPath%" -m "%output_dir%\%A_LoopFileName%.sfx" -c "%output_dir%\%A_LoopFileName%.txt" -a "%output_dir%\%A_LoopFileName%.7z" -b"

    ; Driver Archive Extract
    runwait, %7z% x "%output_dir%\%A_LoopFileName%.7z" -y -o"%extract_dir%\%FileNameNoExt%" setup.exe setup.cfg ListDevices.txt license.txt EULA.txt -r Display.Driver\* HDAudio\* NVI2\* PhysX\* PPC\* NGXCore\* -xr@exclude.lst

    ;NvENC Extract
    runwait, %7z% x "%NvENC64%" -y -o"%extract_dir%\%FileNameNoExt%\NvENC"
    runwait, %7z% x "%NvENC32%" -y -o"%extract_dir%\%FileNameNoExt%\NvENC"

;    runwait, %7z% x "%output_dir%\%A_LoopFileName%.7z" -y -o"%extract_dir%\%FileNameNoExt%" setup.exe setup.cfg ListDevices.txt license.txt EULA.txt -r Display.Driver\* HDAudio\* NVI2\* PhysX\* PPC\* NGXCore\* -x!GFExperience\EULA.txt -x!GFExperience\license.txt -x!NVI2\NVNetworkService.exe -x!NVI2\NVNetworkServiceAPI.dll -x!NVI2\NvInstallerUtil.dll -x!FrameViewSDK\EULA.txt -x!Update.Core\NvTmMon.exe -x!Update.Core\NvTmRep.exe -x!Display.Driver\DisplayDriverRAS.dll -x!Display.Driver\NvTelemetry64.dll -x!Display.Driver\Display.NvContainer\plugins\LocalSystem\_DisplayDriverRAS.dll -x!Display.Driver\NvProfileUpdaterPlugin.dll -x!Display.Driver\Display.NvContainer\plugins\Session\NvProfileUpdaterPlugin.dll -x!Display.Driver\nvtopps.dll -x!Display.Driver\Display.NvContainer\plugins\Session\_nvtopps.dll -x!Display.Driver\nvgwls.exe

    If FileExist(NvCplSetupInt)
    {
        FileCreateDir, %NvCplSetupIntDir%
    
        ; NvCplSetupInt SFX Extract
        runwait, "%Sign64%" remove /s "%NvCplSetupInt%"
        runwait, %ComSpec% /c ""%sfxsplit%" "%NvCplSetupInt%" -m "%NvCplSetupIntDir%\NvCplSetupInt.sfx" -c "%NvCplSetupIntDir%\NvCplSetupInt.txt" -a "%NvCplSetupIntDir%\NvCplSetupInt.7z" -b"
        
        ; NvCplSetupInt Archive Extract
        runwait, %7z% x "%NvCplSetupInt%" -y -o"%NvCplSetupIntDir%\Extract" -xr!*.chm
    
    }
    
    If FileExist(NvContainerSetup)
    {
        FileCreateDir, %NvContainerSetupDir%
    
        ; NvContainerSetup SFX Extract
        runwait, "%Sign64%" remove /s "%NvContainerSetup%"
        runwait, %ComSpec% /c ""%sfxsplit%" "%NvContainerSetup%" -m "%NvContainerSetupDir%\NvContainerSetup.sfx" -c "%NvContainerSetupDir%\NvContainerSetup.txt" -a "%NvContainerSetupDir%\NvContainerSetup.7z" -b"
        
        ; NvContainerSetup Archive Extract
        runwait, %7z% x "%NvContainerSetup%" -y -o"%NvContainerSetupDir%\Extract" -x!x86_64\MessageBus.dll -x!x86_64\messagebus.conf -x!x86_64\NvMsgBusBroadcast.dll -x!NVDisplayMessageBus.nvi
    
    }

}

ExitApp