#
# Be sure to run `pod lib lint CSTip.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name         = "CSTip"
    s.version      = "1.0"
    s.summary      = "View Tip"
    s.description  = <<-DESC
                        Empty UITableView/UIView Tip
                     DESC

  s.homepage     = "https://github.com/youyuedu/CSTip"
  s.license      = 'MIT'
  s.author       = { "winddpan" => "winddpan@126.com" }
  s.source       = { :git => "https://github.com/youyuedu/CSTip.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'CSTip' => ['Pod/Assets/*.png']
  }

  s.frameworks = 'UIKit', 'Foundation'
  s.dependency "Aspects"
end
