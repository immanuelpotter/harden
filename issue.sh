#!/bin/bash
#
# CIS Benchmark Standard CentOS 7 v2.1.1
# 
# Overwrites the issue at startup to remove OS information
#

overwrite_issue(){
  echo "$ISSUE_MESSAGE" > /etc/issue
  echo "$ISSUE_MESSAGE" > /etc/issue.net
}
