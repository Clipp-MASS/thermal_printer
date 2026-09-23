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
  # de sacarlo por SDK, asi que las banderas se escriben a mano condicionadas a
  # `[sdk=iphoneos*]`. En simulador las tres clases que el plugin instancia las
  # aporta Classes/GSDKSimulatorStubs.m.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'LIBRARY_SEARCH_PATHS[sdk=iphoneos*]' => '"$(PODS_TARGET_SRCROOT)/ios"',
    'OTHER_LDFLAGS[sdk=iphoneos*]' => '-l"GSDK"',
  }
  s.user_target_xcconfig = {
    'LIBRARY_SEARCH_PATHS[sdk=iphoneos*]' => '"$(PODS_ROOT)/../.symlinks/plugins/thermal_printer_plus/ios"',
    'OTHER_LDFLAGS[sdk=iphoneos*]' => '-l"GSDK"',
  }
  # s.swift_version = '5.0'
end
