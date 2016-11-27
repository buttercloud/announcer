require "spec_helper"
require 'publisher'

describe Announcer::SMS, type: :class do
  describe "Methods" do
    describe "#initialize" do
      it "should set the filtered config hash in auth_config" do
        test_config = {auth_token: "bla", account_sid: "hello", invalid: nil}
        sms_config = Announcer::SMS.new(test_config).config

        expect(sms_config.keys).to_not include(:invalid)
        expect(sms_config.keys).to include(:auth_token)
        expect(sms_config.keys).to include(:account_sid)
      end
    end

    describe "#publish!" do
      it "should call Publisher.publish_for_type" do
        test_config = {auth_token: "bla", account_sid: "hello"}
        from = "+12018855685"
        to = "92929292929"
        body = "Sup!"

        sms = Announcer::SMS.new(test_config)

        allow(Publisher).to receive(:publish_for_type).and_return(true)
        expect(Publisher).to receive(:publish_for_type).with(:sms, from, to, nil, body, {sms: test_config}).once

        sms.publish!(from: from, to: to, body: body)
      end
    end
  end
end
