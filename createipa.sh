#!/bin/zsh

rm verus.ipa
rm -rf Payload
mkdir Payload

cp -r ~/Library/Developer/Xcode/DerivedData/$(ls -At ~/Library/Developer/Xcode/DerivedData/ | head -n 1)/Build/Products/Debug-iphoneos/Verus\ CCminer.app Payload/verus.app

zip -r verus.ipa Payload
