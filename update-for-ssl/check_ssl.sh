#!/bin/bash

for i in `cat domains.txt`
do
	python3 sslcert_time.py $i
done
