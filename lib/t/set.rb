require 't/rcfile'
require 'thor'
require 'twitter'

module T
  class Set < Thor
    DEFAULT_HOST = 'api.twitter.com'
    DEFAULT_PROTOCOL = 'https'

    desc "bio DESCRIPTION", "Edits your Bio information on your Twitter profile."
    def bio(description)
      client.update_profile(:description => description)
      say "Bio has been changed."
    end

    desc "default USERNAME, CONSUMER_KEY", "Set your default account."
    def default(username, consumer_key)
      rcfile = RCFile.instance
      rcfile.default_profile = {'username' => username, 'consumer_key' => consumer_key}
      say "Default account has been changed."
    end

    desc "language LANGUAGE_NAME", "Selects the language you'd like to receive notifications in."
    def language(language_name)
      client.settings(:language => language_name)
      say "Language has been changed."
    end

    desc "location PLACE_NAME", "Updates the location field in your profile."
    def location(place_name)
      client.update_profile(:location => place_name)
      say "Location has been changed."
    end

    desc "name NAME", "Sets the name field on your Twitter profile."
    def name(name)
      client.update_profile(:name => name)
      say "Name has been changed."
    end

    desc "url URL", "Sets the URL field on your profile."
    def url(url)
      client.update_profile(:url => url)
      say "URL has been changed."
    end

    no_tasks do

      def base_url
        "#{protocol}://#{host}"
      end

      def client
        rcfile = RCFile.instance
        Twitter::Client.new(
          :endpoint => base_url,
          :consumer_key => rcfile.default_consumer_key,
          :consumer_secret => rcfile.default_consumer_secret,
          :oauth_token => rcfile.default_token,
          :oauth_token_secret  => rcfile.default_secret
        )
      end

      def host
        parent_options['host'] || DEFAULT_HOST
      end

      def protocol
        parent_options['no-ssl'] ? 'http' : DEFAULT_PROTOCOL
      end

    end
  end
end
