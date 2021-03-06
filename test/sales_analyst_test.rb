require './lib/sales_engine'
require './lib/item_repository'
require './lib/merchant_repository'
require './lib/sales_analyst'
require './lib/merchant'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'


class SalesAnalystTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
    :items     => "./data/items.csv",
    :merchants => "./data/merchants.csv",
    :invoices => "./test/test_data/invoices_short.csv",
    :customers => "./test/test_data/customers_short.csv",
    :invoice_items => "./test/test_data/invoice_items_short.csv",
    :transactions => "./test/test_data/transactions_short.csv"
    })
    @sa = SalesAnalyst.new(@se)
  end

  def test_it_exists
    assert_instance_of SalesAnalyst, @sa
  end

  def test_find_avrg_items_per_merchant
    assert_equal 2.88, @sa.average_items_per_merchant
  end

  def test_find_avrg_items_per_merchant_standard_deviation
    assert_equal 3.26, @sa.average_items_per_merchant_standard_deviation
  end

  def test_for_merchants_with_item_count_1_above_std_deviation
    assert_equal 52, @sa.merchants_with_high_item_count.count
  end

  def test_average_item_price_for_merchant
    assert_equal 31.5, @sa.average_item_price_for_merchant(12334159)
    assert_equal 16.83, @sa.average_item_price_for_merchant(12334372)
    assert_equal 30.00, @sa.average_item_price_for_merchant(12335722)
    assert_equal 20.00, @sa.average_item_price_for_merchant(12336683)
  end

  def test_the_average_average_price_per_merchant
    assert_equal 350.29, @sa.average_average_price_per_merchant
  end

  def test_for_golden_items_two_std_dev_above_avrg
    assert_equal 5, @sa.golden_items.count
  end

  def test_average_invoices_per_merchant
    assert_equal 1.14, @sa.average_invoices_per_merchant
  end

  def test_average_invoices_per_merchant_standard_deviation
    assert_equal 3.26, @sa.average_items_per_merchant_standard_deviation
  end

  def test_retrieve_top_merchants_by_invoice_id
    assert_equal 1, @sa.top_merchants_by_invoice_count.count
    assert_instance_of Merchant, @sa.top_merchants_by_invoice_count[0]
  end

  def test_retrieve_bottom_merchants_by_invoice_id
    assert_equal 0, @sa.bottom_merchants_by_invoice_count.count
    assert_equal [], @sa.bottom_merchants_by_invoice_count
  end

  def test_retrieve_top_days_of_the_week_by_invoice
    assert_equal 1, @sa.top_days_by_invoice_count.count
    assert_equal "Friday" , @sa.top_days_by_invoice_count[0]
  end

  def test_retrieve_percentage_of_invoice_statuses
    assert_equal 31.25, @sa.invoice_status(:pending)
    assert_equal 62.5, @sa.invoice_status(:shipped)
    assert_equal 6.25, @sa.invoice_status(:returned)
  end

  def test_top_buyers_returns_top_buyers
    assert_equal 5, @sa.top_buyers(5).count
    assert_instance_of Customer, @sa.top_buyers(5)[0]
    assert_equal 20, @sa.top_buyers.count
  end

  def test_top_merchant_for_customers
    assert_instance_of Merchant, @sa.top_merchant_for_customer(1)
  end

  def test_find_one_time_buyers
    skip
    assert_instance_of Customer, @sa.one_time_buyers[0]
    assert_equal 2, @sa.one_time_buyers.count
  end

  def test_find_most_common_item
    skip
    assert_instance_of Item, @sa.one_time_buyers_item
  end

  def test_items_bought_in_year_can_find_item
    assert_instance_of Item, @sa.items_bought_in_year(1, 2009)[0]
    assert_equal 8, @sa.items_bought_in_year(1, 2009).count
  end

  def test_get_all_customer_ids_gets_customer_ids
    assert_equal 37, @sa.get_all_customer_item_ids(1).count
    assert_instance_of Hash, @sa.get_all_customer_item_ids(1)
  end

  def test_count_item_id_array_returns_hash
    assert_equal 2, @sa.get_highest_count_item_ids(1).count
  end

  def test_it_can_find_highest_volume_items
    assert_equal 2, @sa.highest_volume_items(1).count
  end

  def test_find_deadbeat_customers
    assert_equal 7, @sa.customers_with_unpaid_invoices.count
    assert_instance_of Customer, @sa.customers_with_unpaid_invoices.first
  end

  def test_find_best_invoice_by_revenue
    assert_instance_of Invoice, @sa.best_invoice_by_revenue
  end

  def test_find_best_invoice_by_quantity_of_items
    assert_instance_of Invoice, @sa.best_invoice_by_quantity
  end

end
