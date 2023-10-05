###################################### Every script in here is successfully run #################################################
OWASP/ZAP

For Windows
owasp folder        Working  No Context
docker run --rm -v C:/Users/Hazem/zap/owasp:/zap/wrk/:rw -t owasp/zap2docker-weekly zap-full-scan.py \
  -t http://>[REDACTED-URL] \
  -r OWASP-ZAP-Report.html
#  -U >[REDACTED-USER]

Full scan with context                        Working
docker run --rm -p 8082:8082 -v C:/Users/Hazem/zap/owasp:/zap/wrk/:rw -t owasp/zap2docker-weekly zap-full-scan.py -d \
 -t http://mycompany-web-54:8082 -P 8082 \
 -n mycompany01.context \
 -U >[REDACTED-USER] \
 -c zap-casa-config.conf \
 -x OWASP-ZAP-Report.html
#

Full scan with Context & Authentication          Working
docker run --rm -p 8082:8082 -v C:/Users/Hazem/zap/owasp:/zap/wrk/:rw -t owasp/zap2docker-weekly zap-full-scan.py -d \
 -t http://mycompany-web-54:8082 -P 8082 \
 -n mycompany01.context \
 -U >[REDACTED-USER] \
 -c zap-casa-config.conf \
 -z "auth.include="http://mycompany-web-54:8082.*"" \
 -x OWASP-ZAP-Report.html
# 

API
# owasp folder        Working  No Context
docker run --rm -v C:/Users/Hazem/zap/owasp:/zap/wrk/:rw -t owasp/zap2docker-weekly zap-api-scan.py \
  -t http://>[REDACTED-URL] \
  -f openapi \
  -z "-config api.key=[REDACTED] " \
  -r OWASP-ZAP-Report.html
#

##################################################################################################################################
# Port 80 local machine to port 8090 container
-p 127.0.0.1:80:8080/tcp

owasp folder        dev
docker run --rm -v C:/Users/Hazem/zap/owasp:/zap/wrk/:rw -t owasp/zap2docker-weekly zap-full-scan.py -j \
  -t http://mycompany-web-54:8082 \
  -n mycompany01.context \
  -U >[REDACTED-USER] \
  -z "auth.loginurl=http://mycompany-web-54:8082/login.aspx auth.username=">[REDACTED-USER]" auth.password=""" \
  -z "-config api.key=[REDACTED] -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true" \
  -r OWASP-ZAP-Report.html
#

# Run test without API key
-z  "-config api.addrs.addr.name=.* -config api.addrs.addr.regex=true -config api.disablekey=true" \
# Run test with API key
-z  "-config api.key=[REDACTED] -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true"

owasp folder        dev
docker run --rm -v C:/Users/Hazem/zap/owasp:/zap/wrk/:rw -t owasp/zap2docker-weekly zap-api-scan.py \
  -t http://>[REDACTED-URL] \
  -f openapi \
  -n mycompany01.context \
  -U >[REDACTED-USER] \
  -z "auth.loginurl=http://mycompany-web-54:8082/login.aspx auth.username=">[REDACTED-USER]" auth.password=""" \
  -z "-config api.key=[REDACTED] -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true" \
  -r OWASP-ZAP-Report.html
#


# Scanning API for only one page
docker run --rm -v C:/Users/Hazem/zap/owasp:/zap/wrk/:rw -t owasp/zap2docker-weekly zap-api-scan.py \
  -t http://>[REDACTED-URL] \
  -f openapi \
  -z "auth.loginurl=http://mycompany-web-54:8082/login.aspx auth.username=">[REDACTED-USER]" auth.password=""" \
  -z "-config api.key=[REDACTED] " \
  -r OWASP-ZAP-Report.html
#


docker run --rm -p 8082:8082 -v C:/Users/Hazem/zap/owasp:/zap/wrk/:rw -t owasp/zap2docker-weekly zap-full-scan.py -d \
 -t http://>[REDACTED-IP]:8082 \
 -n mycompany01.context \
 -U >[REDACTED-USER] \
 -c zap-casa-config.conf \
 -x OWASP-ZAP-Report.html
#

docker run --rm -p 8082:8082 -v C:/Users/Hazem/zap/owasp:/zap/wrk/:rw -t owasp/zap2docker-weekly zap-full-scan.py -d \
 -t http://>[REDACTED-IP]:8082
#


-t http://mycompany-web-54:8082 -P 8082 \

-z "auth.include="http://mycompany-web-54:8082.*"" \

-z "auth.loginurl=http://mycompany-web-54:8082/login.aspx auth.username=">[REDACTED-USER]" auth.password=""" \

-e ZAP_AUTH_HEADER_VALUE='<<JWT TOKEN>>' \
-z "auth.loginurl=http://mycompany-web-54:8082/login.aspx auth.username=">[REDACTED-USER]" auth.password=""" \






docker run --rm -v $(pwd):/zap/wrk/:rw -t ictu/zap2docker-weekly zap-full-scan.py -I -j -m 10 -T 60 \
  -t https://demo.website.net \
  -r testreport.html \
  --hook=/zap/auth_hook.py \
  -z "auth.loginurl=https://demo.website.net/login/index.php \
      auth.username="admin" \
      auth.password="sandbox" \
      auth.username_field="j_username" \
      auth.password_field="j_password" \
      auth.submit_field="submit" \
      auth.exclude=".*logout.*,http://url.com/somepath.*" \
      auth.include="https://api.website.net.*""
