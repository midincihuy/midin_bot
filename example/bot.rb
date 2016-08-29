require 'telegram_bot'
require 'pp'
require 'logger'
require 'yaml'

logger = Logger.new(STDOUT, Logger::DEBUG)

env_file = File.join('config','local_env.yml')
YAML.load(File.open(env_file)).each do |key, value|
  ENV[key.to_s] = value
end if File.exists?(env_file)

bot = TelegramBot.new(token: ENV['TELEGRAM_BOT_API_KEY'], logger: logger)
logger.debug "starting telegram bot"

bot.get_updates(fail_silently: true) do |message|
  logger.info "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

  message.reply do |reply|
    case command
    when /greet/i
      reply.text = "Hello, #{message.from.first_name}!"
    when /what is your name?/i
      me = bot.get_me()
      reply.text = "My name is #{me.first_name}!"
    when /greet/i
      reply.text = "Hello, #{message.from.first_name}!"
    when /coba aja/i
      reply.text = "command coba"
    when /coba/i
      reply.text = "ini hanya coba coba"
    when /apa kabar/i
      reply.text = "Aku baik baik saja"
    when /check/i
      cmd = "date"
      value = `#{cmd}`
      reply.text = "checking something here #{value}!"
     
    else
      reply.text = "#{message.from.first_name}, have no idea what #{command.inspect} means."
    end
    logger.info "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
