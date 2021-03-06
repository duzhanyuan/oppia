#!/usr/bin/env bash

# Copyright 2015 The Oppia Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS-IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

##########################################################################

# INSTRUCTIONS:
#
# Run this script from the oppia root folder prior to opening a PR:
#   bash scripts/run_presubmit_checks.sh
#
# It runs all the tests, in this order:
# - Javascript and Python Linting
# - Frontend Karma unit tests
# - Backend Python tests
#
# If any of these tests result in errors, this script will terminate.
#
# Note: The test scripts are arranged in increasing order of time taken. This
# enables a broken build to be detected as quickly as possible.
if [ -z "$BASH_VERSION" ]
then
  echo ""
  echo "  Please run me using bash: "
  echo ""
  echo "     bash $0"
  echo ""
  return 1
fi

set -e
# Run Javascript and Python linters.
echo 'Linting files since the last commit'
python $(dirname $0)/pre_commit_linter.py || exit 1
echo 'Linting passed.'
echo ''

# Run frontend unit tests.
echo 'Running frontend unit tests'
source $(dirname $0)/run_frontend_tests.sh --run-minified-tests=true || exit 1
echo 'Frontend tests passed.'
echo ''

# Run backend tests.
echo 'Running backend tests'
source $(dirname $0)/run_backend_tests.sh || exit 1
echo 'Backend tests passed.'
echo ''
