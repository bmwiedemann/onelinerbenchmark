#!/bin/sh
benchmark=./benchmark
make
perl -e 'for(1..1000000){}' #warmup CPU
$benchmark "bash -c ''"
$benchmark "./empty"
$benchmark "busybox-static echo -n ''"
$benchmark "busybox-static sh -c ''"
$benchmark "perl -e ''"
$benchmark "ruby --disable-gems -e ''"
$benchmark "ruby -e ''"
$benchmark "python -S -c ''"
$benchmark "python -c ''"
$benchmark "php -r ''"
