#!/bin/bash

for f in *.exr; do
    oiiotool --crop "64x64+368+268" "$f" -o "zoomins/${f%.*}.exr";
    /Users/wjarosz/Src/hdrview/release/hdrbatch -e 2 -o "zoomins/${f%.*}" -f png -s "zoomins/${f%.*}.exr";
    convert "zoomins/${f%.*}.png" -filter point -resize 1600% "zoomins/${f%.*}-big.png"
done

# for f (zoomins/*.png); do convert $f -filter point -resize 1600% ${f:r}-big.png; done
convert bush-s2-121.png -fill none -stroke orange -strokewidth 3 -draw "rectangle 368,268 432,332" bush-s2-121-marked.png
