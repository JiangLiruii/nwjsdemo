之前写过一个使用 electron 进行打包的文章, 但是现在公司又有需求是需要在 xp 上适配, 而 electron 是不支持 xp 的, 于是就想到了另一款打包工具, nwjs.

nwjs全称 Node-Webkit, 可以同时使用 DOM 和 node.js 的所以模块.所以就赋予了桌面端的功能.

这里使用 [nwjs-builder-phoenix](https://github.com/evshiron/nwjs-builder-phoenix), 可以支持命令行打包.环境选择 windows, mac 类似, 但 mac 我只打出了 .app 包, 没有 developer 账号, 没法进行签名.所以体验不如 windows 好.

1. npm init 生成 package.json, yarn add nwjs-builder-phoenix -D 安装库
   
2. 添加待打包文件到 build 文件夹下:index.html
   
3. 添加配置生成文件, application_generator.js

4. 添加打包用的 win_package.json, mac_package.json, xp_package.json 对应不同的平台, 一下配置基本上涵盖了所有的 build 参数也都写了注释.这些参数也可以在打开新窗口 nw.Window.open('url', {options})中使用

5. 添加打包成 installer的 nsis 文件, 记住一定要将格式转换为 utf8 with DOM, 不然里面写的中文会报字符编码的错误

6. 添加打包命令, package.json

7. 然后依次执行 `application:generator:win7`, `dist:nw:win7`, `dist:nsis:win7`即可打包出一个安装包

然后需要注意的点是如果需要打包成 xp 的话, 请使用nwVersion: 0.14.7的版本即可, 就是换了个壳, 如果网页版在 xp 下打不开那nwjs 也无能为力. 
)