#!/bin/bash

git rm --cached Pods/Headers/\* --ignore-unmatch
git rm --cached Pods/Target\ Support\ Files/\* --ignore-unmatch
git rm --cached Pods/Local\ Podspecs/\* --ignore-unmatch
git rm --cached Pods/Pods.xcodeproj/\* --ignore-unmatch
git rm --cached Pods/\* --ignore-unmatch
git commit -m "delete pods files"
