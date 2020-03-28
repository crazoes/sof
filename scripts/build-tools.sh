#!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause
# Copyright(c) 2018 Intel Corporation. All rights reserved.

# fail immediately on any errors
set -e

cd tools

rm -rf build_tools

mkdir build_tools
cd build_tools
cmake ..
make -j$(nproc)

DO_BUILD_TEST=false
DO_BUILD_FUZZER=false
while getopts "tf" OPTION; do
        case "$OPTION" in
        t) DO_BUILD_TEST=true ;;
        f) DO_BUILD_FUZZER=true ;;
        *) ;;
        esac
done
shift "$(($OPTIND - 1))"

#build test topologies
if $DO_BUILD_TEST; then
        echo building tests
        make tests -j$(nproc)
fi
#build fuzzer
if $DO_BUILD_FUZZER; then
        echo building fuzzer
        rm -rf build_fuzzer
        mkdir build_fuzzer
        cd build_fuzzer
        cmake ../../fuzzer
        make -j$(nproc)
        cd ../
fi
