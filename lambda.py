import face_recognition

def handler(event, context):
    print("face_recognition installed version:", face_recognition.__version__)
    print(event)
    return "It works!"

if __name__ == "__main__":
    handler(69, 69)
