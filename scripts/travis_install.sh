#! /bin/sh

if [[ "${TRAVIS_OS_NAME}" == "osx" ]]; then
   brew install cmake || brew upgrade cmake
fi

