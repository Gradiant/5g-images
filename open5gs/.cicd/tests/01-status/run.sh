#!/bin/bash

docker-compose up -d

sleep 5
n_services_up=$(docker-compose ps | grep Up | wc -l)
expected_result=17
docker-compose down -v

if [ "$n_services_up" -eq "$expected_result" ]; then
    echo -e "Test result: \033[0;32mOK\033[0m"
    exit 0
else
    echo -e "Test result: \033[0;31mFailed\033[0m"
    exit -1
fi