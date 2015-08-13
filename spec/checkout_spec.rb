require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Checkout' do
  let(:voucher) { Item.new 'VOUCHER', 'Cabify Voucher', 5 }
  let(:tshirt) { Item.new 'TSHIRT', 'Cabify T-Shirt', 20 }
  let(:mug) { Item.new 'MUG', 'Cabify Coffee Mug', 7.50 }
  let(:two_for_one_pricing_rule) {
    PricingRule.new(voucher) do |item, cart|
      noOfItems = cart.count(item)
      cart.delete(item)
      ((noOfItems / 2) + (noOfItems % 2)) * item.price
    end
  }
  let(:bulk_pricing) {
    PricingRule.new(tshirt) do |item, cart|
      noOfItems = cart.count(item)
      cart.delete(item)
      price = noOfItems * item.price
      if noOfItems > 2
        price = price - noOfItems
      end
      price
    end
  }
  let(:checkout) {
    rules = [two_for_one_pricing_rule, bulk_pricing]
    Checkout.new(rules)
  }

  describe '.scan' do
    it 'should scan an item' do
      checkout.scan(voucher)
      expect(checkout.items).to contain_exactly(voucher)
    end

    it 'should be a chaining method' do
      checkout.scan(voucher).scan(tshirt)
      expect(checkout.items).to contain_exactly(voucher, tshirt)
    end
  end

  describe '.total' do
    specs = [
      {
        items: [:voucher, :tshirt, :mug],
        price: 32.50
      },
      {
        items: [:voucher, :tshirt, :voucher],
        price: 25
      },
      {
        items: [:tshirt, :tshirt, :tshirt, :voucher, :tshirt],
        price: 81
      },
      {
        items: [:voucher, :tshirt, :voucher, :voucher, :mug, :tshirt, :tshirt],
        price: 74.50
      }
    ]

    specs.each do |spec|
      it "should charge #{spec[:price]} for cart containing #{spec[:items]} " do
        spec[:items].each do |key|
          item = send(key)
          checkout.scan(item)
        end
        expect(checkout.total).to be(spec[:price])
      end
    end
  end
end
