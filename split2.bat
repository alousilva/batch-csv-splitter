@echo off
setLocal EnableDelayedExpansion

set limit=%1%
set /a lineCounter=0
set /a filenameCounter=1
set /a counterHdr=1
set /a forCounter=1
set /a fileCounter=1
set flagHdr1=1
set flagHdr2=1
set name=
set extension=
for %%a in (%2%) do (
    set "name=%%~na"
    set "extension=%%~xa"
)

rem gets headers and lastLine
for /f "tokens=*" %%a in (%2%) do (
	if !counterHdr!==1 (
		set hdr1=%%a
	)
	if !counterHdr!==2 (
		set hdr2=%%a
	)
	rem a counter just to get the first two records (header1 and header2)
	set /a counterHdr+=1
	set lastLine=%%a
)

rem Total Records Found
rem 4 = two headers + lastline + 1
set /a totalRecords=!counterHdr!-4

rem cycles through the contents of the file
for /f "tokens=*" %%a in (%2%) do (

	rem sets the name for the splitted file
	set splitFile=!name!-part!filenameCounter!!extension!
	
	rem if there is only 1 record
	rem it dumps every thing into the new file
	if !totalRecords!==1 (
		echo %%a>>!splitFile!	
	)
	rem if there is more than 1 record
	if !totalRecords! gtr 1 (
		rem builds the first split file
		if !fileCounter!==1 (
			
			rem skips first two lines because that's where the headers are
			if !forCounter! gtr 2 (
				if !lineCounter! lss !limit! (
					if !flagHdr1!==1 if !flagHdr2!==1 (
						rem adds headers for the first splitted file
						echo !hdr1! >> !splitFile!
						echo !hdr2! >> !splitFile!
						set flagHdr1=0
						set flagHdr2=0
					)
					if !flagHdr1!==0 if !flagHdr2!==0 (
						rem adds records to the first splitted file
						echo %%a>>!splitFile!
						set /a lineCounter+=1
					)
				) else (
					rem adds lastLine to the first splitted file
					echo !lastLine!>>!splitFile!
					echo Created !splitFile!.
					set /a fileCounter+=1
					set /a filenameCounter+=1
					set lineCounter=0
					rem saves current cycle record to a new variable
					rem the next file will receive the value of firstRecordNextFile
					set firstRecordNextFile=%%a
					set flagHdr1=1
					set flagHdr2=1
				)
			)
		rem will create more split files
		) else (
			
			rem sets a newLimit
			rem this way it will not add one more record in the new file
			set /a newlimit=!limit!-1
			if !lineCounter! lss !newlimit! (
				if !flagHdr1!==1 if !flagHdr2!==1 (
					echo !hdr1! >> !splitFile!
					echo !hdr2! >> !splitFile!
					echo !firstRecordNextFile! >> !splitFile!
					set flagHdr1=0
					set flagHdr2=0
				)
				if !flagHdr1!==0 if !flagHdr2!==0 (
					echo %%a>>!splitFile!
					set /a lineCounter+=1
				)
			) else (
				echo !lastLine!>>!splitFile!
				echo Created !splitFile!.
				set /a fileCounter+=1
				set /a filenameCounter+=1
				set lineCounter=0
				set firstRecordNextFile=%%a
				set flagHdr1=1
				set flagHdr2=1
			)
		)
	)
	rem increments forCounter in each cycle
	set /a forCounter+=1
)