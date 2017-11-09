#!/usr/bin/env bash

# Based on bootstrap.sh by Jess Hamrick, retrieved on 11/09/2017:
# https://github.com/jhamrick/emacs/blob/master/bootstrap.sh

# Based on bootstrap.sh by Mathias Bynens, retrieved 04/28/2013:
# https://github.com/mathiasbynens/dotfiles/blob/5d1850e041f955c48f5a2241faabddd7af895b58/bootstrap.sh

# Install pre-requisites specified in the ReadMe
sudo apt-get install curl mercurial git bzr cvs automake texlive-full python python-pip python-dev build-essential
sudo pip install --upgrade pip
sudo pip install --upgrade virtualenv

# Install python pre-requisites specified in the ReadMe
pip install jedi epc pylint

# Install docker components
# https://docs.docker.com/engine/installation/linux/docker-ce/debian/#set-up-the-repository
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add - 
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo $ID) $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce

# Install Docker Compose
# https://docs.docker.com/compose/install/#install-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install AWS CLI
# http://docs.aws.amazon.com/cli/latest/userguide/installing.html
pip install awscli --upgrade --user



cd "$(dirname "${BASH_SOURCE}")"
git pull origin master

gitExitCode=$?
if [[ $gitExitCode != 0 ]]; then
    exit $gitExitCode
fi

function clean() {
        git clean -nx
	read -p "Clean the above files? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		git clean -fx
	fi
}

function doIt() {
    for i in $(ls -a); do 
	if [ $i != '.' -a $i != '..' -a $i != '.git' -a $i != '.DS_Store' -a $i != 'bootstrap.sh' -a $i != 'README.md' -a $i != '.gitignore' -a $i != '.gitmodules' ]; then 
            if [ $(uname) == "Darwin" ]; then
	        echo "$i"
	        gcp -alrf "$i" "$HOME/"
            else
                echo "$i"
                cp -alrf "$i" "$HOME/"
            fi
	fi
    done
}

clean
if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt
	fi
fi
unset clean
unset doIt












