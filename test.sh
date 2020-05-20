#!/bin/sh
benchmark=./benchmark
perl -e 'for(1..1000000){}' #warmup CPU
$benchmark "bash -c ''"
$benchmark "./empty"
$benchmark "./empty-static"
$benchmark "busybox-static echo -n ''"
$benchmark "busybox-static sh -c ''"
$benchmark "perl -e ''"
$benchmark "ruby --disable-gems -e ''"
$benchmark "ruby -e ''"
$benchmark "python -S -c ''"
$benchmark "python -c ''"
$benchmark "python3 -S -c ''"
$benchmark "php -r ''"
$benchmark "node -e ''"
