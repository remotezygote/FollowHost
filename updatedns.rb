#!/usr/local/bin/ruby
require 'route53'
require 'optparse'
options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: updatedns -a ACCESS_KEY -s SECRET_KEY -n HOSTNAME"
  options[:access_key] = false
  opts.on( '-a', '--access_key KEY', 'AWS Access Key' ) do |key|
    options[:access_key] = key
  end
  options[:secret_key] = false
  opts.on( '-s', '--secret_key KEY', 'AWS Secret Key' ) do |key|
    options[:secret_key] = key
  end
  options[:fqdn] = false
  opts.on( '-n', '--host HOST', 'Hostname to update' ) do|host|
    options[:fqdn] = host << "."
  end
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end
optparse.parse!
if options[:access_key] && options[:secret_key] && options[:fqdn]
  domain = options[:fqdn].gsub(/^[^\.]+\./,'')
  conn = Route53::Connection.new(options[:access_key],options[:secret_key]) #opens connection
  zone = conn.get_zones.select{|z| z.name == domain}[0]
  if zone
    record = zone.get_records.select{|r| r.name == options[:fqdn]}[0]
    if record
      ip = (require 'open-uri' ; open("http://myip.dk") { |f| /([0-9]{1,3}\.){3}[0-9]{1,3}/.match(f.read)[0] })
      resp = record.update(options[:fqdn],"A","900",[ip])
      if !resp.error?
        puts "[#{Time.now.to_s}] Successfully set DNS for #{options[:fqdn].gsub(/\.$/,'')} to #{ip}"
      else
        puts "[#{Time.now.to_s}] Failed to set DNS for #{options[:fqdn].gsub(/\.$/,'')}: #{resp.error_message}"
      end
    else
      puts "[#{Time.now.to_s}] Failed to set DNS for #{options[:fqdn].gsub(/\.$/,'')}: Could not locate host record"
    end
  else
    puts "[#{Time.now.to_s}] Failed to set DNS for #{options[:fqdn].gsub(/\.$/,'')}: Could not locate zone"
  end
else
  puts "[#{Time.now.to_s}] Failed to set DNS!"
end