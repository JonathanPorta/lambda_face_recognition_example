CWD=$(shell pwd)
DLIB_BIN=${CWD}/dlib

include ops/common.mk

deps:: common_jq_binary build_container

package:
	zip -r9 ${APP_NAME}.zip build/*

deploy: aws_lambda_deploy

clean:: clean_container
	-rm -rf ${TEMP_DIR}/aws-lambda-python-opencv-prebuilt ./cv2 ./numpy
	-rm ${TEMP_DIR}aws-lambda-python-opencv-prebuilt.zip ${APP_NAME}.zip
	-rm -rf ${DLIB_BIN}
	-rm -rf build

test:
	@echo 'TODO: Actually test something, dude.'

build: clean build_container
	#-mkdir -p ./build/boost_1_65_1/stage
	#docker cp dlib-build-container:/var/task/boost_1_65_1/stage  ./build/boost_1_65_1/stage
	docker cp dlib-build-container:/var/task/ ./build
	cp ./lambda.py ./build/

build_container: clean_container
	docker build -t jonathanporta/aws-lambda-python-opencv .
	docker run --name dlib-build-container jonathanporta/aws-lambda-python-opencv:latest

clean_container:
	@-docker rm dlib-build-container

shell: build_container
	@-docker rm dlib-build-container
	docker run --rm -it jonathanporta/aws-lambda-python-opencv:latest bash
