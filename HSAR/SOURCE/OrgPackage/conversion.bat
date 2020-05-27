@echo off

setlocal

set XSL_DIR=C:\GSA-Acquisition-tools\TOOLS\StructureGSA_FAR\xml\DITA_1.2\app\technicalContent\xslt\ECFRConversion2DITA_Tools
set SAXON="c:\Program Files\Adobe\Adobe FrameMaker 2019\fminit\XSLT\XSLTProcessors\saxon\SaxonHE9-7-0-20J\saxon9he.jar"
set INPUT_FILE_DEFAULT="C:\Users\tomal\Desktop\HomeLandSecurity\ECFRTitle48Fixed.xml"

set do_allstage=true
set do_stage0=false
set do_stage1=false
set do_stage2=false
set do_stage1split=true
set do_html=false

if "%1"=="" goto noparams

:param_loop
if %1==/stage0 (
	set do_stage0=true
	set do_allstage=false
	shift /1
	goto param_loop
)

if %1==/stage1 (
	set do_stage1=true
	set do_allstage=false
	shift /1
	goto param_loop
)

if %1==/html (
	set do_html=true
	shift /1
	goto param_loop
)

if %1==/stage2 (
	set do_stage2=true
	set do_allstage=false
	shift /1
	goto param_loop
)

if %1==/nosplit (
	set do_stage1split=false
	shift /1
	goto param_loop
)

:noparams

set INPUT_FILE=%1
if "%INPUT_FILE%"=="" set INPUT_FILE=%INPUT_FILE_DEFAULT%
for %%a in (%INPUT_FILE%) do (
	set "OUTPUT_FILE=%%~dpa%%~na.ditamap"
)

if "%do_allstage%"=="true" (
	set do_stage0=true
	set do_stage1=true
	set do_stage2=true
)

echo Output: %OUTPUT_FILE%

for %%a in (%INPUT_FILE%) do (
 set "STAGE0_OUTPUT=%%~dpa%%~na-stage0.xml"
 set "STAGE1_1_OUTPUT=%%~dpa%%~na-stage1-1.xml"
 set "STAGE1_2_OUTPUT=%%~dpa%%~na-stage1-2.xml"
 set "STAGE1_3_OUTPUT=%%~dpa%%~na-stage1-3.xml"
 set "STAGE1_4_OUTPUT=%%~dpa%%~na-stage1-4.xml"
 set "STAGE1_5_OUTPUT=%%~dpa%%~na-stage1-5.xml"
 set "STAGE1_6_OUTPUT=%%~dpa%%~na-stage1-6.xml"
 set "STAGE1_7_OUTPUT=%%~dpa%%~na-stage1-7.xml"
 set "STAGE1_8_OUTPUT=%%~dpa%%~na-stage1-8.xml"
 set "STAGE1_9_OUTPUT=%%~dpa%%~na-stage1-9.xml"
 set "STAGE1_OUTPUT=%%~dpa%%~na-stage1.xml"
)

rem echo %STAGE0_OUTPUT%
rem echo %STAGE1_OUTPUT%

if "%do_stage0%"=="false" goto stage1

echo Stage 0
java -cp %SAXON% net.sf.saxon.Transform  -s:%INPUT_FILE% -xsl:"%XSL_DIR%\conversion_stage0.xsl" -o:"%STAGE0_OUTPUT%"

:stage1
if "%do_stage1%"=="false" goto stage2

if "%do_stage1split%"=="true" goto stage1split

echo Stage 1
java -cp %SAXON% net.sf.saxon.Transform  -s:"%STAGE0_OUTPUT%" -xsl:"%XSL_DIR%\conversion_stage1.xsl" -o:"%STAGE1_OUTPUT%"

goto stage2

:stage1split
echo Stage 1, Part 1
java -cp %SAXON% net.sf.saxon.Transform  -s:"%STAGE0_OUTPUT%" -xsl:"%XSL_DIR%\conversion_stage1.xsl" -o:"%STAGE1_1_OUTPUT%" p-limit=60
echo Stage 1, Part 2
java -cp %SAXON% net.sf.saxon.Transform  -s:"%STAGE1_1_OUTPUT%" -xsl:"%XSL_DIR%\conversion_stage1.xsl" -o:"%STAGE1_2_OUTPUT%" p-limit=60
echo Stage 1, Part 3
java -cp %SAXON% net.sf.saxon.Transform  -s:"%STAGE1_2_OUTPUT%" -xsl:"%XSL_DIR%\conversion_stage1.xsl" -o:"%STAGE1_3_OUTPUT%" p-limit=60
echo Stage 1, Part 4
java -cp %SAXON% net.sf.saxon.Transform  -s:"%STAGE1_3_OUTPUT%" -xsl:"%XSL_DIR%\conversion_stage1.xsl" -o:"%STAGE1_4_OUTPUT%" p-limit=60
echo Stage 1, Part 5
java -cp %SAXON% net.sf.saxon.Transform  -s:"%STAGE1_4_OUTPUT%" -xsl:"%XSL_DIR%\conversion_stage1.xsl" -o:"%STAGE1_5_OUTPUT%" p-limit=60
echo Stage 1, Part 6
java -cp %SAXON% net.sf.saxon.Transform  -s:"%STAGE1_5_OUTPUT%" -xsl:"%XSL_DIR%\conversion_stage1.xsl" -o:"%STAGE1_6_OUTPUT%" p-limit=60
echo Stage 1, Part 7
java -cp %SAXON% net.sf.saxon.Transform  -s:"%STAGE1_6_OUTPUT%" -xsl:"%XSL_DIR%\conversion_stage1.xsl" -o:"%STAGE1_7_OUTPUT%" p-limit=60
echo Stage 1, Part 8
java -cp %SAXON% net.sf.saxon.Transform  -s:"%STAGE1_7_OUTPUT%" -xsl:"%XSL_DIR%\conversion_stage1.xsl" -o:"%STAGE1_8_OUTPUT%" p-limit=60
echo Stage 1, Part 9
java -cp %SAXON% net.sf.saxon.Transform  -s:"%STAGE1_8_OUTPUT%" -xsl:"%XSL_DIR%\conversion_stage1.xsl" -o:"%STAGE1_9_OUTPUT%" p-limit=60
echo Stage 1, Part 10
java -cp %SAXON% net.sf.saxon.Transform  -s:"%STAGE1_9_OUTPUT%" -xsl:"%XSL_DIR%\conversion_stage1.xsl" -o:"%STAGE1_OUTPUT%" p-limit=60

:stage2
if "%do_stage2%"=="false" goto complete

if "%do_html%"=="true" goto stage2html

echo Stage 2
java -cp %SAXON% net.sf.saxon.Transform  -s:"%STAGE1_OUTPUT%" -xsl:"%XSL_DIR%\conversion_stage2.xsl" -o:"%OUTPUT_FILE%"

goto complete

:stage2html

echo Stage 2 (html)
java -cp %SAXON% net.sf.saxon.Transform  -s:"%STAGE1_OUTPUT%" -xsl:"%XSL_DIR%\conversion_stage2html.xsl" -o:"%OUTPUT_FILE%"

:complete
echo Completed

endlocal

pause
