# ApiDemo

If you run the command `make` this will build the included Swift package, and
then attempt to use `swift-api-extract` command available on the daily builds
from Swift and will crash as it is unable to resolve the native library
dependency (it wants a SwiftModule, but there is none for the C code):

```
swift-api-extract -sdk `xcrun --show-sdk-path` `pwd`/.build/debug/ApiDemo.swiftmodule  -module-name ApiDemo
<unknown>:0: error: missing required module 'NativeDep'
Assertion failed: (!Files.empty() && "No files added yet"), function getMainFile, file /Users/buildnode/jenkins/workspace/oss-swift-package-macos/swift/include/swift/AST/FileUnit.h, line 423.
PLEASE submit a bug report to https://bugs.llvm.org/ and include the crash backtrace.
Stack dump:
0.	Program arguments: swift-api-extract -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk /tmp/demo/.build/debug/ApiDemo.swiftmodule -module-name ApiDemo
1.	Apple Swift version 5.4-dev (LLVM 798a505f5bc4a05, Swift 7f7978370b08812)
2.	While evaluating request APIGenRequest(Generate TBD for module ApiDemo.ApiDemo)
Stack dump without symbol names (ensure you have llvm-symbolizer in your PATH or set the environment var `LLVM_SYMBOLIZER_PATH` to point to it):
0  swift-api-extract        0x000000010a1326f7 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) + 39
1  swift-api-extract        0x000000010a1318b5 llvm::sys::RunSignalHandlers() + 85
2  swift-api-extract        0x000000010a132d16 SignalHandler(int) + 262
3  libsystem_platform.dylib 0x00007fff204b4d7d _sigtramp + 29
4  libsystem_platform.dylib 000000000000000000 _sigtramp + 18446603339974357664
5  libsystem_c.dylib        0x00007fff203c3720 abort + 120
6  libsystem_c.dylib        0x00007fff203c29d6 err + 0
7  swift-api-extract        0x000000010a511bc3 APIGenRecorder::APIGenRecorder(swift::apigen::API&, swift::ModuleDecl*) (.cold.1) + 35
8  swift-api-extract        0x000000010630acab APIGenRecorder::APIGenRecorder(swift::apigen::API&, swift::ModuleDecl*) + 363
9  swift-api-extract        0x0000000106308578 swift::APIGenRequest::evaluate(swift::Evaluator&, swift::TBDGenDescriptor) const + 184
10 swift-api-extract        0x00000001063106dd swift::SimpleRequest<swift::APIGenRequest, swift::apigen::API (swift::TBDGenDescriptor), (swift::RequestFlags)1>::evaluateRequest(swift::APIGenRequest const&, swift::Evaluator&) + 77
11 swift-api-extract        0x000000010630f1bf llvm::Expected<swift::APIGenRequest::OutputType> swift::Evaluator::getResultUncached<swift::APIGenRequest>(swift::APIGenRequest const&) + 383
12 swift-api-extract        0x00000001063087e0 swift::writeAPIJSONFile(swift::ModuleDecl*, llvm::raw_ostream&, bool) + 224
13 swift-api-extract        0x00000001056fda75 SwiftAPIExtractInvocation::extractAPI() + 741
14 swift-api-extract        0x00000001056fbb1a swift_api_extract_main(llvm::ArrayRef<char const*>, char const*, void*) + 602
15 swift-api-extract        0x00000001056ea412 run_driver(llvm::StringRef, llvm::ArrayRef<char const*>) + 3634
16 swift-api-extract        0x00000001056e8ee6 main + 566
17 libdyld.dylib            0x00007fff2048b621 start + 1
18 libdyld.dylib            0x0000000000000006 start + 18446603339974527462
```

If you go back one commit in history, before the native library is added,
you can see the tool working as expected.
