# chocolatey commands


# Install a custom version
choco install zap --version=2.12.0



# List installed packages
choco list --localonly

# Uninstall a package
choco uninstall visualstudio2019buildtools 16.11.15.0


# Install in a non-default directory:  Licensed edition
choco install virtualbox --install-directory 'E:\Virtualbox'

# Install in a non-default directory:  free edition
choco install virtualbox -ia "INSTALLDIR=""E:\Virtualbox"



choco uninstall virtualbox -ia "INSTALLDIR=""E:\Virtualbox"



