require 'as2'

ENV['AS2_HOST'] || raise('must set AS2_HOST')

As2.configure do |conf|
  conf.name = 'MyClient'
  conf.url = "http://#{ENV['AS2_HOST']}/as2"
  conf.certificate = 'test/certificates/client.crt'
  conf.pkey = 'test/certificates/client.key'
  conf.domain = 'mydomain.com'
  conf.add_partner do |partner|
    partner.name = 'MyServer'
    partner.url = "http://#{ENV['AS2_HOST']}/as2"
    partner.certificate = 'test/certificates/server.crt'
  end
end

client = As2::Client.new 'MyServer'
result = client.send_file(ARGV.first)
p result
