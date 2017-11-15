#from scandir import scandir, walk

from pyminifier import compression, token_utils
import os
import argparse

def hititorquitit(path):
    if path.endswith('.py') and os.path.isfile(path):
        #print(path)
        return True
    return False

def walkitoutboy(path, output_path, starting_path):
    result=''
    target = os.scandir(path)
    for entry in target:
        if os.path.isdir(entry):
            walkitoutboy(entry, output_path, starting_path)
        elif not hititorquitit(entry.path):
            continue
        else:
            minifile(entry.path, output_path, starting_path)
    return result



def minifile(path, output_path, starting_path):
    result = ''
    module = os.path.split(path)[1]
    module = ".".join(module.split('.')[:-1])
    filesize = os.path.getsize(path)
    source = open(path).read()
    # Convert the tokens from a tuple of tuples to a list of lists so we can
    # update in-place.
    tokens = token_utils.listified_tokenizer(source)
    result += token_utils.untokenize(tokens)
    result = compression.lzma_pack(result)
    # result += (
    #     "# Created by pyminifier "
    #     "(https://github.com/liftoff/pyminifier)\n")
    # Either save the result to the output file or print it to stdout

    relpath = os.path.join(output_path, os.path.relpath(path, starting_path))
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
    if os.path.exists(output_path):
        print("{} already exists! Aborting...".format(output_path))
        raise Exception("{} already exists! Aborting...".format(output_path))
    else:
        fp = open(output_path,'w')
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
