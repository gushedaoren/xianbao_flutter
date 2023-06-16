
快捷键：
alias fr='flutter run -v --no-sound-null-safety'
alias buildapk='flutter build apk --no-sound-null-safety'
alias buildios='flutter build ios --no-sound-null-safety'
alias frhuawei='flutter run --flavor huawei --profile -v --no-sound-null-safety'
alias buildapp='flutter build appbundle --no-sound-null-safety'


flutter build apk --no-sound-null-safety


flutter run -v --no-sound-null-safety

编译google play：

flutter build appbundle --no-sound-null-safety


权限查看：
adb shell dumpsys package com.goume.health|grep QUERY_ALL_PACKAGES