#!/bin/bash
#cis-etcd.sh

total_fail=$(sudo kube-bench run --targets etcd --check 2.2 --json | jq .Totals.total_fail)

if [[ "$total_fail" -ne 0 ]];
then
	echo "CIS Benchmark Failed ETCD while testing for 2.2"
	exit 1;
else
	echo "CIS Benchmark Passed for ETCD - 2.2"
fi;
