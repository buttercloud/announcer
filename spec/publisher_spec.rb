require "spec_helper"

describe Publisher do
  describe "Methods" do
    describe "#publish_for_type" do
      before(:each) do
        @test_config = {sms: {auth_token: "bla",
                              account_sid: "hello"},
                        email: {mandrill_api_key: "emailbla"}}
      end

      context "Email" do
        describe "Sending" do
          before(:each) do
            @mandrill = double("mandrill")
            @messages = double("messages")
            @res = double("results")

            allow(Mandrill::API).to receive(:new).with(@test_config[:email][:mandrill_api_key]).and_return(@mandrill)
            allow(@mandrill).to receive(:messages).and_return(@messages)
            allow(@messages).to receive(:send).and_return(@res)
          end

          it "should send an Email using Mandrill" do
            subject = "subject"
            from_name = "OJarz [Announcer]"
            html = "body"
            from_email = "info@test.com"
            to_emails = ["test1@test.com", "test2@test.com"]

            # Test whether Mandrill gets called
            expect(Mandrill::API).to receive(:new).with(@test_config[:email][:mandrill_api_key]).and_return(@mandrill).once
            expect(@messages).to receive(:send).and_return(@res).once

            Publisher.publish_for_type(:email, from_email, to_emails, subject, html, @test_config)
          end

          it "should send Mandrill the correct data" do
            subject = "subject"
            from_name = "OJarz [Announcer]"
            html = "body"
            from_email = "info@test.com"
            to_emails = ["test1@test.com", "test2@test.com"]

            final_to = [to_emails].flatten.map { |email| {email: email, name: "Name for #{email}"} }

            message_data = {subject: subject,  
                            from_name: from_name,  
                            html: html,  
                            to: final_to,  
                            from_email: from_email}

            expect(@messages).to receive(:send).with(message_data, any_args).and_return(@res).once

            Publisher.publish_for_type(:email, from_email, to_emails, subject, html, @test_config)
          end
        end
      end

      context "SMS" do
        describe "Bulk" do
          it "should send an SMS using Twilio for every number" do
            client = double("client")
            account = double("account")
            messages = double("messages")
            res = double("Twilio::REST::Message")

            allow(Twilio::REST::Client).to receive(:new).with(@test_config[:sms][:account_sid], @test_config[:sms][:auth_token]).and_return(client)
            allow(client).to receive(:account).and_return(account)
            allow(account).to receive(:messages).and_return(messages)
            allow(messages).to receive(:create).and_return(res)

            # Test whether Twilio gets called
            expect(Twilio::REST::Client).to receive(:new).with(@test_config[:sms][:account_sid], @test_config[:sms][:auth_token]).once
            expect(messages).to receive(:create).and_return(res).exactly(3).times

            Publisher.publish_for_type(:sms, "", ["12", "123", "1234"], "", "", @test_config)
          end
        end

        it "should send an SMS using Twilio" do          
          client = double("client")
          message = double("Twilio::REST::Message")

          allow(Twilio::REST::Client).to receive(:new).with(@test_config[:sms][:account_sid], @test_config[:sms][:auth_token]).and_return(client)
          allow(client).to receive_message_chain(:account, :messages, :create).and_return(message)

          # Test whether Twilio gets called
          expect(Twilio::REST::Client).to receive(:new).with(@test_config[:sms][:account_sid], @test_config[:sms][:auth_token]).once
          expect(client).to receive_message_chain(:account, :messages, :create)

          Publisher.publish_for_type(:sms, "", "", "", "", @test_config)
        end

        it "should call the private send_sms method" do
          from = "123"
          to = "1234"
          body = "Hello!"

          expect(Publisher).to receive(:send_sms).with(from, to, body, @test_config[:sms]).once

          Publisher.publish_for_type(:sms, from, to, "", body, @test_config)
        end
      end
    end
  end
end
