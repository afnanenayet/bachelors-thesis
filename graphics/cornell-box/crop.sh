#!/bin/bash

# pixel 157, 679 at 1000 x 1000, so 80.384, 347.648;
for f in *.exr; do
    oiiotool --crop "64x64+48+316" "$f" -o "zoomins/${f%.*}-shadow.exr";
    oiiotool --crop "64x64+168+268" "$f" -o "zoomins/${f%.*}-box.exr";
    /Users/wjarosz/Src/hdrview/release/hdrbatch -e 4 -o "zoomins/${f%.*}-shadow" -f png -s "zoomins/${f%.*}-shadow.exr";
    /Users/wjarosz/Src/hdrview/release/hdrbatch -e 4.5 -o "zoomins/${f%.*}-box" -f png -s "zoomins/${f%.*}-box.exr";
    convert "zoomins/${f%.*}-shadow.png" -filter point -resize 1600% "zoomins/${f%.*}-shadow-big.png"
    convert "zoomins/${f%.*}-box.png" -filter point -resize 1600% "zoomins/${f%.*}-box-big.png"
done

/Users/wjarosz/Src/hdrview/release/hdrbatch -e 1.5 -f png -s *.exr;

convert cornell-bush-s2-289.png  -fill none -stroke blue -strokewidth 3 -draw "rectangle 48,316 112,380" -fill none -stroke red -strokewidth 3 -draw "rectangle 168,268 232,332" cornell-bush-s2-289-marked.png

# for f (zoomins/*.png); do convert $f -filter point -resize 1600% ${f:r}-big.png; done
# convert bush-s2-121.png -fill none -stroke black -strokewidth 2 -draw "rectangle 368,268 432,332" bush-s2-121-marked.png
