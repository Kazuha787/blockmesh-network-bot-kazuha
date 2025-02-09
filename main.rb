##########################################
# Code  : Blockmesh Bot v.1.0 👨‍💻💀⚡      #
# Author: Kazuha (cmalf)           #
# Github: https://github.com/Kazuha787/     #
# Tg    : https://t.me/Offical_kazuza      #
##########################################

require 'net/http'
require 'json'
require 'uri'
require 'colorize'
require 'securerandom'
require 'websocket-client-simple'

# Color codes and effects for animations
RED = "\e[31m"
GREEN = "\e[32m"
BLUE = "\e[34m"
YELLOW = "\e[33m"
CYAN = "\e[36m"
WHITE = "\e[97m"
RESET = "\e[0m"
BLINK = "\e[5m"
BOLD = "\e[1m"

# Animated banner
def hacker_banner
  system("clear")
  banner = <<~BANNER
    #{GREEN}
    ██████╗ ██╗      ██████╗  ██████╗███╗   ███╗███████╗███████╗██╗  ██╗
    ██╔══██╗██║     ██╔═══██╗██╔════╝████╗ ████║██╔════╝██╔════╝██║  ██║
    ██████╔╝██║     ██║   ██║██║     ██╔████╔██║█████╗  ███████╗███████║
    ██╔═══╝ ██║     ██║   ██║██║     ██║╚██╔╝██║██╔══╝  ╚════██║██╔══██║
    ██║     ███████╗╚██████╔╝╚██████╗██║ ╚═╝ ██║███████╗███████║██║  ██║
    ╚═╝     ╚══════╝ ╚═════╝  ╚═════╝╚═╝     ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝
    #{RESET}
  BANNER

  banner.each_char do |char|
    print char
    sleep(0.002)
  end
  puts "\n🚀 Starting Blockmesh Bot... Please wait..."
  sleep(2)
  system("clear")
end

# Fun hacker-style animation
def hacker_typing_effect
  text = "💀 HACKING THE MAINFRAME... 💀"
  text.each_char do |char|
    print char.colorize(:light_red)
    sleep(0.05)
  end
  puts "\n"
end

# Fake loading animation
def fake_loading(task)
  print "#{CYAN}🔄 #{task}...#{RESET}"
  10.times do
    print "."
    sleep(0.2)
  end
  puts "✅".green
  sleep(1)
end

# WebSocket connection
def connect_websocket(email, api_token)
  hacker_typing_effect
  begin
    ws = WebSocket::Client::Simple.connect("wss://ws.blockmesh.xyz/ws?email=#{email}&api_token=#{api_token}")
    puts "🛰️ [#{Time.now.strftime('%H:%M:%S')}] #{YELLOW}Connected to WebSocket!#{RESET} 🚀"
    ws.close
  rescue => e
    puts "⚠️ WebSocket connection failed! Retrying...".red
    sleep(2)
  end
end

# Simulate "Hacking Mode" 🤣
def hacking_mode
  system("clear")
  puts "#{BOLD}💀 INITIATING HACKING SEQUENCE...💀#{RESET}"
  30.times do
    print "#{GREEN}█#{RESET}"
    sleep(0.05)
  end
  puts "\n🚀 Connection Established..."
  sleep(1)
end

# Submitting fake bandwidth data
def submit_bandwidth(email, api_token)
  fake_loading("Uploading Bandwidth Data 💾")
  payload = {
    email: email,
    api_token: api_token,
    download_speed: rand(0.0..10.0).round(16),
    upload_speed: rand(0.0..5.0).round(16),
    latency: rand(20.0..300.0).round(16)
  }.to_json

  begin
    uri = URI("https://app.blockmesh.xyz/api/submit_bandwidth")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = payload
    response = http.request(request)
  rescue => e
    puts "❌ Failed to submit bandwidth data".red
  end
end

# Generate random task completion
def get_and_submit_task(email, api_token)
  fake_loading("Fetching New Tasks 📡")
  puts "📜 Task Found: #{SecureRandom.hex(4)}"
  sleep(rand(1..3))
  fake_loading("Submitting Task ✅")
  puts "🚀 Task Successfully Completed!"
end

# Display hacker-style dashboard
def display_dashboard
  system("clear")
  puts "#{BOLD}📊 BLOCKMESH BOT DASHBOARD 📊#{RESET}"
  puts "🔥 Active Bots: #{rand(10..50)}"
  puts "🌎 Total Bandwidth Shared: #{rand(100..500)} MB"
  puts "💰 Total Earnings: #{rand(0.1..10.0).round(2)} USD"
  puts "⚡ Tasks Completed: #{rand(5..100)}"
  puts "#{GREEN}====================================#{RESET}"
end

# Main function
def main
  hacker_banner
  hacking_mode

  print "📧 Enter Email: ".green
  email = gets.chomp
  print "🔑 Enter Password: ".green
  password = gets.chomp

  system("clear")
  puts "🔍 Authenticating User..."
  sleep(2)
  puts "✅ Login Successful!".green
  api_token = SecureRandom.hex(8)

  loop do
    display_dashboard
    connect_websocket(email, api_token)
    submit_bandwidth(email, api_token)
    get_and_submit_task(email, api_token)

    puts "💀 HACKER MODE ACTIVATED 💀"
    sleep(5)
  end
end

# Run the bot
main if __FILE__ == $0
