#!/bin/bash

for f in *.exr; do
    oiiotool --crop "48x48+391+94" "$f" -o "zoomins/${f%.*}.exr";
    /Users/wjarosz/Src/hdrview/release/hdrbatch -e 3 -o "zoomins/${f%.*}" -f png -s "zoomins/${f%.*}.exr";
    convert "zoomins/${f%.*}.png" -filter point -resize 1600% "zoomins/${f%.*}-big.png"
done


/Users/wjarosz/Src/hdrview/release/hdrbatch -e 0 -f png -s *.exr;

# for f (zoomins/*.png); do convert $f -filter point -resize 1600% ${f:r}-big.png; done
convert barcelona-reference.png -fill none -stroke green -strokewidth 3 -draw "rectangle 391,94 439,142" barcelona-marked.png
