#!/usr/bin/ruby --disable=gems

if ARGV.length == 0
  puts "build.rb <semver.bash option>"
  puts "build.rb <-M|-m|-p|-s|-d>"
  exit 1
end

semver_option = ARGV[0]
script = "aliaser.sh"
tmp_script = "tmp.aliaser.build"

unless File.exist?(script)
  puts "Can't find #{script} in #{pwd}"
  exit 1
end

shellcheck_result = `shellcheck #{script}`
if $?.exitstatus > 0
  puts "'#{script}' encountered shellcheck errors."
  exit 1
end

shfmt_result = `shfmt #{script}`
if $?.exitstatus == 0
   # File.open(tmp_script, 'w') { |file| file.write(shfmt_result) }
   File.write(tmp_script, shfmt_result)
else
  puts "Shfmt encountered an error processing '#{script}'."
  exit 1
end

# check if version exists
# ...
version = File.read("version")
updated_version = `bin/semver.bash #{semver_option} #{version}`

# check if updated_version has a value
# ...

# File.open(script, "w") do |scriptfile|
#   scriptfile.write(shfmt_result)
# end

# replace version in script
# match/replace "##:: aliaser-version=v2.1.0" or variation
script_collector = []
File.open(tmp_script, "a+").each_line do |scriptline|
  if scriptline =~ /aliaser-version=v.*$/
    scriptline = "##:: aliaser-version=#{updated_version}"
  end
  script_collector.append(scriptline)
end

collected_file = script_collector.join()
File.write(script, collected_file)
File.write("version", updated_version)
File.delete(tmp_script)
