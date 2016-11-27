require "announcer/version"

module Announcer
  class Type
    attr_accessor :config

    def initialize(config={}, keys)
      dup_config = deep_clone_hash(config)
      filtered_auth = dup_config.keep_if { |k,_| keys.include?(k) }

      self.config = filtered_auth
    end

    def publish!()
      raise NotImplementedError
    end

    private
      def deep_clone_hash(hash)
        Marshal.load(Marshal.dump(hash))
      end
  end
end
