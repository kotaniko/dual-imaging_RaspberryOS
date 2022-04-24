#!/bin/bash

echo
read -p "    CONFIG: set 30 fps..."
echo
echo "Firstly, FPGA is configured to bypass the streams (30 fps)"
echo "So, we expect the data-rate of 1920[width]*1080[height]*2[byte/pixel]*30[fps]/1024/1024 = 118[MiB/s] for each stream."
echo "Let's see the data-rate with pv command."

pipeview1="pv -pr -s 1G -S /dev/xdma0_c2h_0 > /dev/null"
pipeview2="pv -pr -s 1G -S /dev/xdma0_c2h_1 > /dev/null"
read -p "run: $pipeview1 & $pipeview2"
eval "{ $pipeview1 & $pipeview2; } | cat"
sleep .5
echo
echo "Each stream achieves the data-rate of 118MiB/s, meaning the total data-rate is 118[MiB/s]*2*8[bits/byte] = 1.9 Gbps"
echo "However, when the data is stored into the RAM, some of them are lost."
echo "Let's see the data-rate when the data is stored to RAM with dd command."
dd1="dd if=/dev/xdma0_c2h_0 ibs=1920x1080x2 count=90 of=/tmp/ram/out1 obs=32k"
dd2="dd if=/dev/xdma0_c2h_1 ibs=1920x1080x2 count=90 of=/tmp/ram/out2 obs=32k"
read -p "run: $dd1 & $dd2"
eval "{ $dd1 & $dd2; } | cat"
sleep .5
echo
echo "Obviously, the data-rate decreased, meaning some data was lost. Raspberry Pi cannot handle writing this much of data to its RAM."

echo
read -p "    CONFIG: set 15 fps..."
echo
echo "Now, FPGA is configured to reduce FPS from 30 fps to 15 fps"
echo "So, we expect the data-rate of 1920[width]*1080[height]*2[byte/pixel]*15[fps]/1000/1000 = 62[MB/s] for each stream."
echo "Let's store the data to RAM with dd command."
dd1="dd if=/dev/xdma0_c2h_0 ibs=1920x1080x2 count=90 of=/tmp/ram/out1 obs=32k"
dd2="dd if=/dev/xdma0_c2h_1 ibs=1920x1080x2 count=90 of=/tmp/ram/out2 obs=32k"
read -p "run: $dd1 & $dd2"
eval "{ $dd1 & $dd2; } | cat"
sleep .5
echo
echo "You can observe the dd command copied the streams to RAM with the expected rate of 62 MB/s."

echo
ffplay1="ffplay -f rawvideo -pixel_format bgr565le -video_size 1920x1080 -framerate 15 -autoexit -fs /tmp/ram/out1"
ffplay2="ffplay -f rawvideo -pixel_format bgr565le -video_size 1920x1080 -framerate 15 -autoexit -fs /tmp/ram/out2"
echo "Let's play the video from Camera 1 with ffplay command."
read -p "run: $ffplay1"
eval "$ffplay1 2> /dev/null"
sleep .5

echo
echo "Let's play the video from Camera 2 with ffplay command."
read -p "run: $ffplay2"
eval "$ffplay2 2> /dev/null"
sleep .5
echo

echo "You can see that the video streams are properly copied into the RAM with 15 fps."
echo "Note that the data-rate of 62 MB/s per stream is equivalent to 62[MB/s]*2*8[bits/byte] = 992[Mbps]."
echo "This is a bit less than 1.0 Gbps, but considering the overhead of TCP/IP, this data-rate outperforms ethernet communication."
echo
