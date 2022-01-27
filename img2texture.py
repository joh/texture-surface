"""
Textured parametric surfaces in OpenSCAD

by Johannes H. Jensen <joh@pseudoberries.com>
https://github.com/joh/texture-surface

Copyright (c) 2022 by Johannes H. Jensen
License: MIT, see LICENSE for more details.
"""
from PIL import Image, ImageOps
import numpy as np

def img2texture(image, name='texture', mode='1', invert=False):
    with Image.open(image) as im:
        gray = im.convert('L')
        if invert:
            gray = ImageOps.invert(gray)
        gray = gray.convert(mode)
        data = np.array(gray, dtype=int)
        print(f"{name} =")
        print(np.array2string(data, threshold=np.inf, separator=','), end=';\n')

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='Convert image to SCAD texture')
    parser.add_argument('image')
    parser.add_argument('-n', '--name', default='texture')
    parser.add_argument('--mode', choices=('L', '1'), default='1')
    parser.add_argument('--invert', action='store_true')

    args = parser.parse_args()
    img2texture(args.image, args.name, args.mode, args.invert)
