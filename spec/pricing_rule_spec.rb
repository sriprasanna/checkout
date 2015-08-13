require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'PricingRule' do
  let(:item) { Item.new "code", "name", 10 }

  describe '2-for-1' do
    let(:rule) {
      PricingRule.new(item) do |item, cart|
        noOfItems = cart.count(item)
        cart.delete(item)
        ((noOfItems / 2) + (noOfItems % 2)) * item.price
      end
    }

    it 'should return price for a single item - 10 Euros' do
      items = [item]
      expect(rule.priceForItems(items)).to be(10)
    end

    it 'should return price for a three items - 20 Euros' do
      items = [item] * 3
      expect(rule.priceForItems(items)).to be(20)
    end

    it 'should return price for a six items - 30 Euros' do
      items = [item] * 6
      expect(rule.priceForItems(items)).to be(30)
    end

    it 'should remove item from the cart' do
      items = [item] * 4
      expect(rule.priceForItems(items)).to be(20)
      expect(items.count).to be(0)
    end

    it 'should not remove other items from the cart' do
      otherItem = Item.new
      items = [item, item, otherItem]
      expect(rule.priceForItems(items)).to be(10)
      expect(items).to contain_exactly(otherItem)
    end
  end

  describe 'Bulk purchase' do
    let(:rule) {
      PricingRule.new(item) do |item, cart|
        noOfItems = cart.count(item)
        cart.delete(item)
        price = noOfItems * item.price
        if noOfItems > 2
          price = price - noOfItems
        end
        price
      end
    }

    it 'should return price for a single item - 10 Euros' do
      items = [item]
      expect(rule.priceForItems(items)).to be(10)
    end

    it 'should return price for a three items - 27 Euros' do
      items = [item] * 3
      expect(rule.priceForItems(items)).to be(27)
    end

    it 'should return price for a six items - 54 Euros' do
      items = [item] * 6
      expect(rule.priceForItems(items)).to be(54)
    end

    it 'should remove item from the cart' do
      items = [item] * 6
      expect(rule.priceForItems(items)).to be(54)
      expect(items.count).to be(0)
    end

    it 'should not remove other items from the cart' do
      otherItem = Item.new
      items = [item, item, otherItem]
      expect(rule.priceForItems(items)).to be(20)
      expect(items).to contain_exactly(otherItem)
    end
  end
end
