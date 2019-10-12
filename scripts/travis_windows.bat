set PATH=${TRAVIS_BUILD_DIR}\clang-windows\llvm+clang-8.0.0-win64-msvc-release\bin;%PATH%
echo PATH %PATH%

clang++ --version
${TRAVIS_BUILD_DIR}/clang-windows/llvm+clang-8.0.0-win64-msvc-release/bin/clang++ --version

cmake -G "Visual Studio 15 2017 Win64" -T LLVM -DINSIGHTS_STATIC=Yes -DINSIGHTS_LLVM_CONFIG=${TRAVIS_BUILD_DIR}\clang-windows\llvm+clang-8.0.0-win64-msvc-release\bin\llvm-config ..
