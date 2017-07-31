require './lib/customer'
require './lib/sales_engine'
require './lib/customer_repository'
require 'time'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

class CustomerTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
                                :customers => "./test/test_data/customers_short.csv",
                                :invoices => "./test/test_data/invoices_short.csv"
                                })
    @customers = CustomerRepository.new("./test/test_data/customers_short.csv", @se)
  end

  def test_it_exists
    assert_instance_of Customer, @customers.all[0]
  end

  def test_all_attributes
    assert_equal 1,@customers.all.first.id
    assert_equal "Joey",@customers.all.first.first_name
    assert_equal "Ondricka",@customers.all.first.last_name
    assert_equal Time.parse("2012-03-27 14:54:09 UTC"),@customers.all.first.created_at
    assert_equal Time.parse("2012-03-27 14:54:09 UTC"),@customers.all.first.updated_at
  end

  def test_is_can_get_invoices
    assert_instance_of Invoice, @customers.all.first.invoices.first
  end
end
