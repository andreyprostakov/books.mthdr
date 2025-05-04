# frozen_string_literal: true

RSpec.configure do |config|
  config.after do
    Rails.redis.flushdb
  end
end
