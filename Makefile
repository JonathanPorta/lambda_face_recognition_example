include ops/aws-lambda.mk

#APP_NAME=lambda-dlib-opencv-example - check ./.env

deps:: clean
	./ops/gh.sh latest aeddi/aws-lambda-python-opencv
	unzip aws-lambda-python-opencv-prebuilt.zip
	mv ./aws-lambda-python-opencv-prebuilt/{cv2,numpy,lambda_function.py} ./

package:
	zip -r9 ${APP_NAME}.zip lambda_function.py numpy cv2

deploy: aws_lambda_deploy

clean::
	-rm -rf ./aws-lambda-python-opencv-prebuilt ./cv2 ./numpy
	-rm aws-lambda-python-opencv-prebuilt.zip lambda_function.py ${APP_NAME}.zip
