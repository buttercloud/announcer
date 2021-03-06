require "announcer/version"
require "announcer/type"
require 'publisher'

module Announcer
  class SMS < Announcer::Type
    def initialize(_config={})
      super(_config, [:auth_token, :account_sid])
    end

    def publish!(from:, to:, body:)
      Publisher.publish_for_type(:sms,
                                 from,
                                 to,
                                 nil,
                                 body,
                                 {sms: self.config})
    end
  end
end
