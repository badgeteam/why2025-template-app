
# SPDX-License-Identifier: CC0-1.0
# Copyright © 2024, Badge.team

cmake_minimum_required(VERSION 3.16)

set(CMAKE_C_COMPILER "riscv32-esp-elf-gcc")
set(CMAKE_CXX_COMPILER "riscv32-esp-elf-g++")
set(CMAKE_EXPORT_COMPILE_COMMANDS true)

include(badgesdk/CMakeLists.txt)

project(why2025-app)

add_executable(main.elf
    src/main.c
)
target_include_directories(main.elf PUBLIC
    badgesdk/include
    include
)
set_target_properties(main.elf PROPERTIES LINK_DEPENDS
    ${badge_library_path}/${badge_linkerscript}
)
