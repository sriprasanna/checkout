require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do

  let(:code) { Faker::Name.title }
  let(:name) { Faker::Name.name }
  let(:price) { Faker::Commerce.price }
  let(:item) { Item.new code, name, price }

  it 'should have a code' do
    expect(item.code).to be(code)
  end

  it 'should have a name' do
    expect(item.name).to be(name)
  end

  it 'should have a price' do
    expect(item.price).to be(price)
  end
end
