  #!/bin/bash
#只需要在终端中输入 $ sh archive.sh  即可打包成ipa
 
packaging(){

#***********配置项目
#工程名称(Project的名字)
MWProjectName=$1
#scheme名字 -可以点击Product->Scheme->Manager Schemes...查看
MWScheme=$2
#Release还是Debug
MWConfiguration=$3
#日期
MWDate=`date +%Y%m%d_%H%M`
#工程路径
MWWorkspace=$4
#build路径
MWBuildDir=$5
#plist文件名，默认放在工程文件路径的位置
MBPlistName=$6

#创建构建和输出的路径
mkdir -p $MWBuildDir

#pod 相关配置

#更新pod配置
pod update

#构建
xcodebuild archive \
-workspace "$MWProjectName.xcworkspace" \
-scheme "$MWScheme" \
-configuration "$MWConfiguration" \
-archivePath "$MWBuildDir/$MWProjectName" \
CODE_SIGN_IDENTITY="iPhone Developer: peng Hu (E3XR665Z27)" \
PROVISIONING_PROFILE_SPECIFIER="iosprojectID_dev_profile_MPB"

#生成ipa
xcodebuild -exportArchive \
-archivePath "$MWBuildDir/$MWProjectName.xcarchive" \
-exportPath "$MWBuildDir/$MWProjectName$MWDate" \
-exportOptionsPlist "$MWWorkspace/$MBPlistName"

open $MWBuildDir

}

#函数调用
# $1 工程名  $2 scheme名字  $3 Release还是Debug  $4 工程路径  $5 ipa文件输出路径 $6 plist文件名字
packaging "iOSProject" "iOSProject"  "DEBUG"  "./build/archive" "./build/ipa" "./build/ExportOptions.plist"