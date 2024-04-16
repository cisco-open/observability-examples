#!/usr/bin/env bash
# Copyright 2024 Cisco Systems, Inc. and its affiliates
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0


# Check if jq is installed
jq_path=$(which jq)

if [ -z "$jq_path" ]; then
  echo "jq is not found in your PATH. Please make sure it's installed and in your PATH."
  exit 1
fi

# Get the location of the fsoc binary
fsoc_path=$(which fsoc)

if [ -z "$fsoc_path" ]; then
  echo "fsoc is not found in your PATH. Please make sure it's installed and in your PATH."
  exit 1
fi

# Get the fsoc version
fsoc_version=$(fsoc version 2>&1 | awk '{print $3}')

# Check if the version is at least 0.68.0
if [[ "$fsoc_version" < "0.68.0" ]]; then
  echo "fsoc version $fsoc_version is not supported. Please install version 0.68.0 or higher."
  exit 1
fi

echo "jq path: $jq_path"
echo "fsoc binary path: $fsoc_path"
echo "fsoc version: $fsoc_version"
echo "all required utilities are present"
