platform :ios, '13.0'
use_frameworks!

target 'iBudget' do
  pod 'ChartProgressBar', '~> 1.0'
  pod 'DatePickerDialog'
  pod 'Popover'
  pod "MonthYearPicker", '~> 4.0.2'
  pod 'JDStatusBarNotification'
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
