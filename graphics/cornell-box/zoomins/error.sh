#!/bin/bash

# rm idiff.txt;
# for f in *-box.exr; do
#     idiff cornell-reference-direct-box.exr "$f" >> idiff.txt;
# done
#
# for f in *-shadow.exr; do
#     idiff cornell-reference-direct-shadow.exr "$f" >> idiff.txt;
# done

/Users/wjarosz/Src/hdrview-new/build3/hdrbatch --reference=cornell-reference-direct-box.exr --error=relative-squared *-box.exr > mse-box.csv
/Users/wjarosz/Src/hdrview-new/build3/hdrbatch --reference=cornell-reference-direct-shadow.exr --error=relative-squared *-shadow.exr > mse-shadow.csv

# /Users/wjarosz/Src/hdrview/release/hdrbatch --error=squared --reference=../cornell-reference-direct-box.exr *-box.exr > hdrbatch-mse.txt
# /Users/wjarosz/Src/hdrview/release/hdrbatch --error=absolute --reference=../cornell-reference-direct.exr *.exr > hdrbatch-mae.txt
# /Users/wjarosz/Src/hdrview/release/hdrbatch --error=relative-squared --reference=../cornell-reference-direct.exr *.exr > hdrbatch-mrse.txt
