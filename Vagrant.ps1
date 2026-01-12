
# Create a new knife-repo to contain your Vagrantfile
mkdir knife-repo

# Move into the new knife-repo.
cd knife-repo

# Run this command to download a file named Vagrantfile
Invoke-WebRequest -OutFile Vagrantfile https://learnchef.s3.eu-west-2.amazonaws.com/knife-profiles/Vagrantfile
# Linux
wget https://learnchef.s3.eu-west-2.amazonaws.com/knife-profiles/Vagrantfile


# Run the following command to start the virtual machine
vagrant up

vagrant port

# 
Add-Content C:\Windows\System32\drivers\etc\hosts "192.168.33.199 learn-chef.automate"


$
scp -P $(vagrant port --guest 22) vagrant@127.0.0.1:/home/vagrant/user1.pem c:\Users\Hazem\.chef\user1.pem

scp -P $(vagrant port --guest 22) vagrant@127.0.0.1:/home/vagrant/user1.pem c:\Users\Hazem\knife-repo\user1.pem


https://dev.azure.com/[REDACTED-ORG]/[REDACTED-TOKEN]









ssh -i mykey.pem user@mydomain.example
ssh -i user1.pem user1@192.168.33.199


# Upload a complete repo from VS code to Azure DevOps
git push --mirror https://dev.azure.com/hwaddah/_git/Common_Services
git push --mirror https://dev.azure.com/hwaddah/_git/AIClaimCM

git clone https://Tachyhealth@dev.azure.com/Tachyhealth/AIClaim/_git/AIClaimCM

docker run --rm \
    -p 9000:9000 \
    -v sonarqube_extensions:/opt/sonarqube/extensions \
    sonarqube
#