# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'EWS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EWS
  pod 'Firebase/Core'
  pod 'Fabric', '~> 1.9.0'
  pod 'Crashlytics', '~> 3.12.0'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'Eureka'
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name == 'Eureka'
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.2'
        end
      end
    end
  end
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'GooglePlacePicker'
  pod 'TWMessageBarManager'
  
  pod 'TAPageControl'
  pod 'VGContent', :git => 'https://github.com/mojidabckuu/VGContent.git', :branch => 'UIControls'
  pod 'SVProgressHUD', '~> 2.2'
  
  
  pod 'GoogleSignIn'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'FBSDKShareKit'
  pod 'Firebase/Messaging'

end
