#!/usr/bin/env sh
# This is a post-build script used by Travis to push the compiled project to GitHub

echo "Starting post build, pull request status is '$TRAVIS_PULL_REQUEST'.\n"

if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
  echo "Starting to update gh-pages\n"

  #copy data we're interested in to other place
  cp -R wordpress $HOME/wordpress

  #go to home and setup git
  cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis"

  #using token clone gh-pages branch
  git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/ajessup/appengine-php-wordpress-starter-project.git gh-pages > /dev/null

  #go into diractory and copy data we're interested in to that directory
  cd gh-pages
  cp -Rf $HOME/wordpress/* $TRAVIS_BUILD_NUMBER
  cp -Rf $HOME/wordpress/* latest

  #add, commit and push files
  git add -f .
  git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to gh-pages"
  git push -fq origin gh-pages > /dev/null
fi

echo "Post-build completed\n"