#      



#



-v C:/Users/Hazem/zap/form-auth.context:/zap/wrk/form-auth.context



docker run -v /local/path/to/file1.txt:/container/path/to/file1.txt -t boot:latest python boot.py /container/path/to/file1.txt

# Running ZAP without "file params" "No Mounted volumes"
# Using this option, there is no way to generate a report because a report needs a mounted volume
# to be uploaded from the container to the local host:
docker run --rm -t owasp/zap2docker-weekly zap-full-scan.py \
 -t https://mycompany-web-54:8082/login.aspx
#






#
  -z "auth.loginurl=https://mycompany-web-54:8082/login.aspx \
      auth.username=">[REDACTED-USER]" \
      auth.password="""
#    --hook=C:/Users/Hazem/zap/auth_hook.py \
#        -g gen.conf \


docker run -t owasp/zap2docker-weekly zap-api-scan.py -t https://127.0.0.1/openapi.json -f openapi 
#

API scan
docker run --rm -v C:/Users/Hazem/zap/:/zap/wrk/:rw \
 -t owasp/zap2docker-weekly zap-api-scan.py \
 -t  https://127.0.0.1/openapi.json -f openapi  
#
docker run --rm -v C:/Users/Hazem/zap/:/zap/wrk/:rw -t owasp/zap2docker-weekly zap-api-scan.py -I \
  -t https://mycompany-web-54:8082/login.aspx \
  -g gen.conf \
  -f openapi \
  -r scan-report.html \
  -x OWASP-ZAP-Report.xml \
  --hook=C:/Users/Hazem/zap/auth_hook.py \
  -z "auth.loginurl=https://mycompany-web-54:8082/login.aspx \
      auth.username=">[REDACTED-USER]" \
      auth.password=""" 
#

For Linux & MacOS
# Running a passive scan with automatic authentication.
docker run --rm -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-weekly zap-full-scan.py -I \
  -t https://mycompany-web-54:8082/login.aspx \
  -g gen.conf \
  -r scan-report.html \
  -x OWASP-ZAP-Report.xml \
  -z "auth.loginurl=https://mycompany-web-54:8082/login.aspx \
      auth.username=">[REDACTED-USER]" \
      auth.password="""
#  --hook=/zap/auth_hook.py \




docker run --rm --user $(id -u):$(id -g) -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-weekly zap-baseline.py \
 -t https://www.example.com -g gen.conf -r testreport.html
#    


find zap  -type d -exec chmod 777 {} \;
find zap  -type f -exec chmod 777 {} \;
sudo find /myagent  -type f -exec chmod 777 {} \;


mail -s "Backup" -a /home/zap/scan-report.html >[REDACTED-EMAIL] < message.txt
mail -s " scan-report.html" -a /home/zap/scan-report.html >[REDACTED-EMAIL] < message.txt

#  --hook=/zap/auth_hook.py \


sudo docker run --rm -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-stable zap-full-scan.py -t https://>[REDACTED-URL] -g gen.conf -x OWASP-ZAP-Report.xml -r scan-report.html


https://>[REDACTED-URL]

# Running a passive scan with automatic authentication.
docker run --rm -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-stable zap-baseline.py -I -j \
  -t https://>[REDACTED-URL] \
  -r testreport.html \
  --hook=/zap/auth_hook.py \
  -z "auth.loginurl=http://mycompany-web-54:8082/login.aspx \
      auth.username=">[REDACTED-USER]" \
      auth.password="""
#

# Running a passive scan with automatic authentication.
docker run --rm -v $(pwd):/zap/wrk/:rw -t ictu/zap2docker-weekly zap-baseline.py -I -j \
  -t https://demo.website.net \
  -r testreport.html \
  --hook=/zap/auth_hook.py \
  -z "auth.loginurl=https://demo.website.net/login/index.php \
      auth.username="admin" \
      auth.password="sandbox""
#


# Running an API scan with a provided Bearer token.
# First retrieve a token, for example using Curl and pass it to ZAP.
docker run --rm -v $(pwd):/zap/wrk/:rw -t ictu/zap2docker-weekly zap-api-scan.py -I \
  -t https://demo.website.net/api/docs/openapidocs.json \
  -f openapi \
  -r testreport.html \
  --hook=/zap/auth_hook.py \
  -z "auth.bearer_token=[REDACTED]"
#

# Running a full scan (max 10 mins spider and max 60 min scanning) with manual authentication and including an additional URL in the scope.
docker run --rm -v $(pwd):/zap/wrk/:rw -t ictu/zap2docker-weekly zap-full-scan.py -I -j -m 10 -T 60 \
  -t https://demo.website.net \
  -r testreport.html \
  --hook=/zap/auth_hook.py \
  -z "auth.loginurl=https://demo.website.net/login/index.php \
      auth.username="admin" \
      auth.password="sandbox" \
      auth.username_field="j_username" \
      auth.password_field="j_password" \
      auth.submit_field="submit" \
      auth.exclude=".*logout.*,http://url.com/somepath.*" \
      auth.include="https://api.website.net.*"
#



