set -e

trap "python emailer.py testing \${LINENO};" ERR

false
