require 'json'
require 'optparse'

=begin

SSH Config Config - a configuration toolkit for your ssh configuration!
Helps manage keeping a uniform naming for ssh targets across multiple
machines.

Written by Samuel Messing <samuel.messing+ssh_config_config@gmail.com>

=end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ssh_config_config config_file ssh_dir"
  opts.on("-v", "--verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
end.parse!

if ARGV.empty? or ARGV.one?
  puts "Must specify both config file and ssh directory."
  exit
end

config_file = File.open ARGV[0]
config = config_file.read
config = JSON.parse config

current_computer = `hostname`.strip

Dir.chdir(ARGV[1]) do
  begin
    out_file = File.open 'config', 'w'
    config.each do |destination|

      indent = ""
      host = destination["host"] rescue nil
      hostname = destination["hostname"] rescue nil
      user = destination["user"] rescue nil
      keyfile = "#{current_computer}->#{host}"
      puts host
      puts hostname
      puts user
      puts keyfile

      `ssh-keygen -t rsa -b 2048 -f \"#{keyfile}"`

      out_file.write "Host #{host}\n" if host
      indent = "\t" if host

      out_file.write "#{indent}Hostname #{hostname}\n" if hostname
      indent = "\t"

      out_file.write "#{indent}User #{user}\n" if user
      out_file.write "#{indent}IdentityFile #{keyfile}\n"
      out_file.write "\n"
    end
  rescue IOError => e
    # TODO(sam): add exception handling
  ensure
    out_file.close unless out_file.nil?
  end
end

