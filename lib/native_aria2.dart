import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart' as ffi;
import 'dart:isolate';


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

final int Function(Pointer<Char>, Pointer<NativeFunction<Int32 Function(Int32)>>) nativeAria2c = _dylib
    .lookup<NativeFunction<Int32 Function(Pointer<Char>, Pointer<NativeFunction<Int32 Function(Int32)>>)>>('aria2c')
    .asFunction();

Future<int> aria2c(String url) async {
  final Pointer<ffi.Utf8> urlPtr = url.toNativeUtf8();
  final int result = nativeAria2c(urlPtr.cast<Char>(), Pointer.fromFunction<Int32 Function(Int32)>(callback, 13));
  ffi.calloc.free(urlPtr);
  return result;
}

int callback(int i) {
  print('normalSyncCallback called: $i');
  return i;
}

// Future<int> aria2cAsync(String url) async {
//   final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
//   final int requestId = _nextSumRequestId++;
//   final _SumRequest request = _SumRequest(requestId, a, b);
//   final Completer<int> completer = Completer<int>();
//   _sumRequests[requestId] = completer;
//   helperIsolateSendPort.send(request);
//   return completer.future;
// }