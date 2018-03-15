#!/bin/bash

services_to_disable="chargen-dgram chargen-stream daytime-dgram daytime-stream discard-dgram discard-stream echo-dgram echo-stream time-dgram time-stream tftp"

disable_service(){
  service_to_disable="$1"
  chkconfig $service_to_disable off && echo "Service $service_to_disable disabled" || echo "Service $service_to_disable does not exist. Good!" 
}
