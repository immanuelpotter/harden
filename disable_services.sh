#!/bin/bash

disable_service(){
  service_to_disable="$1"
  chkconfig $service_to_disable off && echo "Service $service_to_disable disabled" || echo "Service $service_to_disable does not exist. Good!" 
}
