#http://ubuntuforums.org/showthread.php?t=320389
#https://bbs.archlinux.org/viewtopic.php?id=111506

export VIDEO_FORMAT=NTSC
time ffmpeg -i $inputfile -target ntsc-dvd final.mpg
dvdauthor -o DVD/ -t final.mpg
dvdauthor -o DVD/ -T
mkisofs -dvd-video -v -o dvd.iso DVD/
