class Checkout
  attr_reader :items

  def initialize(rules)
    @items = []
    @rules = rules
    @price = 0
  end

  def scan(item)
    @items << item
    self
  end

  def total
    calculatePriceByRules
    calculatePriceForTheRest
    @price
  end

  private
  def calculatePriceByRules
    @rules.each do |rule|
      @price += rule.priceForItems(@items)
    end
  end

  def calculatePriceForTheRest
    @price += @items.collect(&:price).inject(:+) || 0
  end
end
