1. 下载[打包文件](http://dl.nwjs.io/v0.19.5-mas-beta/) 和[官方SDK包](https://nwjs.io/) 放入mac_build_config中
2. 执行完 `yarn dist:nw:mac`, 拷贝生成的 `application_mac/dist/xxx.app/Contents/Resource/app.nw`到此目录下的`nwjs.app/Content/Resources`
3. 下载密钥链, 装载到密钥链中
4. 在此目录下执行`python ./mas/build_mas.py -C ./mas/build.cfg -I ./nwjs.app -O  nwjs-demo.app` 进行 app 的签名, 重命名和 icon 替换.
5. 继续执行`productbuild --component nwjs-demo.app /Applications --sign "Developer ID Installer: Jiang Lirui (8VXVP9G7PN)" --product nwjs-demo.app/Contents/Info.plist nwjs-demo.pkg`生成 pkg 文件;
6. 默认会安装于`/Application`, 如果没有按照既定路径安装, 请删除所有与打包相关的 app 文件(会根据已有的 [application bundle](https://kuvacode.com/blog/building-for-the-mac-app-store) 进行关联和覆盖).