CWD=$(shell pwd)
DLIB_BIN=${CWD}/dlib

include ops/common.mk

deps:: clean common_jq_binary build_container
	cd ${TEMP_DIR} && ../ops/gh.sh latest aeddi/aws-lambda-python-opencv
	unzip ${TEMP_DIR}/aws-lambda-python-opencv-prebuilt.zip -d ${TEMP_DIR}
	mv ${TEMP_DIR}/aws-lambda-python-opencv-prebuilt/{cv2,numpy} ./

package:
	zip -r9 ${APP_NAME}.zip lambda.py numpy cv2 dlib

deploy: aws_lambda_deploy

clean:: clean_container
	-rm -rf ${TEMP_DIR}/aws-lambda-python-opencv-prebuilt ./cv2 ./numpy
	-rm ${TEMP_DIR}aws-lambda-python-opencv-prebuilt.zip ${APP_NAME}.zip
	-rm -rf ${DLIB_BIN}

test:
	@echo 'TODO: Actually test something, dude.'

build_container: clean_container
	docker build -t jonathanporta/aws-lambda-python-opencv .
	#docker run --name dlib-build-container jonathanporta/aws-lambda-python-opencv:latest
	#ocker cp dlib-build-container:/dlib/ ${CWD}

clean_container:
	@-docker rm dlib-build-container

shell: build_container
	docker run --rm -it jonathanporta/aws-lambda-python-opencv:latest bash
