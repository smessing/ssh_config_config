require 'json'
require 'optparse'

# SSH Config Config - a configuration toolkit for your ssh configuration!
# Helps manage keeping a uniform naming for ssh targets across multiple
# machines.
#
# Written by Samuel Messing <samuel.messing+ssh_config_config@gmail.com>

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ssh_config_config config_file"
  opts.on("-v", "--verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
end.parse!

if ARGV.empty? or ARGV.one?
  puts "Must specify both config file and ssh directory."
  exit
end

config_file = File.open(ARGV[0])
config = config_file.read
config = JSON.parse(config)

config.each do |destination|
  puts destination
end

