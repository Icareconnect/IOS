# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'RoyoConsultantVendor' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for RoyoConsultantVendor
  pod 'FBSDKLoginKit'               # FBLogin
  pod 'GoogleSignIn'                # Google login
  pod 'Moya'                        # Networking APIs (internally using Alamofire)
  pod 'Firebase/Messaging'          # Notifications
  pod 'SwiftEntryKit'               # Error Alerts
  pod 'Nuke'                        # Image Caching and loading
  pod 'IQKeyboardManagerSwift'      # Keyboard textfield distance handling and Done accessory
  pod 'Socket.IO-Client-Swift'      # Chat Sockets
#  pod 'CountryList'                 # Country Picker
  pod 'SZTextView'                  # UITextView with placeholder
  pod 'lottie-ios'                  # Custom JSON Loaders
  pod 'JVFloatLabeledTextField'     # Floating Placeholder textfield
  pod 'ScrollableGraphView'         # To show graph in Revenue screen
  pod 'Firebase/Analytics'
  pod 'JitsiMeetSDK'
  pod 'GooglePlaces'                # Tracking
  pod 'GoogleMaps'                  # Tracking
  pod 'Firebase/DynamicLinks'       # Deep Linking
  pod 'Lightbox'

  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['ENABLE_BITCODE'] = 'NO'
          end
      end
  end
end
