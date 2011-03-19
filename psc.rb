# Finds PuTTy sessions and lets you select one from command line without needing
# to bring up the PuTTy session chooser GUI.
#
# Note: putty command must be in Windows PATH !

begin
  require 'rubygems'  # for 1.8.7 compatability
  require 'win32/process'
rescue LoadError => e
  puts "You need rubygems and the win32-process gem installed to run this."
  exit
end

reg_query = "HKCU\\Software\\SimonTatham\\PuTTy\\Sessions"
raw_sessions = %x{reg query #{reg_query}}
unfiltered_sessions = raw_sessions.split "\n"
sessions = unfiltered_sessions.find_all { |s| s =~ /^HKEY.*/ }
  .map { |s| s.split("Sessions\\")[1] }
  .reject { |s| s.nil? }
  .map { |s| s.gsub "%20", " " }
puts "0. Quit this program"
sessions.each_with_index do |sess_name, idx|
  puts "#{idx+1}. #{sess_name}"
end
print "Choose session: "
choice = gets.strip.to_i - 1

exit if choice == -1

sess_name = sessions[choice]
Process.create :app_name => "putty -load \"#{sess_name}\""
