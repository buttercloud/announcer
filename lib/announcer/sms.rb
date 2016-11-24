require "announcer/version"
require 'publisher'

module Announcer
  class SMS
    attr_accessor :sms_config

    def initialize(config={})
      dup_config = deep_clone_hash(config)
      filtered_auth = dup_config.keep_if { |k,_| k == :auth_token || k == :account_sid }
      self.sms_config = filtered_auth
    end

    def publish!(from: , to: , body:)
      Publisher.publish_for_type(:sms, from, to, nil, body, {sms: self.sms_config})
    end

    private
      def deep_clone_hash(hash)
        Marshal.load(Marshal.dump(hash))
      end
  end
end
