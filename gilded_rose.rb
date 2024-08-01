class GildedRose

  BRIE = 'Aged Brie'
  BACKSTAGE_PASS = "Backstage passes to a TAFKAL80ETC concert"
  SULFURAS = "Sulfuras, Hand of Ragnaros"
  CONJURED = 'Conjured'


  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      next if item.name == SULFURAS

      item.sell_in = item.sell_in - 1

      case item.name
      when BACKSTAGE_PASS
        item.quality = item.quality + 1
        if item.sell_in < 10
          item.quality = item.quality + 1
        end
        if item.sell_in < 5
          item.quality = item.quality + 1
        end
        if item.sell_in < 1
          item.quality = 0
        end
      when BRIE
        item.quality = item.quality + 1
        if item.sell_in < 0
          item.quality = item.quality + 1
        end
      when CONJURED
        item.quality = item.quality - 2
        if item.sell_in < 0
          item.quality = item.quality - 2
        end
      else
        item.quality = item.quality - 1
        if item.sell_in < 0
          item.quality = item.quality - 1
        end
      end

      item.quality = [item.quality, 50].min
      item.quality = [item.quality, 0].max
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
