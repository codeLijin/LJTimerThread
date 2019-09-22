Pod::Spec.new do |s|
  s.name         = 'LJTimerThread'
  s.version      = '1.0.0'
  s.ios.deployment_target = '9.0'
  s.summary      = 'thread manager of timer'
  s.homepage     = 'https://github.com/codeLijin/LJTimerThread'
  s.author       = { 'author' => 'lijin19920905@foxmail.com' }
  s.social_media_url   = "https://github.com/codeLijin/LJTimerThread"
  s.source       = { :git => 'https://github.com/codeLijin/LJTimerThread', :tag => s.version }
  s.requires_arc = true
  s.source_files = 'LJTimerThread'
  s.license      = "MIT"

  s.description  = 'LJTimerThread is a simple manager for timer task on iOS.' \
                   'Author lijin.'
end
