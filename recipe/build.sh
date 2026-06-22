#!/bin/bash -e
# cetmodules_CONFIG_OUTPUT_ROOT_DIR: in 3.24.01 the generated cetmodulesConfig.cmake
# defaults under the (arch-dependent) library dir -> lib/cetmodules/cmake. cetmodules
# 4.x defaults it to the arch-independent data dir -> share/cetmodules/cmake. Set it
# explicitly here so this noarch package matches the 4.x layout.
cmake -S ${SRC_DIR} -B build -G Ninja \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_INSTALL_LIBEXECDIR=libexec/cetmodules \
    -Dcetmodules_CONFIG_OUTPUT_ROOT_DIR=share \
    -Dcetmodules_ETC_DIR=share/cetmodules/etc \
    -Dcetmodules_TOOLS_DIR=share/cetmodules/tools \
    -DBUILD_TESTING=OFF
cmake --build build --parallel ${CPU_COUNT} --target install

# Replace upstream symlinks with copies so the noarch package installs
# cleanly on Windows. The targets are tiny .cmake stubs.
for link in "${PREFIX}"/share/cetmodules/Modules/FindFFTW3?.cmake; do
    [ -L "${link}" ] || continue
    cp -L "${link}" "${link}.real"
    mv -f "${link}.real" "${link}"
done
