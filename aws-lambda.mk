include common.mk

TEMP_DIR=$(shell pwd)/tmp

aws_lambda_package::
	zip -r9 ${APP_NAME}.zip .

deps:: common_terraform_binary common_jq_binary common_aws_cli

aws_lambda_deploy:: deps package
	${TEMP_DIR}/terraform init
	${TEMP_DIR}/terraform apply

aws_lambda_clean::
	-rm -f ${APP_NAME}.zip
	-rm -rf ${TEMP_DIR}
