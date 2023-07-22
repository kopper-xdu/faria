import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart' as ffi;

const String _libName = 'native_aria2';

final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

final int Function(Pointer<Char>) nativeAria2c = _dylib
    .lookup<NativeFunction<Int32 Function(Pointer<Char>)>>('aria2c')
    .asFunction();

Future<int> aria2c(String url) async {
  final Pointer<ffi.Utf8> urlPtr = url.toNativeUtf8();
  final int result = nativeAria2c(urlPtr.cast<Char>());
  ffi.calloc.free(urlPtr);
  return result;
}