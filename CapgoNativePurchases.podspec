require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

def has_storekit_265_sdk?
  sdk_roots = [
    ENV['SDKROOT'],
    ENV['DEVELOPER_DIR'] && File.join(ENV['DEVELOPER_DIR'], 'Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk'),
    '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk'
  ].compact

  sdk_roots.any? do |sdk_root|
    module_path = File.join(
      sdk_root,
      'System/Library/Frameworks/StoreKit.framework/Modules/StoreKit.swiftmodule'
    )
    Dir[File.join(module_path, '*.swiftinterface')].any? do |path|
      contents = File.read(path)
      contents.include?('BillingPlanType') && contents.include?('pricingTerms')
    rescue StandardError
      false
    end
  end
end

Pod::Spec.new do |s|
  s.name = 'CapgoNativePurchases'
  s.version = package['version']
  s.summary = package['description']
  s.license = package['license']
  s.homepage = package['repository']['url']
  s.author = package['author']
  s.source = { :git => package['repository']['url'], :tag => s.version.to_s }
  s.source_files = 'ios/Sources/**/*.{swift,h,m,c,cc,mm,cpp}'
  s.exclude_files = '**/node_modules/**/*', '**/examples/**/*'
  s.ios.deployment_target = '15.0'
  s.dependency 'Capacitor'
  s.swift_version = '5.1'
  s.pod_target_xcconfig = {
    'OTHER_SWIFT_FLAGS' => has_storekit_265_sdk? ? '$(inherited) -D STOREKIT_26_5' : '$(inherited)'
  }
end
