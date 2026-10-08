#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  // Window title (also what Taskbar / Task Manager show).
  //
  // Built from code points instead of a literal on purpose: this file is plain
  // ASCII and the CMake setup does not pass /utf-8, so a raw CJK literal could be
  // decoded with the local ANSI codepage and turn into mojibake. Code points are
  // immune to that. Same string as Dart's _appTitle and Android's android:label.
  // Above: U+804C U+6559 U+9AD8 U+8003 U+8054 U+76DF = the product name in
  // Chinese ("ZhiJiao GaoKao LianMeng") -- the same string as Dart's _appTitle,
  // Android's android:label and the installer's AppName.
  //
  // This comment stays ASCII on purpose: /W4 /WX turns C4819 (a CJK character the
  // local code page cannot represent) into a build error unless CL=/utf-8 is set,
  // which is exactly why the title itself is built from code points.
  const std::wstring window_title = {0x804C, 0x6559, 0x9AD8,
                                     0x8003, 0x8054, 0x76DF};
  if (!window.Create(window_title, origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
