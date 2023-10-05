
#region Stage 1:   Build and run the web app
Reference of these steps can be found in the below link:
https://docs.microsoft.com/en-us/learn/modules/create-a-build-pipeline/3-build-locally

Github.com
# Get the source code from another github account
# Create a fork [a copy from the repo in your account]

# Clone your fork locally
git clone https://github.com/Hazemmycompany/mslearn-tailspin-spacegame-web.git

# Go to the directory that contains the source code
cd mslearn-tailspin-spacegame-web

# Set the upstream remote
# A remote is a Git repository where team members collaborate (similar to a repository on GitHub).
# Let's list your remotes and add a remote that points to Microsoft's copy of the repository 
# so you can get the latest sample code.
git remote -v
# Results:
# origin  https://github.com/username/mslearn-tailspin-spacegame-web.git (fetch)
# origin  https://github.com/username/mslearn-tailspin-spacegame-web.git (push)

# To create a remote named upstream that points to the Microsoft repository:
git remote add upstream https://github.com/MicrosoftDocs/mslearn-tailspin-spacegame-web.git

# Run git remote a second time to see the changes:
git remote -v

# Results:
# origin  https://github.com/username/mslearn-tailspin-spacegame-web.git (fetch)
# origin  https://github.com/username/mslearn-tailspin-spacegame-web.git (push)
# upstream        https://github.com/MicrosoftDocs/mslearn-tailspin-spacegame-web.git (fetch)

# The easiest way to open the project is to reopen Visual Studio Code in the current directory. 
# To do so, run the following command from the integrated terminal:
code -r .

# Build and run the web app
# Build the app
dotnet build --configuration Release
# Run the app
dotnet run --configuration Release --no-build --project Tailspin.SpaceGame.Web

# Verify the application is running by navigating to:
http://localhost:5000
#endregion

#region Stage 2:   Plan your build tasks

# You can follow this article
https://docs.microsoft.com/en-us/learn/modules/create-a-build-pipeline/4-plan-build-tasks

# Setup your Azure DevOps environment
https://docs.microsoft.com/en-us/learn/modules/create-a-build-pipeline/5-set-up-environment

# Get the Azure DevOps project
# Run the template
https://azuredevopsdemogenerator.azurewebsites.net/?x-ms-routing-name=self&name=create-build-pipeline

# Create the pipeline:
https://docs.microsoft.com/en-us/learn/modules/create-a-build-pipeline/6-create-the-pipeline
#endregion

#region Stage 3:   Add Build tasks:

# To fetch the latest changes from GitHub and update your main branch, run this git pull command.
git pull origin main

# To create a branch named build-pipeline, run this git checkout command:
git checkout -B build-pipeline

# From the integrated terminal, to add azure-pipelines.yml to the index, commit the change, 
# and push the change up to GitHub, run the following Git commands. 
# These steps are similar to the steps you performed earlier.
git add azure-pipelines.yml
git commit -m "Add build tasks"
git push origin build-pipeline -f # -f Force but not recommended
#endregion


#region Stage 4:   Publish the result to the pipeline
# Add the below task to the "azure-pipelines.yml" yaml file:
"
- task: DotNetCoreCLI@2
  displayName: 'Publish the project - Release'
  inputs:
    command: 'publish'
    projects: '**/*.csproj'
    publishWebProjects: false
    arguments: '--no-build --configuration Release --output $(Build.ArtifactStagingDirectory)/Release'
    zipAfterPublish: true

- task: PublishBuildArtifacts@1
  displayName: 'Publish Artifact: drop'
  condition: succeeded()
#
"
# Add azure-pipelines.yml to the index, commit the change, and push the change up to GitHub:
git add azure-pipelines.yml
git commit -m "Refactor common variables"
git push origin build-pipeline

# you can find more details in the link below:
https://docs.microsoft.com/en-us/learn/modules/create-a-build-pipeline/7-publish-build-result
#endregion



#region   Use variables
# Use variables for repeatitive information:
# Add variable declaration to yaml file:
"
variables:
  buildConfiguration: 'Release'
  wwwrootDir: 'Tailspin.SpaceGame.Web/wwwroot'
  dotnetSdkVersion: '6.x'
# "

# Reference to a variable in the yaml file:

"
- script: './node_modules/.bin/node-sass $(wwwrootDir) --output $(wwwrootDir)'
  displayName: 'Compile Sass assets'
# "

# Add azure-pipelines.yml to the index, commit the change, and push the change up to GitHub:
git add azure-pipelines.yml
git commit -m "Refactor common variables"
git push origin build-pipeline

# you can find more details in the link below:
https://docs.microsoft.com/en-us/learn/modules/create-a-build-pipeline/7-publish-build-result
#endregion

#region Create a template to use in Azure DevOps:
# Create a directory for the template at the root of the project:
mkdir templates

# Add azure-pipelines.yml to the index, commit the change, and push the change up to GitHub:
git add azure-pipelines.yml templates/build.yml
git commit -m "Support build configurations"
git push origin build-pipeline


https://docs.microsoft.com/en-us/learn/modules/create-a-build-pipeline/8-build-multiple-configurations












#############################################################################################################################################
#############################################################################################################################################
#############################################################################################################################################

# create a new repository on the command line
echo "# Token_test" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/Hazemwaddah/Token_test.git
git push -u origin main



# push an existing repository from the command line
git remote add origin https://github.com/Hazemwaddah/Token_test.git
git branch -M main
git push -u origin main



# Generate ssh key for Github
ssh-keygen -t ed25519 -C ">[REDACTED-EMAIL]"

# start the ssh-agent in the background
eval "$(ssh-agent -s)"
Agent pid 59566
ssh-add -l -E sha256
ssh-add /c/Users/Hazem/.ssh/id_ed25519
ssh -T git@github.com
ssh -vT git@github.com
SHA256:sUjXg1pkOBlRCcTe01q5NUZeyYU1YxEwc7jajL2l9tU

git push


# Update Git Bash
git update-git-for-windows

# Use Personal access token to access github through APIs: 
curl -u username:token https://api.github.com/user
curl -u Hazemwaddah:[REDACTED] https://api.github.com/user


# Delete a github repo through APIs:
curl \
  -X DELETE \
  -H "Accept: application/vnd.github+json" \ 
  -H "Authorization: token <TOKEN>" \
  https://api.github.com/repos/OWNER/REPO
#
curl -X DELETE https://api.github.com/repos/Hazemwaddah/test -H "Authorization: [REDACTED]" -H "Accept: application/vnd.github+json"
#


# To delete a github repo using Postman:
1- copy the url below after changing the repo name:
https://api.github.com/repos/OWNER/REPO
https://api.github.com/repos/Hazemwaddah/Token_test

2- use API verb:  Delete

3- Go to Authorization tab and enable OAuth 2.0

4- Insert the token with delete permissions

5- response will be: 204 No content


sudo 
/etc/init.d/dns-clean start