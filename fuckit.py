#from scandir import scandir, walk

from pyminifier import compression, token_utils, minification
import os
import argparse
from shutil import copyfile

ignored = ['scipy/_lib/six.py', 'generate_sparsetools.py', 'numpy/distutils/system_info.py', 'numpy/distutils/command/config.py', 'numpy/distutils/command/autodist.py', 'numpy/lib/tests/test_function_base.py', 'numpy/f2py/cb_rules.py', 'numpy/f2py/tests/util.py', 'numpy/f2py/crackfortran.py', 'numpy/ma/tests/test_mrecords.py', 'numpy/core/setup.py', 'PIL/ImageFont.py']

def hititorquitit(path):
    if [x for x in ignored if path.endswith(x)]:
        return False
    if path.endswith('.py') and os.path.isfile(path):
        #print(path)
        return True
    return False

def copynonpy(path, output_path, starting_path):
    try:
        copyto = findnewpath(path, output_path, starting_path)
    except Exception as e:
        print("Skipping '{}'...Already exits, biotech!".format(path))
        return

    copyfile(path, copyto)

def findnewpath(path, output_path, starting_path):
    target = os.path.join(output_path, os.path.relpath(path, starting_path))
    if os.path.exists(target):
        print("{} already exists! Aborting...".format(target))
        raise Exception("Already exists! Aborting...")
    else:
        output_dir = os.path.dirname(target)
        print("{} Doesn't exist! Checking '{}'".format(target, output_dir))

        if not os.path.exists(output_dir):
            print("{} Doesn't exist! Creating...".format(output_dir))
            os.makedirs(output_dir)
    return target

def walkitoutboy(path, output_path, starting_path):
    target = os.scandir(path)
    for entry in target:
        if os.path.isdir(entry):
            # if entry.name.startswith('test'):
            #     print("Skippig the directory '{}' because it starts with 'test'. You dirty fucks.".format(entry.path))
            #     continue
            walkitoutboy(entry, output_path, starting_path)
        elif not hititorquitit(entry.path):
            copynonpy(entry.path, output_path, starting_path)
            continue
        else:
            minifile(entry.path, output_path, starting_path)

def minifile(path, output_path, starting_path):

    try:
        relpath=findnewpath(path, output_path, starting_path)
    except Exception as e:
        print("Skipping '{}'...Already exits, biotech!".format(path))
        return


    result = ''
    module = os.path.split(path)[1]
    module = ".".join(module.split('.')[:-1])
    filesize = os.path.getsize(path)
    source = open(path).read()
    tokens = token_utils.listified_tokenizer(source)
    # Convert the tokens from a tuple of tuples to a list of lists so we can
    # update in-place.


    class Poop(object):
        pass

    options = Poop()
    options.tabs = False

    print("Working on '{}'".format(path))
    # source = minification.minify(tokens, options)
    # Convert back to tokens in case we're obfuscating
    tokens = token_utils.listified_tokenizer(source)


    result += token_utils.untokenize(tokens)
    result = compression.lzma_pack(result)
    # result = compression.gz_pack(result)


    # print("Compressed '{}' and planning to write to '{}'".format(path, relpath))
    print("'{}' 8=====D~~~ '{}'".format(path, relpath))
    scribedat(result, relpath)
    # if options.outfile:
    #     f = io.open(options.outfile, 'w', encoding='utf-8')
    #     f.write(result)
    #     f.close()
    #     new_filesize = os.path.getsize(options.outfile)
    #     percent_saved = round(float(new_filesize)/float(filesize) * 100, 2)
    #     print((
    #         "{path} ({filesize}) reduced to {new_filesize} bytes "
    #         "({percent_saved}% of original size)".format(**locals())))

def scribedat(data, output_path):
    fp = open(output_path,'w', encoding='utf-8')
    fp.write(data)
    fp.close()

parser = argparse.ArgumentParser()

parser.add_argument(
    "source_path",
    help="Path to a directory or file"
)

parser.add_argument(
    "output_path",
    help="Path where to put your mom"
)

args = parser.parse_args()
target_path = args.source_path
output_path = args.output_path

starting_path = os.path.dirname(target_path)
print("Looking to start at '{}' with a base path of '{}'. All results will be written to '{}'".format(target_path, starting_path, output_path))

if os.path.isdir(target_path):
    print("'{}' appears to be a directory".format(target_path))
    walkitoutboy(target_path, output_path, starting_path)
else:
    print(os.path.islink(target_path))
    print("'{}' appears to be a file".format(target_path))
    if hititorquitit(target_path):
        minifile(target_path, output_path, starting_path)
