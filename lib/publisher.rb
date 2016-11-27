require 'twilio-ruby'
require 'mandrill'

module Publisher
  class << self
    def publish_for_type(type, from, to, subject, body, config)
      case type
      when :sms
        send_sms(from, to, body, config[type])
      when :email
        send_email(from, to, subject, body, config[type])
      end
    end

    private
      def send_email(from, to, subject, body, config)
        mandrill = Mandrill::API.new config[:mandrill_api_key]
        final_to = [to].flatten.map { |email| {email: email, name: "Name for #{email}"} }

        message = {subject: subject,  
                  from_name: "OJarz [Announcer]",  
                  html: body,  
                  to: final_to,  
                  from_email: from}
        async = false

        mandrill.messages.send message, async
      end

      def send_sms(from, to, body, config)
        client = Twilio::REST::Client.new(config[:account_sid], config[:auth_token])
        send_via_twilio = ->(number) { client.account.messages.create(from: from, to: number, body: body) }
        final_to = [to].flatten

        final_to.each { |number| send_via_twilio.call(number) }
      end
  end
end