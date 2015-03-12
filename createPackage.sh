#!/bin/bash

set -e

# Export those variables in your .bashrc to ease the deployment of new packages
#
# export VENDOR_NAME=pragmarx
# export PACKAGE_AUTHOR_NAME=Antonio Carlos Ribeiro
# export PACKAGE_AUTHOR_EMAIL=acr@antoniocarlosribeiro.com
# export PACKAGE_AUTHOR_WEBSITE=https://antoniocarlosribeiro.com
# export PACKAGE_AUTHOR_USERNAME=antonioribeiro
# export PACKAGE_DESCRIPTION=
#
# export SKELETON_VENDOR_NAME=pragmarx
# export SKELETON_VENDOR_NAME_CAPITAL=PragmaRX
# export SKELETON_PACKAGE_NAME=skeleton
# export SKELETON_VENDOR_NAME_CAPITAL=Skeleton
# export SKELETON_PACKAGE_REPOSITORY=https://github.com/antonioribeiro/skeleton.git
# export SKELETON_VCS_USER=antonioribeiro
# export SKELETON_VCS_SERVICE=github.com
# export SKELETON_PACKAGE_BRANCH=league

function main()
{
    clear

    displayAppName

    generateDefaultData

    askForData

    createPackage
}

function generateDefaultData()
{
    if [[ "$SKELETON_VCS_SERVICE" == "" ]]; then
        SKELETON_VCS_SERVICE=github.com
    fi

    if [[ "$SKELETON_VENDOR_NAME" == "" ]]; then
        SKELETON_VENDOR_NAME=:vendor_name
    fi

    if [[ "$SKELETON_VENDOR_NAME_CAPITAL" == "" ]]; then
        SKELETON_VENDOR_NAME_CAPITAL=:VendorName
    fi

    if [[ "$SKELETON_PACKAGE_NAME" == "" ]]; then
        SKELETON_PACKAGE_NAME=:package_name
    fi

    if [[ "$SKELETON_PACKAGE_NAME_CAPITAL" == "" ]]; then
        SKELETON_PACKAGE_NAME_CAPITAL=:PackageName
    fi

    if [[ "$SKELETON_PACKAGE_REPOSITORY" == "" ]]; then
        SKELETON_PACKAGE_REPOSITORY=https://github.com/antonioribeiro/skeleton.git
    fi

    if [[ "$SKELETON_PACKAGE_BRANCH" == "" ]]; then
        SKELETON_PACKAGE_BRANCH=league
    fi
}

function searchAndReplace()
{
    find "$1" -name "*" -exec sed -i "s/$2/$3/g" {} \; &> /dev/null
}

function createPackage()
{
    message Creating package "$VENDOR_NAME/$PACKAGE_NAME"
    message From repository: "$SKELETON_REPOSITORY" branch "$SKELETON_PACKAGE_BRANCH"

    git clone --branch "$SKELETON_PACKAGE_BRANCH" "$SKELETON_REPOSITORY" "$DESTINATION_FOLDER"

    searchAndReplace "$DESTINATION_FOLDER" "$SKELETON_PACKAGE_NAME"             "$PACKAGE_NAME"
    searchAndReplace "$DESTINATION_FOLDER" "$SKELETON_PACKAGE_NAME_CAPITAL"     "$PACKAGE_NAME_CAPITAL"
    searchAndReplace "$DESTINATION_FOLDER" "$SKELETON_VENDOR_NAME"              "$VENDOR_NAME"
    searchAndReplace "$DESTINATION_FOLDER" "$SKELETON_VENDOR_NAME_CAPITAL"      "$VENDOR_NAME_CAPITAL"
    searchAndReplace "$DESTINATION_FOLDER" "$SKELETON_AUTHOR_NAME"              "$PACKAGE_AUTHOR_NAME"
    searchAndReplace "$DESTINATION_FOLDER" "$SKELETON_AUTHOR_EMAIL"             "$PACKAGE_AUTHOR_EMAIL"
    searchAndReplace "$DESTINATION_FOLDER" "$SKELETON_AUTHOR_WEBSITE"           "$PACKAGE_AUTHOR_WEBSITE"
    searchAndReplace "$DESTINATION_FOLDER" "$SKELETON_AUTHOR_USERNAME"          "$PACKAGE_AUTHOR_USERNAME"
    searchAndReplace "$DESTINATION_FOLDER" "$SKELETON_DESCRIPTION"              "$PACKAGE_DESCRIPTION"

    renameAll "$DESTINATION_FOLDER" "$SKELETON_PACKAGE_NAME"                    "$PACKAGE_NAME"
    renameAll "$DESTINATION_FOLDER" "$SKELETON_PACKAGE_NAME_CAPITAL"            "$PACKAGE_NAME_CAPITAL"
    renameAll "$DESTINATION_FOLDER" "$SKELETON_VENDOR_NAME"                     "$VENDOR_NAME"
    renameAll "$DESTINATION_FOLDER" "$SKELETON_VENDOR_NAME_CAPITAL"             "$VENDOR_NAME_CAPITAL"

    mv "$DESTINATION_FOLDER/src/PackageNameClass.php" "$DESTINATION_FOLDER/src/$PACKAGE_NAME_CAPITAL.php"
    mv "$DESTINATION_FOLDER/src/PackageNameServiceProvider.php" "$DESTINATION_FOLDER/src/${PACKAGE_NAME_CAPITAL}ServiceProvider.php"
    rm -rf "$DESTINATION_FOLDER/.git/"

    cd "$DESTINATION_FOLDER"

    git init
    git add -A
    git commit -m "first commit"

    if [[ "$PACKAGE_REPOSITORY" != "" ]]; then
        git remote add origin "$PACKAGE_REPOSITORY"

        git push origin master

        displayInstructions
    fi
}

