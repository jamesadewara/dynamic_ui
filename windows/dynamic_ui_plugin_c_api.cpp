#include "include/dynamic_ui/dynamic_ui_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "dynamic_ui_plugin.h"

void DynamicUiPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  dynamic_ui::DynamicUiPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
