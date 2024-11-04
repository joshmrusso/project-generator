#!/bin/bash

echo "Creating Basic Python Project"
echo "Please enter the name of the project you're creating"
read project_name

base_path=./test_builds/$project_name

mkdir $base_path
mkdir $base_path/src
cat <<EOF >$base_path/src/main.py
def main():
    print("Hello, World!")

if __name__=="__main__":
    main()
EOF

curl -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/gitignore/templates/Python | jq -r '.source' > $base_path/.gitignore

cd $base_path && pipenv --python 3.13 && pipenv install -d pytest