require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CdpWebManyoTask
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    #
    #
    # rails gコマンドを実行した際、不要なアセットやヘルパー、テストファイルなどを生成しないよう制御
    config.generators do |g|
      g.assets false
      g.helper false
      g.test_framework :rspec,
                       model_specs: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: false,
                       request_specs: false
    end

    config.i18n.default_locale = :ja
    config.i18n.fallbacks = [:ja] # 日本語を優先してフォールバック

    # タイムゾーンを東京に設定 (日本標準時 JST)
    config.time_zone = "Tokyo"
    # データベースの保存時にローカルタイムゾーンを使用
    config.active_record.default_timezone = :local
  end
end
