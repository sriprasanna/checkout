class PricingRule
  def initialize(item, &rule)
    @item = item
    @rule = rule
  end

  def priceForItems(cart)
    @rule.call(@item, cart)
  end
end
