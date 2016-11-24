require 'twilio-ruby'

module Publisher
  class << self
    def publish_for_type(type, from, to, subject, body, config)
      case type
      when :sms
        send_sms(from, to, body, config[type])
      end
    end

    private
      def send_sms(from, to, body, config)
        client = Twilio::REST::Client.new(config[:account_sid], config[:auth_token])

        send_via_twilio = ->(number) {
          client.account.messages.create(from: from, to: number, body: body)            
        }

        if to.is_a?(Array)
          to.each do |number|
            send_via_twilio.call(number)
          end
        else
          send_via_twilio.call(to)
        end
      end
  end
end