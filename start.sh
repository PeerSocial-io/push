#!/bin/sh
set -e

timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

INPUT_AUTHOR_EMAIL=${INPUT_AUTHOR_EMAIL:-'github-actions[bot]@users.noreply.github.com'}
INPUT_AUTHOR_NAME=${INPUT_AUTHOR_NAME:-'github-actions[bot]'}
INPUT_COAUTHOR_EMAIL=${INPUT_COAUTHOR_EMAIL:-''}
INPUT_COAUTHOR_NAME=${INPUT_COAUTHOR_NAME:-''}
INPUT_MESSAGE=${INPUT_MESSAGE:-"chore: autopublish ${timestamp}"}
INPUT_BRANCH=${INPUT_BRANCH:-master}
INPUT_FORCE=${INPUT_FORCE:-false}
INPUT_TAGS=${INPUT_TAGS:-false}
INPUT_EMPTY=${INPUT_EMPTY:-false}
INPUT_DIRECTORY=${INPUT_DIRECTORY:-'.'}
REPOSITORY=${INPUT_REPOSITORY:-$GITHUB_REPOSITORY}

echo "Push to branch $INPUT_BRANCH";
[ -z "${INPUT_GITHUB_TOKEN}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};

if ${INPUT_FORCE}; then
    _FORCE_OPTION='--force'
fi


cd "${INPUT_DIRECTORY}"

remote_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${REPOSITORY}.git"

git config http.sslVerify false
# git config --local user.email "${INPUT_AUTHOR_EMAIL}"
# git config --local user.name "${INPUT_AUTHOR_NAME}"


git checkout -b "${INPUT_BRANCH}"
git push "${remote_repo}" HEAD:"${INPUT_BRANCH}" $_FORCE_OPTION
# git push "${remote_repo}" HEAD:"${INPUT_BRANCH}" --follow-tags $_FORCE_OPTION $_TAGS;
