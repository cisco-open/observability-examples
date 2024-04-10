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


# Get the username of the current user using `whoami`
username=$(whoami)

# Truncate SOLUTION_PREFIX to 11 characters (if it's longer) so that when combined with "awscreds" length is <= 25 chars
SOLUTION_PREFIX="${username:0:12}"

# Set the SOLUTION_PREFIX environment variable
export SOLUTION_PREFIX="$SOLUTION_PREFIX"

# Display a message to confirm the change
echo "SOLUTION_PREFIX set to: $SOLUTION_PREFIX"
