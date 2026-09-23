#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint thermal_printer.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'thermal_printer_plus'
  s.version          = '1.0.11'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://codingdevs.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Coding Devs' => 'contact@codingdevs.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.static_framework = true
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Import all * .a libraries in the Classes folder
  s.frameworks = ["SystemConfiguration", "CoreTelephony","WebKit"]

  # libGSDK.a se enlaza SOLO en dispositivo.
  #
  # Sus cuatro slices (i386, armv7, x86_64, arm64) llevan LC_VERSION_MIN_IPHONEOS
  # -el marcador de dispositivo- porque se compilo con un toolchain anterior a
  # que Apple distinguiera dispositivo de simulador. El enlazador moderno la
  # rechaza en cualquier build de simulador con "Building for 'iOS-simulator',
  # but linking in object file ... built for 'iOS'", y Rosetta no salva nada:
  # la slice x86_64 tiene el mismo marcador.
  #
  # Con `vendored_libraries` el `-l"GSDK"` salia incondicional y no habia forma
  # de sacarlo por SDK. En simulador las tres clases que el plugin instancia las
  # aporta Classes/GSDKSimulatorStubs.m.
  #
  # Lo condicional son DOS VARIABLES AUXILIARES, no los ajustes reales, y la
  # diferencia no es cosmetica: en un xcconfig la asignacion condicional gana
  # ENTERA sobre la incondicional del mismo ajuste, y `$(inherited)` no trae el
  # valor de al lado sino el del nivel de abajo. Escribir
  # `OTHER_LDFLAGS[sdk=iphoneos*] = -l"GSDK"` dejaba al target de la app con esa
  # unica bandera y borraba las ~200 que CocoaPods genera: el build de
  # dispositivo moria con `Undefined symbol: _WebPPictureFree` y cien mas, todos
  # de pods que no tienen nada que ver con la impresora. Por eso OTHER_LDFLAGS y
  # LIBRARY_SEARCH_PATHS quedan incondicionales -CocoaPods los fusiona con lo
  # suyo- y lo que cambia por SDK es el contenido de $(GSDK_LDFLAGS) y
  # $(GSDK_LIB_DIR), vacios en simulador.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'GSDK_LDFLAGS[sdk=iphoneos*]' => '-l"GSDK"',
    'GSDK_LIB_DIR[sdk=iphoneos*]' => '"$(PODS_TARGET_SRCROOT)/ios"',
    'OTHER_LDFLAGS' => '$(GSDK_LDFLAGS)',
    'LIBRARY_SEARCH_PATHS' => '$(GSDK_LIB_DIR)',
  }
  s.user_target_xcconfig = {
    'GSDK_LDFLAGS[sdk=iphoneos*]' => '-l"GSDK"',
    'GSDK_LIB_DIR[sdk=iphoneos*]' => '"$(PODS_ROOT)/../.symlinks/plugins/thermal_printer_plus/ios"',
    'OTHER_LDFLAGS' => '$(GSDK_LDFLAGS)',
    'LIBRARY_SEARCH_PATHS' => '$(GSDK_LIB_DIR)',
  }
  # s.swift_version = '5.0'
end
