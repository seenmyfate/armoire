require 'spec_helper'

describe Armoire do
  describe '#.environment' do
    subject { described_class.instance.environment }

    context "ENV['RAILS_ENV'] is set" do
      before { ENV['RAILS_ENV'] = 'rails_env' }

      it "returns the result of ENV['RAILS_ENV'] as first priority" do
        expect(subject).to eql('rails_env')
      end

      after { ENV['RAILS_ENV'] = nil }
    end

    context "ENV['RACK_ENV'] is set" do
      before { ENV['RACK_ENV'] = 'rack_env' }

      it "returns the result of ENV['RACK_ENV'] as second priority" do
        expect(subject).to eql('rack_env')
      end

      after { ENV['RACK_ENV'] = nil }
    end

    context "nothing is set" do
      it "returns development as a fallback if nothing else is set" do
        expect(subject).to eql("development")
      end
    end
  end

  describe '#[]' do
    context "simple config option" do
      subject { Armoire["simple_config_option"] }

      it { expect(subject).to eql("simple_config_option_value") }
    end

    context "erb config option" do
      subject { Armoire["erb_config_option"] }

      it { expect(subject).to eql("erb_config_option_value") }
    end

    context "nested config option" do
      subject { Armoire["nested"]["config"]["option"] }

      it { expect(subject).to eql("nested_config_option_value") }
    end

    context 'config setting is missing' do
      subject { Armoire["missing_setting"] }

      it "raises an error" do
        expect { subject }.to raise_error(Armoire::ConfigSettingMissing, '"missing_setting" is not set')
      end
    end

    context 'nested config setting is missing' do
      subject { Armoire["nested"]["config"]["missing_setting"] }

      it "raises an error" do
        expect { subject }.to raise_error(Armoire::ConfigSettingMissing, '"missing_setting" is not set')
      end
    end
  end
end