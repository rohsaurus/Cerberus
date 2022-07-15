//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <dargon2_flutter_desktop/dargon2_flutter_desktop_plugin.h>
#include <fast_rsa/fast_rsa_plugin.h>
#include <flutter_acrylic/flutter_acrylic_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  Dargon2FlutterDesktopPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("Dargon2FlutterDesktopPlugin"));
  FastRsaPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FastRsaPlugin"));
  FlutterAcrylicPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterAcrylicPlugin"));
}
