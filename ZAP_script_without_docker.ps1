
docker run --rm -v /c/Users/Hazem/zap/owasp:/zap/wrk/:rw -t devopsacrprd001.azurecr.io/debian:Ready /home/zap/ZAP_2.12.0/zap.sh -cmd `
 -quickurl https://www.mycompany.com `
 -quickout Results/OWASP-ZAP-Report.html `
 -quickprogress 
#


docker run --rm -v C:\\Users\\Hazem\\zap\\owasp:/zap/wrk/:rw -t devopsacrprd001.azurecr.io/debian:Ready /home/zap/ZAP_2.12.0/zap.sh -daemon \
 -quickurl https://www.mycompany.com \
 -quickout Results/OWASP-ZAP-Report.html \
 -quickprogress
#



/home/zap/ZAP_2.12.0/

chmod +x /home/zap/ZAP_2.12.0/zap.sh


sudo find /home/zap/ZAP_2.12.0/Results -type d -exec chmod 777 {} \;
sudo find /home/zap/ZAP_2.12.0/Results -type f -exec chmod 777 {} \;


sudo ./zap.sh -cmd -quickurl https://www.mycompany.com -quickprogress 
-quickout /home/zap/ZAP_2.12.0/Results/OWASP-ZAP-Report.html -quickprogress

sudo ./zap.sh -cmd -quickurl http://>[REDACTED-IP]:8082 -quickout /home/zap/ZAP_2.12.0/Results/OWASP-ZAP-Report.html -quickprogress

./zap.sh -cmd -quickurl https://www.mycompany.com -quickprogress -quickout /home/hazem/Documents/ZAP.html


# Using Automation Framework:
# Windows
docker run --rm -v C:/Users/Hazem/zap/owasp:/zap/wrk/:rw -t owasp/zap2docker-stable zap.sh -cmd -autorun /zap/wrk/zap.yaml

# Linux
docker run --rm -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-stable zap.sh -cmd -autorun /zap/wrk/zap.yaml
