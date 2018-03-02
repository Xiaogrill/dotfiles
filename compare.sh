#!/bin/sh

diff --color=always -ur r/ / | grep -v "^Only"
