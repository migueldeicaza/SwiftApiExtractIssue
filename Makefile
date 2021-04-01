dump-api:
	swift build -Xswiftc -target -Xswiftc x86_64-apple-macosx10.11
	swift-api-extract -F .build/debug/ -sdk `xcrun --show-sdk-path` `pwd`/.build/debug/ApiDemo.swiftmodule  -module-name ApiDemo

