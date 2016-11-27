require "spec_helper"
require 'publisher'

describe Announcer::Email, type: :class do
  describe "Methods" do
    describe "#initialize" do
      it "should set the filtered config hash in config" do
        test_config = {mandrill_api_key: "hello", invalid: nil}
        email_config = Announcer::Email.new(test_config).config

        expect(email_config.keys).to_not include(:invalid)
        expect(email_config.keys).to include(:mandrill_api_key)
      end
    end

    describe "#publish!" do
      it "should call Publisher.publish_for_type" do
        test_config = {mandrill_api_key: "bla"}
        from = "info@test.com"
        to = "test@test.com"
        to = "subject"
        body = "Sup!"

        email = Announcer::Email.new(test_config)

        allow(Publisher).to receive(:publish_for_type).and_return(true)
        expect(Publisher).to receive(:publish_for_type).with(:email, from, to, subject, body, {email: test_config}).once

        email.publish!(from: from, to: to, subject: subject, body: body)
      end
    end
  end
end