function askForData()
{
    DESTINATION_FOLDER=$(pwd)/
    inquireText "Package destination folder:" "$DESTINATION_FOLDER"
    DESTINATION_FOLDER=$answer

    if [[ -d "$DESTINATION_FOLDER" ]]; then
        message
        message "Destination folder already exists. Aborting..."
        message
        exit 1
    fi

    message

    VENDOR_NAME=$(echo "$VENDOR_NAME" | awk '{print tolower($0)}')
    inquireText "Vendor name for your new package (lowercase):" "$VENDOR_NAME"
    VENDOR_NAME=$answer

    VENDOR_NAME_CAPITAL=${VENDOR_NAME^}
    inquireText "Vendor name for your new package (Capitalized):" "$VENDOR_NAME_CAPITAL"
    VENDOR_NAME_CAPITAL=$answer

    message

    if [[ "$SKELETON_VCS_USER" != "" ]]; then
        VCS_USER=$SKELETON_VCS_USER
    else
        VCS_USER=$VENDOR_NAME
    fi

    inquireText "Your VCS username:" "$VCS_USER"
    VCS_USER=$answer

    message

    PACKAGE_NAME=$(echo "$(basename "$DESTINATION_FOLDER")" | awk '{print tolower($0)}')
    inquireText "Your new package name (lowercase):" "$PACKAGE_NAME"
    PACKAGE_NAME=$answer

    PACKAGE_NAME_CAPITAL=${PACKAGE_NAME^}
    inquireText "Your new package name (Capitalized):" "$PACKAGE_NAME_CAPITAL"
    PACKAGE_NAME_CAPITAL=$answer

    if [[ "$PACKAGE_AUTHOR_NAME" == "" ]]; then
        PACKAGE_AUTHOR_NAME=$VENDOR_NAME_CAPITAL
    fi
    inquireText "Author name:" "$VENDOR_NAME_CAPITAL"
    PACKAGE_AUTHOR_NAME=$answer

    inquireText "Author email:" "$PACKAGE_AUTHOR_EMAIL"
    PACKAGE_AUTHOR_EMAIL=$answer

    inquireText "Author website:" "$PACKAGE_AUTHOR_WEBSITE"
    PACKAGE_AUTHOR_WEBSITE=$answer

    inquireText "Author username:" "$VCS_USER"
    PACKAGE_AUTHOR_USERNAME=$answer

    inquireText "Description:" "$PACKAGE_DESCRIPTION"
    PACKAGE_DESCRIPTION=$answer

    PACKAGE_REPOSITORY=https://$SKELETON_VCS_SERVICE/$VCS_USER/$PACKAGE_NAME.git
    inquireText "Your new package repository link (create a package first or leave it blank):" "$PACKAGE_REPOSITORY"
    PACKAGE_REPOSITORY=$answer

    message
    message --- Skeleton replacements
    message

    SKELETON_VENDOR_NAME=$(echo "$SKELETON_VENDOR_NAME" | awk '{print tolower($0)}')
    inquireText "Skeleton Vendor name (lowercase):" "$SKELETON_VENDOR_NAME"
    SKELETON_VENDOR_NAME=$answer

    if [[ "$SKELETON_VENDOR_NAME" != ":vendor_name" ]]; then
        SKELETON_VENDOR_NAME_CAPITAL=$SKELETON_VENDOR_NAME
    fi

    SKELETON_VENDOR_NAME_CAPITAL=${SKELETON_VENDOR_NAME_CAPITAL^}
    inquireText "Skeleton Vendor name (Capitalized):" "$SKELETON_VENDOR_NAME_CAPITAL"
    SKELETON_VENDOR_NAME_CAPITAL=$answer

    message 

    SKELETON_PACKAGE_NAME=$(echo "$(basename "$SKELETON_PACKAGE_NAME")" | awk '{print tolower($0)}')
    inquireText "Skeleton package name (lowercase):" "$SKELETON_PACKAGE_NAME"
    SKELETON_PACKAGE_NAME=$answer

    if [[ "$SKELETON_PACKAGE_NAME_CAPITAL" != ":PackageName" ]]; then
        SKELETON_PACKAGE_NAME_CAPITAL=$SKELETON_PACKAGE_NAME
    fi

    SKELETON_PACKAGE_NAME_CAPITAL=${SKELETON_PACKAGE_NAME_CAPITAL^}
    inquireText "Skeleton package name (Capitalized):" "$SKELETON_PACKAGE_NAME_CAPITAL"
    SKELETON_PACKAGE_NAME_CAPITAL=$answer

    inquireText "Skeleton author name:" :author_name
    SKELETON_AUTHOR_NAME=$answer

    inquireText "Skeleton author email:" :author_email
    SKELETON_AUTHOR_EMAIL=$answer

    inquireText "Skeleton author website:" :author_website
    SKELETON_AUTHOR_WEBSITE=$answer

    inquireText "Skeleton author username:" :author_username
    SKELETON_AUTHOR_USERNAME=$answer

    inquireText "Skeleton package description:" :package_description
    SKELETON_DESCRIPTION=$answer

    if [[ "$SKELETON_PACKAGE_NAME_CAPITAL" == ":PackageName" ]]; then
        selectSkeletonRepository

        SKELETON_REPOSITORY=$repository
        SKELETON_PACKAGE_BRANCH=$branch
    else
        SKELETON_REPOSITORY=https://$SKELETON_VCS_SERVICE/$SKELETON_VENDOR_NAME/$SKELETON_PACKAGE_NAME.git
    fi

    if [[ "$repository" == "" ]]; then
        repo="$SKELETON_VENDOR_NAME/skeleton.git"
        if [[ "$SKELETON_VENDOR_NAME" == ":vendor_name" ]]; then
            repo=
        fi

        SKELETON_REPOSITORY=https://$SKELETON_VCS_SERVICE/$repo
        inquireText "Skeleton repository link:" "$SKELETON_REPOSITORY"
        SKELETON_REPOSITORY=$answer

        inquireText "Skeleton branch:" master
        SKELETON_PACKAGE_BRANCH=$answer
    fi
}

