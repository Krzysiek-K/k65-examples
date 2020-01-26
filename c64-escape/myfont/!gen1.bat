@echo off
bin2h kk1.prg >kk1.h
gawk -f _encode2.awk kk1.h >font.k65
pause
