##########################################
# Code  : Blockmesh Bot v.0.1 ruby 3.1.3 #
# Author: Kazuha787 (dune)               #
# Github: https://github.com/kazuha787/  #
# Tg    : https://t.me/Offical_im_kazuha #
##########################################

require 'net/http'
require 'json'
require 'uri'
require 'colorize'
require 'securerandom'
require 'websocket-client-simple'

# Color codes
RED = "\e[31m"
BLUE = "\e[34m"
GREEN = "\e[32m"
YELLOW = "\e[33m"
RESET = "\e[0m"

$email_input = nil
$password_input = nil
$api_token = nil

# Display coder sign
def coder_mark
  puts <<~HEREDOC
    #{GREEN}--------------------------------------
    #{YELLOW}[+]#{RED} BlockMesh Network Bot v0.1.1 #{RESET}
    #{GREEN}--------------------------------------
    #{YELLOW}[+]#{BLUE} https://github.com/Kazuha787/
    #{GREEN}--------------------------------------#{RESET}
  HEREDOC
end

# Get public IP
def get_public_ip
  uri = URI("https://api.ipify.org")
  Net::HTTP.get(uri).strip
end

# Get IP information
def get_ip_info(ip_address)
  uri = URI("https://ipwhois.app/json/#{ip_address}")
  response = Net::HTTP.get_response(uri)
  return JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  nil
end

# Connect WebSocket
def connect_websocket
  return unless $api_token
  begin
    ws = WebSocket::Client::Simple.connect("wss://ws.blockmesh.xyz/ws?email=#{$email_input}&api_token=#{$api_token}")
    puts "[#{Time.now.strftime('%H:%M:%S')}] Connected to WebSocket".yellow
    ws.close
  rescue => e
    puts "[#{Time.now.strftime('%H:%M:%S')}] WebSocket connection failed: #{e}".red
  end
end

# Submit bandwidth data
def submit_bandwidth(ip_info)
  return unless ip_info && $api_token

  payload = {
    email: $email_input,
    api_token: $api_token,
    download_speed: rand(0.0..10.0).round(16),
    upload_speed: rand(0.0..5.0).round(16),
    latency: rand(20.0..300.0).round(16),
    city: ip_info['city'] || 'Unknown',
    country: ip_info['country_code'] || 'XX',
    ip: ip_info['ip'] || '',
    asn: ip_info['asn']&.gsub('AS', '') || '0',
    colo: 'Unknown'
  }.to_json

  uri = URI("https://app.blockmesh.xyz/api/submit_bandwidth")
  Net::HTTP.post(uri, payload, { 'Content-Type' => 'application/json' })
end

# Get and submit task
def get_and_submit_task(ip_info)
  return unless ip_info && $api_token

  uri = URI("https://app.blockmesh.xyz/api/get_task")
  response = Net::HTTP.post(uri, { email: $email_input, api_token: $api_token }.to_json, { 'Content-Type' => 'application/json' })
  return unless response.is_a?(Net::HTTPSuccess)

  task_data = JSON.parse(response.body)
  return unless task_data && task_data.key?('id')

  sleep(rand(60..120))

  submit_url = URI("https://app.blockmesh.xyz/api/submit_task")
  params = {
    email: $email_input,
    api_token: $api_token,
    task_id: task_data['id'],
    response_code: 200,
    country: ip_info['country_code'] || 'XX',
    ip: ip_info['ip'] || '',
    asn: ip_info['asn']&.gsub('AS', '') || '0',
    colo: 'Unknown',
    response_time: rand(200.0..600.0).round(1)
  }

  Net::HTTP.post(submit_url, params.to_json, { 'Content-Type' => 'application/json' })
end

# Authenticate (get API token)
def authenticate_direct
  return $api_token if $api_token

  uri = URI("https://api.blockmesh.xyz/api/get_token")
  data = { email: $email_input, password: $password_input }.to_json
  headers = { "Content-Type" => "application/json" }

  begin
    response = Net::HTTP.post(uri, data, headers)
    if response.is_a?(Net::HTTPSuccess)
      $api_token = JSON.parse(response.body)['api_token']
      puts "[#{Time.now.strftime('%H:%M:%S')}] Login successful!".green
      return $api_token
    else
      puts "[#{Time.now.strftime('%H:%M:%S')}] Login failed!".red
      return nil
    end
  rescue => e
    puts "[#{Time.now.strftime('%H:%M:%S')}] Login error: #{e}".red
    return nil
  end
end

# Process direct connection
def process_direct_connection
  system('clear')
  coder_mark

  # Get user input for login
  print "Enter your BlockMesh email: "
  $email_input = gets.chomp
  print "Enter your BlockMesh password: "
  $password_input = gets.chomp

  loop do
    api_token = authenticate_direct
    next unless api_token

    ip_info = get_ip_info(get_public_ip)
    puts "[#{Time.now.strftime('%H:%M:%S')}] IP Address | #{ip_info['ip']} ".green if ip_info

    connect_websocket
    sleep(rand(60..120))

    submit_bandwidth(ip_info)
    sleep(rand(60..120))

    get_and_submit_task(ip_info)
    sleep(rand(60..120))
  end
end

# Main function
def main
  system('clear')
  coder_mark
  puts "\n1. Direct Connection\n2. Proxy Connection"
  print "Choose (1/2): "
  choice = gets.chomp.to_i

  if choice == 1
    process_direct_connection
  else
    puts "Proxy mode not yet implemented."
  end
end

main if __FILE__ == $0
