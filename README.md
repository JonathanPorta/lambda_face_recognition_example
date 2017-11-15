# dlib-opencv build for lambda
Based on https://github.com/aeddi/aws-lambda-python-opencv


#scratchpad
yum install -y python36* gcc g++ gcc gcc-c++ cmake


docker cp dlib-build-container:/var/lang/lib/python3.6/site-packages/ ./
mv ./site-packages/* ./
ln -s ./dlib-19.7.0-py3.6-linux-x86_64.egg/ ./dlib


//docker cp dlib-build-container:/var/task/boost_1_65_1/ ./



docker cp dlib-build-container:/var/lang/lib/python3.6/site-packages/ ./

###################################################################
export BOOST_INCLUDEDIR=$(pwd)/build/boost_1_65_1/
export BOOST_ROOT=$(pwd)/build/boost_1_65_1/
export BOOST_LIBRARYDIR=$(pwd)/build/boost_1_65_1/stage/lib/
export LD_LIBRARY_PATH=$(pwd)/build/boost_1_65_1/stage/lib/:$LD_LIBRARY_PATH

make build_container &&
cp ./lambda.py ./build/


/home/portaj/devel/lambda-dlib-opencv-example/build/boost_1_65_1/stage




python3 -m compileall .

rsync -a --include='*.pyc' --include='*/' --exclude='*' ./build/ ./buildpyc/

find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf  
