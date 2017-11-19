CWD=$(shell pwd)

include ops/common.mk

deps:: common_jq_binary
	pyvenv-3.6 env
	./env/bin/pip install -r requirements.txt --target=./build

package:
	cd ./build && zip -r9 ../${APP_NAME}.zip *

release: aws_lambda_deploy

clean::
	-rm ${APP_NAME}.zip
	-rm -rf build

test:
	@echo 'TODO: Actually test something, dude.'

build: clean deps
	-mkdir -p build
	./env/bin/pip install -r requirements.txt --target=./build
	cp ./lambda.py ./build/lambda.py
