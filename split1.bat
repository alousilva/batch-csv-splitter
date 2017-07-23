@echo off
setLocal EnableDelayedExpansion

set limit=%1%
set /a lineCounter=0
set /a filenameCounter=1
set flagHdr1=1
set /a counterHdr=1
set /a fileCounter=1
set name=
set extension=
for %%a in (%2%) do (
    set "name=%%~na"
    set "extension=%%~xa"

)

rem gets header
for /f "tokens=*" %%a in (%2%) do (
	if !counterHdr!==1 (
		set hdr1=%%a
	)
	set /a counterHdr+=1
)

rem cycles through the contents of the file
for /f "tokens=*" %%a in (%2%) do (
	
	rem sets the name for the splitted file
    set splitFile=!name!-part!filenameCounter!!extension!
	rem builds the first split file
	if !fileCounter!==1 (
		if !lineCounter! geq !limit! (
			set /a filenameCounter+=1
			set lineCounter=0
			set /a fileCounter+=1
			echo %%a>>!splitFile!
			rem echo Created !splitFile!.
		) else (
			echo %%a>>!splitFile!
			set /a lineCounter+=1
		)
	rem will create more split files
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
			rem echo Created !splitFile!.
		)	
	)
)