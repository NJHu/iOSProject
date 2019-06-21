
project_name="NJDouYu"



xcodebuild archive -workspace ./SwiftProject/$project_name.xcworkspace -scheme $project_name -configuration DEBUG -archivePath ./archive/$project_name.xcarchive  CODE_SIGN_IDENTITY="iPhone Developer: peng Hu (E3XR665Z27)" PROVISIONING_PROFILE_SPECIFIER="NJDouYu_dev_profile_MPB"


xcodebuild -exportArchive -exportOptionsPlist archieveOpt.plist -archivePath archive/$project_name.xcarchive -exportPath ./ -configuration DEBUG


xcodebuild clean


xcodebuild archive -workspace iOSProject.xcworkspace -scheme iOSProject -configuration DEBUG -archivePath ./archive/iOSProject.xcarchive  CODE_SIGN_IDENTITY="iPhone Developer: peng Hu (E3XR665Z27)" PROVISIONING_PROFILE_SPECIFIER="iosprojectID_dev_profile_MPB"


xcodebuild -exportArchive -exportOptionsPlist ./apps/export.plist -archivePath ./archive/iOSProject.xcarchive -exportPath ./apps/ -verbose -UseModernBuildSystem=NO