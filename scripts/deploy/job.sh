#!/bin/bash

echo "Name of TestRun: $1";
#echo "./run.sh new ${1};"

cd ../../
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED=ON -DHOTSTUFF_PROTO_LOG=ON; make -j4
cd scripts/deploy

./gen_all.sh;
./run.sh setup;
./run.sh new ${1};
sleep 30;
./run_cli.sh new ${1}_cli;
sleep 60;
./run_cli.sh stop ${1}_cli;
./run.sh stop ${1};
./run_cli.sh fetch ${1}_cli;
cat ${1}_cli/remote/*/log/stderr | python3 ../thr_hist.py --plot
