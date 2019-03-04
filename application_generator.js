
var shell = require('shelljs');
var fs = require('fs');
var readline = require('readline');

if (!shell.which('git')) {
  shell.echo('Sorry, this script requires git');
  shell.exit(1);
}

var length = process.argv.length;
// 获取应用平台类型, 针对三个平台, mac, win 和 win xp(xp 不朽)
var platform = process.argv[length - 1];

// 获取版本号
var version_json = JSON.parse(fs.readFileSync('./versions.json', 'utf8'));
// 生成对应版本的文件夹 application_${platform}
if (platform == 'win') {
  var new_package_json = JSON.parse(fs.readFileSync('./application/win_package.json', 'utf8'));
  new_package_json.version = version_json.current;
  shell.rm('-rf', 'application_win');
  shell.mkdir('application_win');
  shell.cp('-R', 'build/', 'application_win/');
  shell.cp('-R', 'nsis/', 'application_win/');
  generate_nsis_file('application_win/nsis/demo.nsi');
  fs.writeFileSync('application_win/package.json', JSON.stringify(new_package_json, null, 2));
} else if (platform == 'xp') {
  var new_package_json = JSON.parse(fs.readFileSync('./application/xp_package.json', 'utf8'));
  new_package_json.version = version_json.current;
  shell.rm('-rf', 'application_xp');
  shell.mkdir('application_xp');
  shell.cp('-R', 'build/', 'application_xp/');
  shell.cp('-R', 'nsis/', 'application_xp/');
  generate_nsis_file('application_xp/nsis/demo.nsi');
  fs.writeFileSync('application_xp/package.json', JSON.stringify(new_package_json, null, 2));
} else if (platform == 'mac') {
  var new_package_json = JSON.parse(fs.readFileSync('./application/mac_package.json', 'utf8'));
  new_package_json.version = version_json.current;
  shell.rm('-rf', 'application_mac');
  shell.mkdir('application_mac');
  shell.cp('-R', 'build/', 'application_mac/');
  fs.writeFileSync('application_mac/package.json', JSON.stringify(new_package_json, null, 2));
}
// 脚本更新nsis 的 version
function generate_nsis_file(path) {
  var fread = fs.createReadStream('./nsis/demo.nsi');
  var version_line = 6;
  var obj_readline = readline.createInterface({
    input: fread,
  });
  var count = 1;
  var str = '';
  obj_readline.on('line', (line) => {
    if (version_line == count) {
      str = `${str}!define DEMO_VERSION ${version_json.current}\r\n`;
    } else {
      str += line + '\r\n';
    }
    count ++;
  });
  obj_readline.on('close', () => {
    fs.writeFileSync(path, str);
  });
}