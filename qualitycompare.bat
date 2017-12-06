@echo off
SETLOCAL EnableDelayedExpansion
cd\Users\mvonf\Documents\SCHOOL\UBC_Grad\UBC_Fall2017\EECE541\CIELAB_downsampling_Team\HDRTools16\HDRTools-master-fa1e8ed7695e084a2cfb5319318b51ea671e69ba\bin

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
		set inputfilepath=C:\Users\mvonf\Documents\SCHOOL\UBC_Grad\UBC_Fall2017\EECE541\CIELAB_downsampling_Team\MATLAB\VideoFrames\compressed\Market_1920x1080p_50_hf_709_ct2020_LABsubsampled_444\%%F
		HDRMetrics.exe -f %mypath%\EECE541files\HDRMetricCFGs\HDRMetric_CfE_%filter1%.cfg -p Input1File="!inputfilepath!\%%F_%%Q\%%F_%%Q_%%05d.exr"  >EECE541files\HDRMetricResults\%%F\HDRMetrics_%scene1%_%%F_%%Q.txt
		echo Completed: %%F with %%Q
		echo ------------------------------
		echo ------------------------------
	)
)	

pause