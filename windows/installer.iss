; 绵阳市中职共建题库 —— Windows 安装器（Inno Setup）
;
; 为什么要有安装器：zip 分发包要求用户"解压后运行整个目录里的 exe，不能只拷 exe"，
; 还得自己建桌面快捷方式；缺 MSVC 运行时的话更是双击毫无反应。安装器把这三件事
; 一次做掉：装到固定位置、建桌面/开始菜单快捷方式、把 C 运行时随包带上。
;
; **C 运行时是 app-local 部署**（见 CI 里拷 msvcp140/vcruntime140 那步），
; 不调 vc_redist.exe —— 那会多一次 UAC 与一次可能的失败点，而微软明确允许
; 把这三个 dll 随应用一起分发。这也是"别的电脑打不开"的根治办法。
;
; 版本号与源目录由 CI 用 /D 传入，本文件不写死：
;   iscc /DAppVersion=1.2.3 /DSourceDir=..\build\windows\x64\runner\Release installer.iss
; 直接在本机手工编译时走下面的默认值。

#ifndef AppVersion
  #define AppVersion "0.0.0-dev"
#endif
#ifndef SourceDir
  #define SourceDir "..\build\windows\x64\runner\Release"
#endif

// exe 自身的版本属性（右键 → 属性 → 详细信息）。**必须是纯数字**，Inno 不接受
// "1.0.1-dev" 这种带后缀的写法，格式不对会直接编译失败。CI 那边做了兜底转换。
#ifdef NumericVersion
  #define FileVersion NumericVersion
#else
  #define FileVersion "0.0.0"
#endif

#define AppName "绵阳市中职共建题库"
#define AppExeName "mianyang_quiz.exe"
#define AppPublisher "绵阳市中职共建题库"

[Setup]
; AppId 必须**永远不变** —— 换了它，新版本会被当成另一个软件并排装，而不是覆盖升级。
AppId={{8F3A7C21-5B4E-4D9A-9E17-2C6D4A8B1F03}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
VersionInfoVersion={#FileVersion}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
OutputDir=..\build\dist
OutputBaseFilename=mianyang_quiz-windows-x64-setup
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
; 学校机房多半没有管理员权限，默认按**当前用户**装（落在 %LOCALAPPDATA%\Programs），
; 不弹 UAC。需要装给所有人的可以在这页切换。
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
; 客户端是 64 位，装到 32 位系统上跑不起来，直接在入口挡掉
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\{#AppExeName}

#ifndef MessagesFile
  ; 本机手工编译时的默认值（Inno 自带的英文界面）
  #define MessagesFile "compiler:Default.isl"
#endif

[Languages]
; 界面语言由 CI 用 /DMessagesFile=… 决定。
; **中文语言文件不在 Inno 官方发行版里**（官方翻译只到土耳其语），CI 会从 issrc 仓库下下来；
; 下载失败就退回英文界面 —— 安装器照常能装，不该为一个翻译文件卡死整条发布链。
;
; 这段判断刻意放在 PowerShell 里而不是用 ISPP 的 FileExists：CI 里一行 Test-Path 就够，
; 不必依赖 ISPP 某个预定义变量在本版本里是否可用。
Name: "default"; MessagesFile: "{#MessagesFile}"

[Tasks]
Name: "desktopicon"; Description: "创建桌面快捷方式"; GroupDescription: "附加任务："

[Files]
; 整个 Release 目录一起装：exe 只是入口，同目录下的 flutter_windows.dll、
; 各插件 dll 与 data\ 缺一不可（zip 分发最容易踩的就是"只拷了 exe"）。
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"
Name: "{group}\卸载 {#AppName}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExeName}"; Description: "立即运行 {#AppName}"; Flags: nowait postinstall skipifsilent
