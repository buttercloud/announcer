require "spec_helper"

describe Announcer::Type, type: :class do
  describe "Methods" do
    describe "#initialize" do
      it "should set the filtered config hash in auth_config" do
        test_config = {valid_key: "bla", invalid: nil}
        config = Announcer::Type.new(test_config, [:valid_key]).config

        expect(config.keys).to_not include(:invalid)
        expect(config.keys).to include(:valid_key)
      end
    end

    describe "#publish!" do
      it "should return NotImplementedError" do
        type = Announcer::Type.new({}, [])

        expect { type.publish! }.to raise_error(NotImplementedError)
      end
    end
  end
end
