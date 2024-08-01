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
    context "aged brie" do
      let(:item) {Item.new(GildedRose::BRIE, 1, 1)}

      it "does increases quality" do
        expect { subject }.to change { item.quality }.by(1)
      end

      it "does increases quality post sell date" do
        item.sell_in = -1
        expect { subject }.to change { item.quality }.by(2)
      end

      it "does does increases quality past 50" do
        item.quality = 50
        expect { subject }.to_not change { item.quality }
      end
    end

    context "sulfuras" do
      let(:item) {Item.new(GildedRose::SULFURAS, 1, 1)}

      it "does not change quality" do
        expect { subject }.to_not change { item.quality }
      end

      it "does not change sell_in" do
        expect { subject }.to_not change { item.sell_in }
      end
    end

    context "backstage pass" do
      let(:item) {Item.new(GildedRose::BACKSTAGE_PASS, 10, 11)}

      it "does drop to 0 post sale" do
        item.sell_in = 0
        expect { subject }.to change { item.quality }.to(0)
      end

      it "does increase by 1 with 11+days" do
        item.sell_in = 11
        expect { subject }.to change { item.quality }.by(1)
      end


      it "does increase by 2 <10 days" do
        item.sell_in = 8
        expect { subject }.to change { item.quality }.by(2)
      end

      it "does inclrease by 3 <5 days" do
        item.sell_in = 5
        expect { subject }.to change { item.quality }.by(3)
      end
    end
  end
end
