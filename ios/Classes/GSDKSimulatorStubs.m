//
//  GSDKSimulatorStubs.m
//  thermal_printer_plus
//
//  libGSDK.a no tiene ninguna slice de simulador. Sus cuatro slices
//  (i386, armv7, x86_64, arm64) llevan LC_VERSION_MIN_IPHONEOS, el marcador de
//  dispositivo: es una librería estática compilada con un toolchain anterior a
//  que Apple distinguiera las dos plataformas. Por eso el enlazador la rechaza
//  con "Building for 'iOS-simulator', but linking in object file ... built for
//  'iOS'", y por eso correr el simulador bajo Rosetta tampoco ayuda — la slice
//  x86_64 tiene exactamente el mismo marcador.
//
//  El podspec pasó a enlazarla solo en `iphoneos`. Sin la librería, el código
//  del plugin se queda sin las tres clases que instancia, así que acá se
//  definen vacías para que el simulador enlace. Son las únicas tres de
//  libGSDK.a que el plugin referencia: EscCommand, TscCommand y Utils también
//  están en el .a, pero ningún archivo de Classes/ las nombra.
//
//  Esto NO devuelve la impresión en el simulador: una impresora Bluetooth no
//  se puede usar desde ahí de todos modos. Lo que devuelve es poder compilar y
//  correr el resto de la app en el simulador.
//
//  En dispositivo este archivo compila a nada y se enlaza la librería real.
//

#import <TargetConditionals.h>

#if TARGET_OS_SIMULATOR

#import "BLEConnecter.h"
#import "EthernetConnecter.h"

@implementation Connecter

- (void)connect {}
- (void)connect:(void (^)(ConnectState))connectState {
  if (connectState) connectState(CONNECT_STATE_FAILT);
}
- (void)close {}
- (void)write:(NSData *)data receCallBack:(void (^)(NSData *))callBack {}
- (void)write:(NSData *)data {}
- (void)read:(void (^)(NSData *))data {}

@end

@implementation BLEConnecter

- (void)configureTransparentServiceUUID:(NSString *)serviceUUID
                                 txUUID:(NSString *)txUUID
                                 rxUUID:(NSString *)rxUUID {}

- (void)scanForPeripheralsWithServices:(nullable NSArray<CBUUID *> *)serviceUUIDs
                               options:(nullable NSDictionary<NSString *, id> *)options
                              discover:(void (^_Nullable)(CBPeripheral *_Nullable,
                                                          NSDictionary<NSString *, id> *_Nullable,
                                                          NSNumber *_Nullable))discover {}

- (void)stopScan {}

// El simulador no tiene Bluetooth: se reporta "apagado"
// (CBManagerStatePoweredOff) en vez de dejar al llamador esperando un estado
// que nunca llega.
- (void)didUpdateState:(void (^_Nullable)(NSInteger))state {
  if (state) state(CBManagerStatePoweredOff);
}

- (void)connectPeripheral:(CBPeripheral *_Nullable)peripheral
                  options:(nullable NSDictionary<NSString *, id> *)options
                  timeout:(NSUInteger)timeout
             connectBlack:(void (^_Nullable)(ConnectState))connectState {
  if (connectState) connectState(CONNECT_STATE_FAILT);
}

- (void)connectPeripheral:(CBPeripheral *_Nullable)peripheral
                  options:(nullable NSDictionary<NSString *, id> *)options {}

- (void)closePeripheral:(nonnull CBPeripheral *)peripheral {}

- (void)write:(NSData *_Nullable)data
     progress:(void (^_Nullable)(NSUInteger, NSUInteger))progress
 receCallBack:(void (^_Nullable)(NSData *_Nullable))callBack {}

- (void)writeValue:(NSData *)data
 forCharacteristic:(nonnull CBCharacteristic *)characteristic
              type:(CBCharacteristicWriteType)type {}

@end

@implementation EthernetConnecter

- (void)connectIP:(NSString *)ip
             port:(int)port
     connectState:(void (^)(ConnectState))connectState
         callback:(void (^)(NSData *))callback {
  if (connectState) connectState(CONNECT_STATE_FAILT);
}

- (void)connectIP:(NSString *)ip
             port:(int)port
     connectState:(void (^)(ConnectState))connectState {
  if (connectState) connectState(CONNECT_STATE_FAILT);
}

@end

#endif  // TARGET_OS_SIMULATOR
