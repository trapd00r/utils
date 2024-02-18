#!/usr/bin/python3

# Automatically group the font files by family names and style names,
# and assume each bitmap font only contains one font face.
#
# Generates one otb file per (family name, style name) tuple, named
# after the tuple.
#
# This tool requires ftdump and fonttosfnt.

# Written by Peng Wu as
# https://pwu.fedorapeople.org/fonts/convertbitmap/convertfont.py
# Some changes by Hans Ulrich Niedermann.

import sys
import subprocess

usage = '''
bitmapfonts2otb.py [BITMAPFONTFILE]...
'''

fontnames = dict()

# get font family name and style name by ftdump
def getfullname(fontname):
    output = subprocess.check_output(['ftdump', fontname])

    output = output.decode('utf8')
    # only contain one font face
    assert not 'Face number: 1' in output
    result = {}
    for row in output.split('\n'):
        if ':' in row:
            key, value = row.split(': ')
            result[key.strip()] = value.strip()

    familyname, stylename = result['family'], result['style']
    if stylename == 'Regular':
        return familyname
    else:
        return familyname + ' ' + stylename


def generate_fonts():
    for fullname, filenames in fontnames.items():
        outputfilename = fullname.replace(' ', '-')  + '.otb'
        argv = ['fonttosfnt', '-b', '-c', '-g', '2', '-m', '2', '-o', outputfilename ]
        argv.extend(filenames)
        print(outputfilename)
        print(' '.join(argv))
        print(subprocess.check_output(argv).decode('utf8'))


if __name__ == '__main__':
    for bitmapfontname in sys.argv[1:]:
        fullname = getfullname(bitmapfontname)
        if fullname in fontnames:
            fontnames[fullname].append(bitmapfontname)
        else:
            fontnames[fullname] = [bitmapfontname]

    generate_fonts()
