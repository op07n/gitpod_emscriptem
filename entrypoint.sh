#!/bin/bash
set -e

# set EMSDK environment variables
. /emsdk/emsdk_env.sh > /dev/null

exec "$@"
