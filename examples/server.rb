require 'as2'
require 'rack'

ENV['AS2_HOST'] || raise('must set AS2_HOST')

As2.configure do |conf|
  conf.name = 'MyServer'
  conf.url = "http://#{ENV['AS2_HOST']}/as2"
  conf.certificate = 'test/certificates/server.crt'
  conf.pkey = 'test/certificates/server.key'
  conf.domain = 'mydomain.com'
  conf.add_partner do |partner|
    partner.name = 'MyClient'
    partner.url = "http://#{ENV['AS2_HOST']}/as2"
    partner.certificate = 'test/certificates/client.crt'
  end
end

handler = As2::Server.new do |filename, body|
  puts "SUCCESSFUL DOWNLOAD"
  puts "FILENAME: #{filename}"
  puts
  puts body

  file = File.new("/tmp/#{filename}", 'w+')
  file.write(body)
  file.close
end

builder = Rack::Builder.new do
  use Rack::CommonLogger

  map '/status' do
    run ->(env) {[200, {'Content-Type' => 'text/plain'}, ['Okay']] }
  end

  map '/as2' do
    run handler
  end
end

puts "As2 version: #{As2::VERSION}"
Rack::Handler::Thin.run builder, Host: '0.0.0.0', Port: 3000
