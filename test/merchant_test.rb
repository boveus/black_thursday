require './lib/merchant'
require './lib/sales_engine'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'


class MerchantTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
    :merchants => "./data/merchants.csv",
    :items     => "./data/items.csv",
    :invoices => "./test/test_data/invoices_short.csv",
    :customers => "./test/test_data/customers_short.csv"
    })
    @merchant = Merchant.new({:id => 12334389, :name => 'WoodleyShop'}, @se)
  end

  def test_it_exists
  assert_instance_of Merchant, @merchant
  end

  def test_can_retrieve_name
    assert_equal 'WoodleyShop', @merchant.name
  end

  def test_it_can_retrieve_id
    assert_equal 12334389, @merchant.id
  end

  def test_it_can_find_items_by_merchant_id
    assert_instance_of Item, @merchant.items.first
  end

  def test_it_can_find_invoices_by_merchant
    assert_instance_of Invoice, @merchant.invoices.first
  end

  def test_it_can_find_customers_who_have_purchases_from_it
    assert_equal 3, @merchant.customers.count
  end
end
