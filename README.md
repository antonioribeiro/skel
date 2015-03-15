# Skel
### A PHP Package Creator & Skeletons

Skel is a Bash script to create [Composer](https://getcomposer.org/doc/01-basic-usage.md) PHP packages based on [skeletons](https://github.com/antonioribeiro/skel#skeletons). 

### Why?

Laravel 4 Workbench is great, but, in my first steps with it I found easier to develop a package right from my vendor folder, where the package will really be after I install it using Composer. Also because my new packages needed some more preparing than just setting up files in folders, I needed more information in my composer.json, my package stub had more files than the ones Laravel provided, like readme.md, changelog.md and travis.yml, I also had more info in composer.json, so there was a lot of boilerplate to be added before I go my package really ready to go, things I could avoid using my own skeleton (stub).
   
This script does all this for you, allowing you to use a skeleton repository to create the package and even upload a first draft of it to Github (or any other VCS service). 
 
### How it Works

Skel is very simple, when running it will 

1. Ask for some information (destination, vendor, package, vcs username, skeleton to be used...). 
2. Clone a skeleton repository of your choice. 
3. Replace everything related to the package with the information provided.
4. Push the new package to your VCS (Github, Bitbucket...).
5. Give you instructions on how to add the new package to your application.

### You Don't Need to Add Your Package to Packagist

Skel will automatically push your new package to a VCS repository (Github, Bitbucket...), but you don't need to add it publicly to Packagist. You can require your new package on your composer.json:  

``` json
"require": {
    "yourVendorName/yourPackageName": "dev-master",
},
```

And [reference your VCS in the repositories](https://getcomposer.org/doc/05-repositories.md#loading-a-package-from-a-vcs-repository) object:  

``` json
"repositories": [
    {
        "type": "vcs",
        "url":  "https://github.com/yourUsername/yourPackageName.git"
    },
],
```

Then you just have to tell [Composer](https://getcomposer.org/doc/01-basic-usage.md) to install by cloning it, allowing you to develop your package right from your app vendor folder:

You can read more about this 
``` bash
composer install --prefer-source
```

And it's done! 

#### Running Skel remotely from Github

``` bash
bash <(curl -s https://raw.githubusercontent.com/antonioribeiro/skel/v0.1.0/skel.sh)
```

#### Installing the script on your system

``` bash
DESTINATION=/usr/local/bin/skel
sudo wget https://raw.githubusercontent.com/antonioribeiro/skel/v0.1.0/skel.sh -v -O $DESTINATION
sudo chmod +x $DESTINATION 
```

Then you just have to run it

``` bash
skel 
```

#### Skeletons

During creation of a package the script may ask for a skeleton to install, the currently available are:

* [League](https://github.com/antonioribeiro/skel/tree/league)
* [Laravel 5](https://github.com/antonioribeiro/skel/tree/laravel5)
* [Laravel 4](https://github.com/antonioribeiro/skel/tree/laravel4)
* Your own skeleton

#### [The League of Extraordinary Packages](http://thephpleague.com/)

All skeletons on this repository are using [ThePhpLeague/Skeleton](https://github.com/thephpleague/skeleton) a base, and every commit to League's repository will be merged to Skel, but there are some differences:
  
* Replacement strings (:package_name, :vendor_name, etc.) were unified
* Framework specific files, for instance the Service Provider, included in Laravel 4 and 5 skeletons.

#### Going Faster

You can export some variables so you don't have to type too much while creating your packages, you just have to add those lines to your .bashrc and fill them properly: 
 
``` bash
export VENDOR_NAME=pragmarx
export PACKAGE_AUTHOR_NAME=Antonio Carlos Ribeiro
export PACKAGE_AUTHOR_EMAIL=acr@antoniocarlosribeiro.com
export PACKAGE_AUTHOR_WEBSITE=https://antoniocarlosribeiro.com
export PACKAGE_AUTHOR_USERNAME=antonioribeiro
export PACKAGE_DESCRIPTION=PragmaRX Package for...
export SKELETON_VENDOR_NAME=pragmarx
export SKELETON_VENDOR_NAME_CAPITAL=PragmaRX
export SKELETON_PACKAGE_NAME=skeleton
export SKELETON_VENDOR_NAME_CAPITAL=Skeleton
export SKELETON_PACKAGE_REPOSITORY=https://github.com/antonioribeiro/skel.git
export SKELETON_VCS_USER=antonioribeiro
export SKELETON_VCS_SERVICE=github.com
export SKELETON_PACKAGE_BRANCH=league
```
