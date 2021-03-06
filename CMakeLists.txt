cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
# 3.8* is required because of C++17 support

set(CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

project (travistest)

if(NOT WIN32)
    option(INSIGHTS_STATIC     "Use static linking"        Off)
endif()

set(INSIGHTS_LLVM_CONFIG "llvm-config" CACHE STRING "LLVM config executable to use")


if(NOT LLVM_CONFIG_PATH)
    set(INSIGHTS_LLVM_CONFIG "llvm-config")
    message(STATUS "1INSIGHTS=|${INSIGHTS_LLVM_CONFIG}|")
endif()

    message(STATUS "PATH=$ENV{PATH}")
    message(STATUS "INSIGHTS=|${INSIGHTS_LLVM_CONFIG}|")
    find_program(LLVM_CONFIG_PATH "${INSIGHTS_LLVM_CONFIG}")    
    if(NOT LLVM_CONFIG_PATH)
        message(FATAL_ERROR "llvm-config not found -- ${LLVM_CONFIG_PATH}: ${INSIGHTS_LLVM_CONFIG}")
    else()
        message(STATUS "Found LLVM_CONFIG_PATH: ${LLVM_CONFIG_PATH}")
    endif()    

    if(INSIGHTS_STATIC)
        if(APPLE)
            message(STATUS "Static linking may not be possible on OSX")
        else()
            set(LIB_TYPE "--link-static")
        endif()

        if(WIN32)
            add_definitions(/MT)
        else()
            set(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} -static")
        endif()
    endif()
    
    function(llvm_config VARNAME switch)
        set(CONFIG_COMMAND "${LLVM_CONFIG_PATH}" "${switch}")
        
        execute_process(
            COMMAND ${CONFIG_COMMAND} ${LIB_TYPE}
            RESULT_VARIABLE HAD_ERROR
            OUTPUT_VARIABLE CONFIG_OUTPUT
        )
        
        if (HAD_ERROR)
            string(REPLACE ";" " " CONFIG_COMMAND_STR "${CONFIG_COMMAND}")
            message(STATUS "${CONFIG_COMMAND_STR}")
            message(FATAL_ERROR "llvm-config failed with status ${HAD_ERROR}")
        endif()
        
        # replace linebreaks with semicolon
        string(REGEX REPLACE
            "[ \t]*[\r\n]+[ \t]*" ";"
            CONFIG_OUTPUT ${CONFIG_OUTPUT})

        # make all includes system include to prevent the compiler to warn about issues in LLVM/Clang
        string(REGEX REPLACE "-I" "-isystem" CONFIG_OUTPUT "${CONFIG_OUTPUT}")

        #        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        #            string(REGEX REPLACE "-Wl,--no-keep-files-mapped" "" CONFIG_OUTPUT "${CONFIG_OUTPUT}")
        #            string(REGEX REPLACE "-Wl,--no-map-whole-files" "" CONFIG_OUTPUT "${CONFIG_OUTPUT}")
        #            string(REGEX REPLACE "-fuse-ld=gold" "" CONFIG_OUTPUT "${CONFIG_OUTPUT}")
        #        endif()

        # Since Clang 10 of ziglang C++14 is set
        string(REGEX REPLACE "-std[:=]+c\\+\\+[0-9][0-9]" "" CONFIG_OUTPUT "${CONFIG_OUTPUT}")
        
        # make result available outside
        set(${VARNAME} ${CONFIG_OUTPUT} PARENT_SCOPE)
        
        # Optionally output the configured value
        message(STATUS "llvm_config(${VARNAME})=>${CONFIG_OUTPUT}")
        
        # cleanup
        unset(CONFIG_COMMAND)
    endfunction(llvm_config)
    
    llvm_config(LLVM_CXXFLAGS "--cxxflags")
    llvm_config(LLVM_LDFLAGS "--ldflags")
    llvm_config(LLVM_LIBS "--libs")
    llvm_config(LLVM_LIBDIR "--libdir")
    llvm_config(LLVM_INCLUDE_DIR "--includedir")
    llvm_config(LLVM_SYSTEM_LIBS "--system-libs")
    llvm_config(LLVM_PACKAGE_VERSION "--version")
    


link_directories(${LLVM_LIBDIR})

add_executable(travistest main.cpp)

target_link_libraries(travistest
  PRIVATE
  clangTooling
  clangASTMatchers
  ${ADDITIONAL_LIBS}
)

    set(ADDITIONAL_LIBS         
        ${LLVM_LDFLAGS}
        clangFrontend
        clangDriver
        clangSerialization
        clangParse
        clangSema
        clangAnalysis
        clangEdit
        clangAST
        clangLex
        clangBasic
        clangRewrite
        ${LLVM_LIBS}
        ${LLVM_SYSTEM_LIBS}
    )

message(STATUS "CMAKE_BINARY_DIR      : ${CMAKE_BINARY_DIR}")

