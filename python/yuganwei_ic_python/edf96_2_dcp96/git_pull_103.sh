#!/bin/bash

#path
sub="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_s1/sub"
vobs="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs"

#git pull
cd $vobs
git pull
cd $sub
git pull