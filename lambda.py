import lambda_face_recognition_prebuilt.unpack

def handler(event, context):
    import face_recognition
    print("face_recognition installed version:", face_recognition.__version__)
    print(event)
    return "It works!"

if __name__ == "__main__":
    handler(69, 69)
