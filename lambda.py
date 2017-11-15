import cv2
import numpy
import dlib

def handler(event, context):
    print "cv2 installed version:", cv2.__version__
    print "numpy installed version:", numpy.__version__
    print "dlib installed version:", dlib.__version__
    print event
    return "It works!"

if __name__ == "__main__":
    handler(42, 42)
