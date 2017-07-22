@echo off
setLocal EnableDelayedExpansion

set limit=%1%
set /a lineCounter=0
set /a filenameCounter=1
set flagHdr1=1
set /a counter=1
set /a fileCounter=1
set name=
set extension=
for %%a in (%2%) do (
    set "name=%%~na"
    set "extension=%%~xa"
)

for /f "tokens=*" %%a in (%2%) do (
	if !counter!==1 (
		set hdr1=%%a
		REM echo !hdr1!
	)
	set /a counter+=1
)

for /f "tokens=*" %%a in (%2%) do (

    set splitFile=!name!-part!filenameCounter!!extension!
	if !fileCounter!==1 (
		if !lineCounter! geq !limit! (
			set /a filenameCounter+=1
			set lineCounter=0
			set /a fileCounter+=1
			echo %%a>>!splitFile!
			REM echo Created !splitFile!.
		) else (
			echo %%a>>!splitFile!
			set /a lineCounter+=1
		)
	) else (
		if !lineCounter! lss !limit! (
			if !flagHdr1!==1 (
				echo !hdr1! >> !splitFile!
				set flagHdr1=0
				set /a lineCounter+=1
			)
			if !flagHdr1!==0 (
				echo %%a>>!splitFile!
				set /a lineCounter+=1
			)
		) else (
			echo %%a>>!splitFile!
			set /a filenameCounter+=1
			set lineCounter=0
			set flagHdr1=1
			REM echo Created !splitFile!.
		)	
	)
)