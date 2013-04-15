task :default => [:build]

task :setup do
  sh "mkdir -p lib"
  sh "wget -O lib/browserlib.js https://raw.github.com/STRd6/browserlib/pixie/game.js"
  sh "wget -O lib/10_gamelib.js https://raw.github.com/PixieEngine/PixieDust/pixie/game.js"
  sh "mkdir -p src"
end

task :clean do
  `rm -r build`
end

task :build do
  main_file = "src/main.coffee"
  src_files = (Dir["src/**/*.coffee"] - [main_file]) + [main_file]

  sh "mkdir -p build"
  sh "coffee", "-bcj", "build/src.js", *src_files
  sh "cat lib/*.js build/src.js > game.js"
end

task :dist => [:build] do
  `rm -r #{dist_dir}`
  sh "mkdir -p #{dist_dir}"
  sh "cp run.html #{dist_dir}/index.html"

  %w[images music stylesheets sounds].each do |dir|
    sh "cp -R #{dir} #{dist_dir}/#{dir}"
  end

  # Remove larger source images
  sh "find #{dist_dir}/images -name '*@[248]x.png' -delete"

  %w[jquery.min.js game.js].each do |file|
    sh "cp #{file} #{dist_dir}/#{file}"
  end
end

task :chrome_webstore => :dist do
  sh "mkdir -p #{dist_dir}/webstore && cp -r webstore/* #{dist_dir}/webstore"
  sh "cp manifest.json #{dist_dir}"

  # Remove old zip
  `rm build/#{dist_name}.zip`
  # Zip
  sh "cd #{dist_dir} && zip -r #{dist_name}.zip . && mv #{dist_name}.zip ../chrome-webstore.zip"
end

namespace :package do
  # Package for direct download
  task :download do
    `rm build/#{dist_name}.zip`
    sh "cd #{dist_dir} && zip -r #{dist_name}.zip . && mv #{dist_name}.zip .."
  end
end

# Compiles all sources separately to tmp so we can see good line numbers for errors
task :compile_for_errors do
  sh "coffee -o tmp -c src/*.coffee src/**/*.coffee"
end

def dist_name
  "laserhog"
end

def dist_dir
  "build/#{dist_name}"
end
