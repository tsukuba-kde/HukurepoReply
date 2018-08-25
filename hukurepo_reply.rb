# coding: utf-8
require 'slack-ruby-client'
require 'net/https'
require 'json'

SLACK_TOKEN = 'xoxb-420428523623-423792781255-UC95NdaZg2a2IRCHr5xr3m0k'
HUKUREPO_TOKEN = '1:zxQ84ySsjEVQtRBS7z38'

def apipost(problem_id,response)
  uri = URI.parse("https://bigclout-api.kde.cs.tsukuba.ac.jp/v1/problems/#{problem_id}/responses")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  res = http.start do |h|
    req = Net::HTTP::Post.new(uri.path)
    req.body = {'comment'=>response}.to_json
    req["Authorization"]=HUKUREPO_TOKEN
    req["Content-Type"]="application/json"
    h.request(req)
  end
  puts res.code
  puts res.body
end


Slack.configure do |config|
    config.token = SLACK_TOKEN
    raise 'Missing TOKEN!' unless config.token
end

client = Slack::RealTime::Client.new
client.on :hello do
    puts 'connected!'
end

client.on :message do |data|
  if data['text'].start_with?("problem:") then
    str = data['text'].match(/problem:(\d+)[,\s](.+)/)
    apipost(str[1],str[2])
    client.message channel: data['channel'], text: "Problem No.#{str[1]}, Response:#{str[2]}"
  end
end

client.start!

