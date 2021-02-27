require 'spec_helper'

RSpec.describe InteractionsConsumer do
  describe '#calc_engagements' do

    it 'valid interaction' do
      valid_message = { "id" => 3161392777, "organization_id" => "601a6fc90638651eff8350a8", "type" => "post", "source" => "facebook", "link" => "https://facebook.com/fake-post", "username" => "faker fake", "engagements" => { "likes" => 288, "love" => 239, "haha" => 267, "angry" => 160 } }
      expect(described_class.calc_engagements(valid_message)).to eq(954)
    end

    it 'valid interaction with zeros' do
      valid_message = { "id" => 3161392777, "organization_id" => "601a6fc90638651eff8350a8", "type" => "post", "source" => "facebook", "link" => "https://facebook.com/fake-post", "username" => "faker fake", "engagements" => { "likes" => 0, "love" => 0, "haha" => 0, "angry" => 0 } }
      expect(described_class.calc_engagements(valid_message)).to eq(0)
    end

    it 'invalid interaction with nulls and strings' do
      valid_message = { "id" => 3161392777, "organization_id" => "601a6fc90638651eff8350a8", "type" => "post", "source" => "facebook", "link" => "https://facebook.com/fake-post", "username" => "faker fake", "engagements" => { "likes" => 6, "love" => nil, "haha" => "asas", "angry" => "0" } }
      expect(described_class.calc_engagements(valid_message)).to eq(6)
    end

    it 'no interaction invalid key' do
      valid_message = { "id" => 3161392777, "organization_id" => "601a6fc90638651eff8350a8", "type" => "post", "source" => "facebook", "link" => "https://facebook.com/fake-post", "username" => "faker fake", "engagementsa" => { "likes" => 6, "love" => nil, "haha" => "asas", "angry" => "0" } }
      expect(described_class.calc_engagements(valid_message)).to eq(0)
    end
  end
end