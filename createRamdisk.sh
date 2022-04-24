#!/bin/bash

mkdir /tmp/ram
chmod 777 /tmp/ram
mount -t tmpfs -o size=1024m tmpfs /tmp/ram
