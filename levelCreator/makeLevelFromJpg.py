#!/usr/bin/env python


import sys,os,Image


if len(sys.argv) != 3:
    print "usage: %s imagename.jpg gridsize" % sys.argv[0]
    sys.exit(1)

inputimage=sys.argv[1]
gridsize = int(sys.argv[2])


im = Image.open(inputimage)
pixelData = im.load() #indexable pixel rgb data

newimagename=os.path.splitext(inputimage)[0] + "_pixelated.tiff"
coeffilename=os.path.splitext(inputimage)[0] + ".coe"

#coef file prefix
PREFIX=";; this is memory inits for NEWLEVELIMAGE\n;;remember that the frames are defined 0th frame at bottom\nmemory_initialization_radix=2;\nmemory_initialization_vector=\n"


(hsize,vsize)=im.size
hsize=hsize/gridsize
vsize=vsize/gridsize


def pixelate(img):
    newim = Image.new("RGB", (gridsize, gridsize), "white")
    coel = []
    # for each pixelated region block
    for px in xrange(gridsize): 
        for py in xrange(gridsize):
            r, g, b = 0, 0, 0
            count = 0
            # for each pixel in that block
            for x in xrange(px*hsize, px*hsize+hsize):
                for y in xrange(py*vsize, py*vsize+vsize):
                    tempr,tempg,tempb = img[x,y]
                    r += tempr
                    g += tempg
                    b += tempb
                    count += 1
            # get mean pixel value
            nc = ((r/count),(g/count),(b/count))
            (nr,ng,nb) = nc
            # build memory coefficient format (convert rgb to 8bit color ie in bits rrrgggbb)
            coel.append(str(bin(nr/32)).lstrip("0b").zfill(3) + str(bin(ng/32)).lstrip("0b").zfill(3) + str(bin(nb/64)).lstrip("0b").zfill(2))
            # write out test image
            newim.putpixel((px,py),nc)
    # save the test image
    newim.save(newimagename, "tiff")
    coel.reverse() #needs to be in reverse order
    # write out coefficient file
    coeffile = open(coeffilename, "w+")
    coeffile.write(PREFIX)
    for line in coel:
        coeffile.write(line+";\n")
    coeffile.close()
    



pixelate(pixelData)
print "block size: " + str(hsize) + ", " + str(vsize)
print "pixelated and output test image: " + newimagename
print "pixelated and output coefficient file: " + coeffilename







