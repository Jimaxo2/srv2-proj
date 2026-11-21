#!/bin/sh
set -e

python -u main.py &

exec python -u app.py