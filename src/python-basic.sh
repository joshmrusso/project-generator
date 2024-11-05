#!/bin/bash

echo "Creating Basic Python Project"
echo "Please enter the name of the project you're creating"
read project_name
echo "Where would you like to place your project?"
read project_folder
echo "What license is your project (mit/gpl-3.0/etc)?"
read license_name

base_path=$project_folder/$project_name

# create the base path for the project
mkdir $base_path

# create all subdirectories for the project
base_folders=(src tests tests/unit docs)
for i in ${!base_folders[@]}; do
  mkdir $base_path/${base_folders[$i]}
done

# create a main.py for the coding start
cat <<EOF >$base_path/src/main.py
def main():
    print("Hello, World!")

if __name__=="__main__":
    main()
EOF

# create a .gitignore for the project
curl -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/gitignore/templates/Python | jq -r '.source' > $base_path/.gitignore

# grab license text
curl -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/licenses/$license_name | jq -r '.body' > $base_path/LICENSE
# sed "s/\[year\]/$(date +%Y)/g" $base_path/LICENSE

# start a virtual environment for the project
cd $base_path && pipenv --python 3.13 && pipenv install -d pytest