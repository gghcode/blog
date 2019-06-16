#!/usr/bin/env bash
if [ -z $GITHUB_TOKEN ]; then 
    echo "Require GITHUB_TOKEN env..."
    exit 1
fi

DEFAULT_REPO_URL=$(git remote get-url origin)
if [ -z $REPO_URL ]; then
    REPO_URL=$DEFAULT_REPO_URL
fi

REPO_HOST=$(echo $REPO_URL |sed 's/https\?:\/\///')

DEFAULT_TARGET_BRANCH=master
if [ -z $TARGET_BRANCH ]; then
    TARGET_BRANCH=$DEFAULT_TARGET_BRANCH
fi

DEFAULT_TARGET_COMMIT=$(git rev-parse HEAD)
if [ -z $TARGET_COMMIT ]; then
    TARGET_COMMIT=$DEFAULT_TARGET_COMMIT
fi

COMMIT_MSG="Deploy blog site, commit ${TARGET_COMMIT}"

DEFAULT_DEPLOY_TEMP_DIR_PATH="deploy"
if [ -z $DEPLOY_TEMP_DIR_PATH ]; then
    DEPLOY_TEMP_DIR_PATH=$DEFAULT_DEPLOY_TEMP_DIR_PATH
fi

DEFAULT_BOT_NAME='bot'
if [ -z $BOT_NAME ]; then
    BOT_NAME=$DEFAULT_BOT_NAME
fi

bash_c='bash -c'

deploy() {
    clean
   
    git clone -b $TARGET_BRANCH $REPO_URL $DEPLOY_TEMP_DIR_PATH &> /dev/null

    ensure_master_branch

    rsync -av --delete --exclude ".git" public/ $DEPLOY_TEMP_DIR_PATH

    $bash_c "cd $DEPLOY_TEMP_DIR_PATH &&
        git config user.email "$BOT_NAME@users.noreply.github.com" &&
        git config user.name $BOT_NAME &&
        git add . &&
        git status &&
        git commit -m '$COMMIT_MSG' &&
        git push -f -q https://$GITHUB_TOKEN@$REPO_HOST $TARGET_BRANCH"
    
    clean
}

ensure_master_branch() {
    cd $DEPLOY_TEMP_DIR_PATH

    git checkout $TARGET_BRANCH &> /dev/null
    if [ $? -eq 1 ]; then
        git checkout -b $TARGET_BRANCH
        git rm -rf *
    fi

    cd ../
}

clean() {
    rm -rf $DEPLOY_TEMP_DIR_PATH
}

deploy