
# SPDX-License-Identifier: CC0-1.0

cmake_minimum_required(VERSION 3.16)

set(CMAKE_C_COMPILER "riscv32-esp-elf-gcc")
set(CMAKE_CXX_COMPILER "riscv32-esp-elf-g++")

add_compile_options(
    -mno-relax
)
add_link_options(
    # -wrapper ${CMAKE_CURRENT_LIST_DIR}/echowrapper
    -nostartfiles
    -nodefaultlibs
    -L${CMAKE_CURRENT_LIST_DIR}/badgesdk/
    -Tlinker.ld
)

project(why2025-app)

add_executable(main.elf
    src/main.c
)
target_include_directories(main.elf PUBLIC
    include
)
