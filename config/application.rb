require_relative 'boot'

require 'logger'

require 'rails/all'

Bundler.require(*Rails.groups)

module InfospaceBooks
  class Application < Rails::Application
    config.load_defaults 6.1

    config.eager_load_paths << Rails.root.join('services')
  end
end
