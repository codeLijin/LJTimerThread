Pod::Spec.new do |s|
s.name         = "LJTimerThread" //库名字
s.version      = "1.0.0" //库版本号
s.ios.deployment_target = '9.0'
s.summary      = "thread manager of timer" //库的简介
s.homepage     = "https://github.com/codeLijin/LJTimerThread.git" // 库的github地址
s.license      = "MIT" // license 创建git仓库时勾选的
s.author             = { "author" => "lijin19920905@foxmail.com" }// 库的作者
s.social_media_url   = "https://github.com/codeLijin/LJTimerThread.git"
s.source       = { :git => "https://github.com/codeLijin/LJTimerThread.git", :tag => s.version }
s.source_files  = "LJTimerThread" // 暴露给用户的库文件所在文件夹
s.requires_arc = true // ARC
end
