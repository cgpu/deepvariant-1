#!/bin/bash
# Copyright 2018 Google Inc.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# Usage:  ./nucleus/pip_package/build_pip_package.sh
#
# Important:  You must run
#   source install.sh
# before running this script.

set -e

bazel build -c opt $COPT_FLAGS nucleus/...

TMPDIR=$(mktemp -d -t tmp.XXXXXXXXXXX)

RUNFILES=bazel-bin/nucleus/pip_package/build_pip_package.runfiles/nucleus
cp -R "${RUNFILES}/nucleus" "${TMPDIR}"

so_lib_dir=$(ls $RUNFILES | grep solib) || true
if [ -n "${so_lib_dir}" ]; then
  mkdir "${TMPDIR}/${so_lib_dir}"
  cp -R "${RUNFILES}/${so_lib_dir}" "${TMPDIR}"
fi

# redacted
# protobuf_archive.

cp nucleus/pip_package/MANIFEST.in "${TMPDIR}"
cp README.md "${TMPDIR}"
cp nucleus/pip_package/setup.py "${TMPDIR}"

pushd "${TMPDIR}"
rm -f MANIFEST
echo $(date) : "=== Building wheel"
python setup.py bdist_wheel
popd
echo "Output wheel is in ${TMPDIR}/dist"