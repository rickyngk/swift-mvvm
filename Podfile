source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'mvvm-demo' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for mvvm-demo
  
  #Rx
  pod 'RxSwift',    '~> 2.0'
  pod 'RxCocoa',    '~> 2.0'
  
  #Realm
  pod 'RealmSwift'
  
  #Alamofire
  pod 'Alamofire'
  pod 'RxAlamofire'

  target 'mvvm-demoTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', '~> 2.0'
    pod 'RxTests',    '~> 2.0'
  end

  target 'mvvm-demoUITests' do
    inherit! :search_paths
  end

end
