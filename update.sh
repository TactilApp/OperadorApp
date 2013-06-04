#!/bin/bash
if [ $# -ge 1 ] ;
then
	git clone git@bitbucket.org:tactilapp/operadorapp-config-ios.git configuracion	
else
	cp -rfv configuracion-ejemplo configuracion
fi
