# Skel
### A PHP Package Creator & Skeleton

Skel is a Bash script to create Composer PHP packages based on skeletons. 

### How it Works

Skel is very simple, when running it will 

1. Ask for some information (destination, vendor, package, vcs username, skeleton to be used...). 
2. Clone a skeleton repositoy. 
3. Replace everything related to the package with the information provided.
4. Push the new package to your VCS (Github, Bitbucket...).
5. Give you instructions on how to add the new package to your application.

### You Don't Need to Add Your Package to Packagist

Skel will automatically push your new package to a VCS repository (Github, Bitbucket...), but you don't need to add it publicly to Packagist. You can require your new package on your composer.json:  

``` json
"require": {
    "yourVendorName/yourNewPackage": "dev-master",
},
```

And reference your VCS in the repositories object:  

``` json
"repositories": [
    {
        "type": "vcs",
        "url":  "https://github.com/yourUsername/yourPackageName.git"
    },
],
```

Then you just have to tell Composer to install it:
  
  
``` bash
composer install --prefer-source
```

And it's done! Your can now develop your package right from your application vendor folder. 

#### Running Skel remotely from Github

``` bash
bash <(curl -s https://raw.githubusercontent.com/antonioribeiro/skel/v0.1.0/skel.sh)
```

#### Installing the script on your system

``` bash
DESTINATION=/usr/local/bin/skel.sh
sudo wget https://raw.githubusercontent.com/antonioribeiro/skel/v0.1.0/skel.sh -v -O $DESTINATION
sudo chmod +x $DESTINATION 
```

#### Skeletons

During creation of a package the script may ask for a skeleton to install, the currently available are:

* [League](https://github.com/antonioribeiro/skel/tree/league)
* [Laravel 5](https://github.com/antonioribeiro/skel/tree/laravel5)
* [Laravel 4](https://github.com/antonioribeiro/skel/tree/laravel4)
* Your own skeleton

#### Skeleton Base

All skeletons on this repository are currently using as a base [ThePhpLeague/Skeleton](https://github.com/thephpleague/skeleton), all packages are based on League's and every commit should be merged to ours. The differences between League's and this respository are:
  
* Replacement strings (:package_name, :vendor_name, etc.)
* Framework specific repositories, for instance Laravel Service Providers, included in Laravel skeletons.
