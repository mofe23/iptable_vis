#!/usr/bin/env bash

read -r -d '' USAGE << EOM
Visualizes iptables configuration as SVG
see github.com/Nudin/iptable_vis

Usage: ${0} [outfile]

Options:
    outfile:  If not set, output is written to stdout
EOM

if [[ "${1}" == "-h" || "${1}" == "--help" ]]; then
    echo "${USAGE}"
    exit 0
fi

OUTFILE="${1:-/dev/stdout}"

TMPDIR="/tmp"
TMPTXT="${TMPDIR}/iptables.txt"
TMPDIA="${TMPDIR}/iptables.dia"

# Gets script directory, also if executed per symlink!
SCRIPTDIR=$( cd -- "$( dirname -- "$(readlink -f "${BASH_SOURCE[0]}" || ${BASH_SOURCE[0]})"   )" &> /dev/null && pwd   )
IPTABLES_AWK="${SCRIPTDIR}/iptables-vis.awk"


sudo iptables -v -L > "${TMPTXT}"
awk -f "${IPTABLES_AWK}" < "${TMPTXT}" > "${TMPDIA}"
blockdiag "${TMPDIA}" -T svg -o "${OUTFILE}"

