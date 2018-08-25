# coding: utf-8
require 'slack-ruby-client'
require 'net/https'
require 'json'

SLACK_TOKEN = 'xoxp-420428523623-424061473830-424472809318-3ed26f472a1707ac3721c1370a22f13b'
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

realtime_client = Slack::RealTime::Client.new
realtime_client.on :hello do
    puts 'connected!'
end

client = Slack::Web::Client.new
puts client.auth_test

realtime_client.on :message do |data|
  if data.thread_ts then
    thinfo = client.channels_replies(
      channel: data['channel'],
      thread_ts: data['thread_ts']
    )
    base_message = thinfo.messages[0].text
    if md = base_message.match(/\*(problem|reply to)\s*(\d+):.*/) then
      issue_no = md[2]
      puts issue_no
      #apipost(issue_no,data['text'])
      client.reactions_add(
        name: "thumbsup",
        channel: data['channel'],
        timestamp: data['ts']
      )
    end
  else
    begin
      if data['text'].start_with?("replyto") then
        str = data['text'].match(/^replyto\s*(\d+):(.+)/)
        #apipost(str[1],str[2])
        client.reactions_add(
          name: "thumbsup",
          channel: data['channel'],
          timestamp: data['ts']
        )
      end
    rescue NoMethodError => e
    end
  end
end

realtime_client.start!

