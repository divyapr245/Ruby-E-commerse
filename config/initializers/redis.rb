# config/initializers/redis.rb
REDIS_CLIENT = Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/1')
