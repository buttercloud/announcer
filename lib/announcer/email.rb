require "announcer/version"
require "announcer/type"
require 'publisher'

module Announcer
  class Email < Announcer::Type
    def initialize(_config={})
      super(_config, [:mandrill_api_key])
    end

    def publish!(from:, to:, subject:, body:)
      Publisher.publish_for_type(:email,
                                 from,
                                 to,
                                 subject,
                                 body,
                                 {email: self.config})
    end
  end
end
