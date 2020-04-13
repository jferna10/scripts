#!/bin/bash

diff -U $(wc -l < $1) $1 $2 | sed -n 's/^-//p' | tail -n+2