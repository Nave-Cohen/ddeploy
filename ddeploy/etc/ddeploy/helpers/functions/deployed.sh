#!/usr/bin/env bash

function write_deployed(){
    remove_deployed $1
    echo $1 >> /etc/ddeploy/configs/deployed.lst
}
function remove_deployed(){
    sed -i "/$1/d" /etc/ddeploy/configs/deployed.lst
}