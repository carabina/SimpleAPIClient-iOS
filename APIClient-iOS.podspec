ENV['FORK_XCODE_WRITING'] = "true"

Pod::Spec.new do |s|
  s.name = 'APIClient-iOS'
  s.version = '0.1.0'
  s.summary = 'Network Client for iOS Projects'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'rich@richappz.com' => 'rich@richappz.com' }
  s.source = { :git => 'https://github.com/RichAppz/APIClient-iOS.git', :tag => s.version }
  s.homepage = 'http://richappz.com/'
  s.ios.deployment_target = '10.0'
  s.frameworks = 'CoreData'
  s.requires_arc = true
  
  s.source_files = 'APIClient/**/*.{swift}', 'APIClient/DataModel.xcdatamodeld', 'APIClient/DataModel.xcdatamodeld/*.xcdatamodel'
  s.resources = ['APIClient/DataModel.xcdatamodeld', 'APIClient/DataModel.xcdatamodeld/*.xcdatamodel']
  s.dependency 'Alamofire', '~> 4.0'

end 
