#!/bin/sh
ROOT="$(cd "$(dirname "$0")" 2>/dev/null && pwd)/../Resources"
export GPDOCDIR="${ROOT}/doc"
export GP_DATA_DIR="${ROOT}/share/pari"
open -a Terminal ${ROOT}/bin/gp
