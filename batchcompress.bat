@echo off
cd\Users\mvonf\Documents\SCHOOL\UBC_Grad\UBC_Fall2017\EECE541\CIELAB_downsampling_Team\HM-16.16\bin\vc2015\x64\Release

set mypath=%cd%

set scene1=Market

set filter1=MPEGMvF07
set filter2=lanczos3
set filter3=MPEGCfE
set filter4=MPEGSukey04
set filter5=MPEGSukey06
set filter6=MPEGYuki05
set filter7=MPEGSuperAnchor
set filter8=MPEGMvF06

set QP1=QP22
set QP2=QP29
set QP3=QP32
set QP4=QP34

for %%Q in (%QP1%,%QP2%,%QP3%,%QP4%) do ( 
		for %%F in (%filter1%,%filter2%,%filter3%,%filter4%,%filter5%,%filter6%,%filter7%,%filter8%) do (
		echo Analyzing: %%F with %%Q
		echo ------------------------------
		TAppEncoder.exe -o %mypath%\EECE541files\RECfiles\%%F\REC_%%F_%%Q.yuv -c %mypath%\EECE541files\CompressionCFGs\encoder_randomaccess_main10_%%Q.cfg -c  %mypath%\EECE541files\CompressionCFGs\Sequence%%F.cfg >EECE541files\CompressionResults\%%F\CompressionLog_%scene1%_%%F_%%Q.txt
		echo Completed: %%F with %%Q
		echo ------------------------------
		echo ------------------------------
	)
)	

pause