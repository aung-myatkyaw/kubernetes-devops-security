#!/bin/bash
#cis-kubelet.sh

total_fail=$(sudo kube-bench run --targets node --check 4.2.1,4.2.2 --json | jq .Totals.total_fail)

if [[ "$total_fail" -ne 0 ]];
then
	echo "CIS Benchmark Failed Kubelet while testing for 4.2.1, 4.2.2"
	exit 1;
else
	echo "CIS Benchmark Passed Kubelet for 4.2.1, 4.2.2"
fi;