function selectSkeletonRepository()
{
    repository=https://github.com/antonioribeiro/skeleton.git

    PS3='Please enter your choice: '
    options=("League" "Laravel 5" "Laravel 4" "PragmRX" "Use your own skeleton")
    select opt in "${options[@]}"
    do
        case $opt in
            "League")
                branch=league
                break
                ;;
            "Laravel 5")
                branch=laravel5
                break
                ;;
            "Laravel 4")
                branch=laravel4
                break
                ;;
            "PragmaRX")
                branch=pragmarx
                break
                ;;
            "Use your own skeleton")
                repository=
                branch=
                break
                ;;
            *) echo invalid option;;
        esac
    done
}

function renameAll()
{
    renameFiles "$1" "$2" "$3"

    renameDirectories "$1" "$2" "$3"
}

function renameFiles()
{
    FOLDER=$1
    OLD=$2
    NEW=$3

    find "$FOLDER" -type f -print0 | while IFS= read -r -d $'\0' file; do
        dir=$(dirname "$file")
        filename=$(basename "$file")
        new=$dir/$(echo "$filename" | sed -e "s/$OLD/$NEW/g")

        if [[ "$file" != "$new" ]]; then
            if [[ -f $file ]]; then
                mv "$file" "$new"
            fi
        fi
    done    
}

function renameDirectories()
{
    FOLDER=$1
    OLD=$2
    NEW=$3

    find "$FOLDER" -type d -print0 | while IFS= read -r -d $'\0' file; do
        new=$(echo "$file" | sed -e "s/$OLD/$NEW/g")

        if [[ "$file" != "$new" ]]; then
            if [[ -d $file ]]; then
                mv "$file" "$new"
            fi
        fi
    done    
}

function inquireText()
{
    answer=""
    value=$2
    
    if [[ "$value" == "Pragmarx" ]]; then
        value=PragmaRX
    fi

    if [[ ${BASH_VERSION} > "3.9" ]]; then
        read -e -p "$1 " -i "$value" answer
    else
        read -e -p "$1 [hit enter for $value] " answer
    fi
}

function displayInstructions()
{
    echo
    echo Congratulations, your new package has been created!
    echo
    echo ------------------------------------------------------------------------------------------------
    echo  How to use it
    echo ------------------------------------------------------------------------------------------------
    echo
    echo "Add the items below to your composer.json:"
    echo 
    echo "\"require\": {"
    echo "    \"$VENDOR_NAME/$PACKAGE_NAME\": \"dev-master\","
    echo "},"
    echo 
    echo 
    echo "and"
    echo 
    echo 
    echo "\"repositories\": ["
    echo "    {"
    echo "        \"type\": \"vcs\","
    echo "        \"url\":  \"$PACKAGE_REPOSITORY\""
    echo "    },"
    echo "],"
    echo
    echo 
    echo "If this is a Laravel project, don't forget to add a ServiceProvider in your app/config/app.php too, something like:"
    echo 
    echo "    '$VENDOR_NAME_CAPITAL\\$PACKAGE_NAME_CAPITAL\\ServiceProvider'",
    echo 
    echo 
}

function message()
{
    if [[ "$1" != "" ]]; then
        command="echo $@"
        ${command}
    else
        echo
    fi
}

function displayAppName()
{
    echo "## createPackage"
    echo
    echo
}

main "$@"
