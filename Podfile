# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'ShanYanAppStoreDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ShanYanAppStoreDemo
#pod 'CL_ShanYanSDK', '~> 2.3.1.0'
pod 'SnapKit'
pod 'Masonry', '~> 1.1.0'
pod 'Alamofire'
pod 'SwiftyJSON'
pod 'Bugly', '~> 2.5.0'
pod 'Kingfisher'
pod 'CryptoSwift'
pod 'PKHUD'
pod 'CocoaSecurity'
pod 'Hero'
pod 'IQKeyboardManagerSwift'

pod 'AFNetworking', '~> 4.0.1'
pod 'SVProgressHUD'
pod 'ChameleonFramework'
pod 'lottie-ios', '~> 2.5.3'
pod 'YYModel'

  target 'ShanYanAppStoreDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ShanYanAppStoreDemoUITests' do
    inherit! :search_paths
    # Pods for testing
  end


end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
