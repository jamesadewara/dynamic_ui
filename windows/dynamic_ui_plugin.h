#ifndef FLUTTER_PLUGIN_DYNAMIC_UI_PLUGIN_H_
#define FLUTTER_PLUGIN_DYNAMIC_UI_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace dynamic_ui {

class DynamicUiPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DynamicUiPlugin();

  virtual ~DynamicUiPlugin();

  // Disallow copy and assign.
  DynamicUiPlugin(const DynamicUiPlugin&) = delete;
  DynamicUiPlugin& operator=(const DynamicUiPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace dynamic_ui

#endif  // FLUTTER_PLUGIN_DYNAMIC_UI_PLUGIN_H_
