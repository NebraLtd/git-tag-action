#!/bin/bash

# input validation
if [[ -z "${TAG}" ]]; then
   echo "No tag name supplied"
   exit 1
fi

if [[ -z "${GITHUB_TOKEN}" ]]; then
   echo "No github token supplied"
   exit 1
fi

if [[ -z "${COMMIT_SHA}" ]]; then
   COMMIT_SHA=$GITHUB_SHA
   echo "Using workflow trigger SHA: $COMMIT_SHA."
   sleep 1
else
   echo "Using supplied SHA: $COMMIT_SHA."
   sleep 1
fi

# get GitHub API endpoints prefix
git_refs_url=$(jq .repository.git_refs_url $GITHUB_EVENT_PATH | tr -d '"' | sed 's/{\/sha}//g')
echo "GitHub API URL: $git_refs_url"
sleep 1

# check if tag already exists in the cloned repo
tag_exists="false"
if [ $(git tag -l "$TAG") ]; then
    tag_exists="true"
    echo "Tag $TAG already exists."
    sleep 1
else
  # check if tag exists in the remote repo
  getReferenceStatus=$(curl "$git_refs_url/tags/$TAG" \
  -H "Authorization: token $GITHUB_TOKEN" \
  --write-out "%{http_code}" -s -o /dev/null)

  if [ "$getReferenceStatus" = '200' ]; then
    tag_exists="true"
    echo "Tag $TAG already exists."
    sleep 1
  else
    echo "Tag $TAG does not exist."
    sleep 1
  fi
fi

if $tag_exists
then
  echo "**updating existing tag $TAG and pushing to repo $GITHUB_REPOSITORY."
  sleep 1
  # update tag
  curl -X PATCH "$git_refs_url/tags/$TAG" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d @- << EOF

  {
    "sha": "$COMMIT_SHA",
    "force": true
  }
EOF
else
  echo "**pushing new tag $TAG to repo $GITHUB_REPOSITORY."
  sleep 1
  # create new tag
  curl -X POST "$git_refs_url" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d @- << EOF

  {
    "ref": "refs/tags/$TAG",
    "sha": "$COMMIT_SHA"
  }
EOF
fi

sleep 1
echo "Tagging complete... $TAG has been successfully pushed!"
