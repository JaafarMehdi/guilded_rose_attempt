require 'rspec'

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  subject { GildedRose.new(items).update_quality() }
  let(:item) {Item.new("foo", 1, 1)}
  let(:items) { [item] }

  it "does not change the name" do
    expect { subject }.to_not change { item.name }
  end

  it "does reduce sell_in" do
    expect { subject }.to change { item.sell_in }.by(-1)
  end

  it "does reduce quality" do
    expect { subject }.to change { item.quality }.by(-1)
  end

  context 'quality 0' do
    let(:item) {Item.new("worthless", 0, 0)}

    it "does not reduce quality lower than 0" do
      expect { subject }.to_not change { item.quality }
    end
  end

  context 'past sell date' do
    let(:item) {Item.new("too_oldey", -10, 20)}

    it "does reduce quality by 2" do
      expect { subject }.to change { item.quality }.by(-2)
    end
  end

  #TODO spec that it works for multiple items

  context "special items" do
  end
end
