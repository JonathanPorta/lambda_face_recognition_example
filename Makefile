#TEMP_DIR=$(shell pwd)/tmp
CWD=$(shell pwd)
DLIB_BIN=${CWD}/dlib

include ops/common.mk

deps:: clean common_jq_binary
	./ops/gh.sh latest aeddi/aws-lambda-python-opencv
	unzip aws-lambda-python-opencv-prebuilt.zip
	mv ./aws-lambda-python-opencv-prebuilt/{cv2,numpy,lambda_function.py} ./

package:
	zip -r9 ${APP_NAME}.zip lambda_function.py numpy cv2

deploy: aws_lambda_deploy

clean:: clean_container
	-rm -rf ./aws-lambda-python-opencv-prebuilt ./cv2 ./numpy
	-rm aws-lambda-python-opencv-prebuilt.zip lambda_function.py ${APP_NAME}.zip
	-rm -rf ${DLIB_BIN}

test:
	@echo 'TODO: Actually test something, dude.'

build_dlib:
	docker build -t jonathanporta/aws-lambda-python-opencv .
	docker run --name dlib-build-container jonathanporta/aws-lambda-python-opencv:latest
	docker cp dlib-build-container:/dlib/ ${CWD}
	-docker rm dlib-build-container

clean_container:
	@-docker rm dlib-build-container
