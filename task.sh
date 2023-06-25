#!/bin/bash

# For your convenience
alias PlistBuddy=/usr/libexec/PlistBuddy

# Read script input parameter and add it to your Info.plist. Values can either be CATS or DOGS
if [ "$1" == "CATS" ]; then
    PlistBuddy -c "Set :AnimalType CATS" "./CatsAndModules_YanaBuha/CatsAndModules_YanaBuha/Info.plist"
elif [ "$1" == "DOGS" ]; then
    PlistBuddy -c "Set :AnimalType DOGS" "./CatsAndModules_YanaBuha/CatsAndModules_YanaBuha/Info.plist"
else
    echo "Invalid argument. Please specify either CATS or DOGS."
    exit 1
fi

# Clean build folder
xattr -w com.apple.xcode.CreatedByBuildSystem true /Users/yanabuha/Desktop/appleSpace/CatsAndModules_YanaBuha/build
xcodebuild clean -configuration Release -alltargets

# Create archive
xcodebuild archive -scheme CatsAndModules_YanaBuha -configuration Release -archivePath "build/CatsAndModules_YanaBuha" -destination "generic/platform=iOS"

# Export archive
xcodebuild -exportArchive -archivePath "build/CatsAndModules_YanaBuha.xcarchive" -exportOptionsPlist "exportOptions.plist" -exportPath "/Users/yanabuha/Desktop/appleSpace/CatsAndModules_YanaBuha/Exported"

# Rename exported directory based on the selected animal type
if [ "$1" == "CATS" ]; then
    mv "/Users/yanabuha/Desktop/appleSpace/CatsAndModules_YanaBuha/Exported" "/Users/yanabuha/Desktop/appleSpace/CatsAndModules_YanaBuha/Exported_CATS"
elif [ "$1" == "DOGS" ]; then
    mv "/Users/yanabuha/Desktop/appleSpace/CatsAndModules_YanaBuha/Exported" "/Users/yanabuha/Desktop/appleSpace/CatsAndModules_YanaBuha/Exported_DOGS"
fi

echo "Export completed. The IPA file is located in the build/Exported directory."
