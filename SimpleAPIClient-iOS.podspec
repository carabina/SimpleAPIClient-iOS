ENV['FORK_XCODE_WRITING'] = "true"

Pod::Spec.new do |s|
  s.name = 'SimpleAPIClient-iOS'
  s.version = '0.1.2'
  s.summary = 'Network Client for iOS Projects'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'rich@richappz.com' => 'rich@richappz.com' }
  s.homepage = 'https://github.com/RichAppz/CryptoWatch-Client.git'
  s.ios.deployment_target = '10.0'
  s.frameworks = 'CoreData'
  s.requires_arc = true
  
  s.source = { :git => 'https://github.com/RichAppz/SimpleAPIClient-iOS.git', :tag => s.version }
  s.source_files = 'APIClient/**/*.{swift}', 'APIClient/DataModel.xcdatamodeld', 'APIClient/DataModel.xcdatamodeld/*.xcdatamodel'
  s.resources = ['APIClient/*.xcdatamodeld', 'APIClient/*.xcdatamodeld/*.xcdatamodel']
  s.dependency 'Alamofire', '~> 4.0'

end 
