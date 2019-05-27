#!/bin/bash

# rm idiff.txt;
# # pixel 157, 679 at 1000 x 1000, so 80.384, 347.648;
# for f in *.exr; do
#     idiff cornell-reference-direct.exr "$f" >> idiff.txt;
# done

# /Users/wjarosz/Src/hdrview/release/hdrbatch --error=squared --reference=cornell-reference-direct.exr *.exr > hdrbatch-mse.txt
# /Users/wjarosz/Src/hdrview/release/hdrbatch --error=absolute --reference=cornell-reference-direct.exr *.exr > hdrbatch-mae.txt
# /Users/wjarosz/Src/hdrview/release/hdrbatch --error=relative-squared --reference=cornell-reference-direct.exr *.exr > hdrbatch-mrse.txt

/Users/wjarosz/Src/hdrview-new/build3/hdrbatch --reference=cornell-reference-direct.exr --error=relative-squared *.exr > mse.csv
