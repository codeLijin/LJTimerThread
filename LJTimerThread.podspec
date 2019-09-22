Pod::Spec.new do |s|
  s.name         = 'LJTimerThread'
  s.version      = '1.0.0'
  s.summary      = 'thread manager of timer'
  s.homepage     = 'https://github.com/codeLijin/LJTimerThread.git'
  s.authors      = { 'author' => 'lijin19920905@foxmail.com' }
  s.source       = { :git => 'https://github.com/codeLijin/LJTimerThread.git', :tag => s.version }
  s.requires_arc = true
  s.source_files = 'LJTimerThread'
  s.license      = "LICENSE"

  s.description  = 'LJTimerThread is a simple manager for timer task on iOS.' \
                   'Author lijin.'
end
