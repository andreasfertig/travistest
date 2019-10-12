cd ${TRAVIS_BUILD_DIR}

if not exist C:\llvm-bin\downloaded ( 
            mkdir llvm-bin &&
            cd llvm-bin &&
            (powershell Start-FileDownload "https://github.com/andreasfertig/cppinsights-compiler-binaries/releases/download/8.0.0/llvm+clang-8.0.0-win64-msvc-release.tar.xz" -FileName llvm.tar.xz) &&
            7z x llvm-bin\llvm.tar.xz &&
            7z x llvm-bin\llvm.tar &&
            del llvm.tar &&
            echo "downloaded" > downloaded )
set PATH=%PATH%;${TRAVIS_BUILD_DIR}\llvm-bin\llvm+clang-8.0.0-win64-msvc-release\bin
echo PATH %PATH%
cd ${TRAVIS_BUILD_DIR}
md ciuploadtool
cd ciuploadtool
curl -fsSL https://github.com/d1vanov/ciuploadtool/releases/download/continuous-master/ciuploadtool_windows_x86.zip -o ciuploadtool_windows_x86.zip
7z x ciuploadtool_windows_x86.zip
