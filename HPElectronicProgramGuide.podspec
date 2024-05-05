#
# Be sure to run `pod lib lint HPElectronicProgramGuide.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HPElectronicProgramGuide'
  s.version          = '1.0.1'
  s.summary          = 'A powerful EPG (Electronic Program Guide) UI library for iOS in Swift. Create stunning program guide interfaces with ease.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'A powerful EPG (Electronic Program Guide) UI library for iOS in Swift. Create stunning program guide interfaces with ease.'

  s.homepage         = 'https://github.com/phhai1710/HPElectronicProgramGuide'
  s.screenshots     = 'https://raw.githubusercontent.com/phhai1710/HPElectronicProgramGuide/develop/Resources/screenshot1.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hai Pham' => 'phhai1710@gmail.com' }
  s.source           = { :git => 'https://github.com/phhai1710/HPElectronicProgramGuide.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'HPElectronicProgramGuide/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HPElectronicProgramGuide' => ['HPElectronicProgramGuide/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
