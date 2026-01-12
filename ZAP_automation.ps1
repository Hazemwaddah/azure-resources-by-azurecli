
########################################################################################################
#                   Use ZAP in daemon mode

C:\Progra~1\OWASP\Zed/Attack/Proxy\.\zap.sh -daemon -quickurl http://mycompany-web-54.mycompany.org -quickout E:\zap\OWASP-ZAP-Report.xml -quickprogress


cd "C:\Progra~1\OWASP\Zed Attack Proxy\"
.\zap.sh -daemon -quickurl http://mycompany-web-54.mycompany.org -quickout E:\zap\OWASP-ZAP-Report.xml -quickprogress

# Bash
./zap.sh -cmd -quickurl http://mycompany-web-54.mycompany.org -quickout /tmp/OWASP-ZAP-Report.html -quickprogress
./zap.sh -cmd -quickurl https://www.mycompany.com -quickout /home/zap/ZAP_2_12_0/OWASP-ZAP-Report.html -quickprogress
./zap.sh -cmd -quickurl https://www.mycompany.com -quickprogress

# PowerShell
.\zap.sh -daemon -quickurl http://mycompany-web-54.mycompany.org -quickout C:\Users\Hazem\zap\OWASP-ZAP-Report.html -quickprogress

# After running this command, it's important to kill java process in order to be able to re-run it again later:
# This command kills any process/task with the name java on it [Windows OS]:
wmic process where "name like '%java%'" delete

# Kill the same process on a remote machine:
wmic /node:computername /user:adminuser /password:password process where "name like '%java%'" delete

# Alternative way to kill the java process [windows OS]
# Open the windows cmd. First list all the java processes,
jps -m

# now get the name and run below command,
for /f "tokens=1" %i in ('jps -m ^| find "Name_of_the_process"') do ( taskkill /F /PID %i )

# or simply kill the process ID
taskkill /F /PID <ProcessID>

# Displays running tasks:
Get-Process
########################################################################################################
#                   Use ZAP with docker

docker run -t owasp/zap2docker-stable zap-full-scan.py -t https://www.google.com
docker run -t owasp/zap2docker-stable zap-baseline.py -t https://www.google.com

docker run -t owasp/zap2docker-stable zap-baseline.py -t https://www.google.com -g gen.conf -r report.html


docker run -v C:\Users\Hazem\zap\:/zap/wrk/:rw -t owasp/zap2docker-stable zap-baseline.py -cmd -autorun /zap/wrk/zap.yaml -g gen.conf -r report.html


docker run --rm -v C:\Users\Hazem\zap\pipeline\:/zap/wrk/:rw -t owasp/zap2docker-stable zap-baseline.py -t http://mycompany-web-54.mycompany.org -g gen.conf -r baseline-report.html
docker run --rm -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-stable zap-full-scan.py -t http://mycompany-web-54.mycompany.org -g gen.conf -r full-scan-report.html
docker run --rm -v C:\Users\Hazem\zap\pipeline\:/zap/wrk/:rw -t owasp/zap2docker-stable zap-api-scan.py -t http://mycompany-web-54.mycompany.org -g gen.conf -r api-report.html
exit 0 # To prevent powershell script ending with exit 1 error. It's a bug in powershell

docker run -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-stable zap.sh -cmd -autorun /zap/wrk/zap.yaml


docker run --rm -v C:\agent\_work\r1\a\_Hazem-Test\:/zap/wrk/:rw -t owasp/zap2docker-stable zap-full-scan.py -t http://mycompany-web-54.mycompany.org -g gen.conf -r full-scan-report.html





.EXAMPLE
$results = Invoke-ScriptAnalyzer -Settings ./PSScriptAnalyzerSettings.psd1 -Path ./ -Recurse
.\ConverTo-NUnitXml.ps1 -ScriptAnalyzerResult $results -Path ./PSScriptAnalyzerFailures.xml



docker run -v C:\Users\Hazem\zap\:/zap/wrk/:rw -t owasp/zap2docker-stable zap.sh -cmd -autorun /zap/wrk/zap.yaml


docker run -v C:\Users\Hazem\zap\:/zap/wrk/:rw -t owasp/zap2docker-stable:2.12.0 zap.sh -cmd -autorun /zap/wrk/zap.yaml -r report.html

docker run -v C:\Users\Hazem\zap\:/zap/wrk/:rw -t owasp/zap2docker-stable zap.sh -cmd -autorun /zap/wrk/zap.yaml -r report.html
docker run -v C:\Users\Hazem\zap\:/zap/wrk/:rw -t owasp/zap2docker-stable zap.sh -daemon -autorun /zap/wrk/zap.yaml -r report.html


C:\Users\Hazem\zap>




az artifacts universal publish --organization https://dev.azure.com/ICC-mycompany --feed SecurityTestingHazem --name security_testing --version 1.0.0 --description "ZAP Testing" --path .


az login --allow-no-subscription

az artifacts universal publish \
 --organization https://dev.azure.com/ICC-mycompany \
 --feed SecurityTestingHazem \
 --name security_testing \
 --version 1.0.0 \
 --description "ZAP_Testing" \
 --path .

