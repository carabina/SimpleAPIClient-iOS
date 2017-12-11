use_frameworks!
ENV['FORK_XCODE_WRITING'] = "true" 

def pods
    pod 'Alamofire', '~> 4.0'
end

target 'APIClient' do
	pods
    
    target 'APIClientTests' do
        inherit! :search_paths
    end
end
