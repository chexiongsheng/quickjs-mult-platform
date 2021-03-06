cmake_minimum_required(VERSION 3.10)

project(quickjs LANGUAGES C)

if (APPLE AND NOT IOS)
   set(CMAKE_OSX_DEPLOYMENT_TARGET "10.9" CACHE STRING "Minimum OS X deployment version")
endif()

set(qjs_cflags -Wall)
if(CMAKE_C_COMPILER_ID MATCHES "AppleClang|Clang")
    list(APPEND qjs_cflags
            -Wextra
            -Wno-sign-compare
            -Wno-missing-field-initializers
            -Wno-unused-parameter
            -Wno-unused-variable
            -funsigned-char)
else()
    list(APPEND qjs_cflags
            -Wno-array-bounds
            -Wno-unused-variable
            -Wno-unused-but-set-variable)
endif()

file(STRINGS "VERSION" QJS_VERSION_STR)

add_library(quickjs STATIC
        cutils.c
        libbf.c
        libregexp.c
        libunicode.c
        quickjs.c
        )
set_target_properties(quickjs PROPERTIES
        C_STANDARD 11
        C_STANDARD_REQUIRED ON
        )
target_compile_options(quickjs PRIVATE ${qjs_cflags})
target_compile_definitions(quickjs PRIVATE
        CONFIG_BIGNUM
        CONFIG_VERSION="${QJS_VERSION_STR}"
        )
if (CMAKE_BUILD_TYPE MATCHES Debug)
    target_compile_definitions(quickjs PRIVATE
            DUMP_LEAKS
            )
endif()

target_include_directories(quickjs PUBLIC ${CMAKE_SOURCE_DIR})
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    target_link_libraries(quickjs atomic)
endif()
