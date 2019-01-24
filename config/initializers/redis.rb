# require 'sidekiq'

# Sidekiq.configure_client do |config|
# config.redis = { :size => 1 }
# end

# Sidekiq.configure_server do |config|
# config.redis = { :size => 4 }
# end

uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:url => uri)
