dump-api:
	swift build
	swift-api-extract -sdk `xcrun --show-sdk-path` `pwd`/.build/debug/ApiDemo.swiftmodule  -module-name ApiDemo

