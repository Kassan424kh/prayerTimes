#!/bin/bash

kill $(lsof -t -i :5002)
sleep 2
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export FLASK_APP=restful_server.py
nohup python3.7 -m flask run -h "0.0.0.0" -p 5002 --reload