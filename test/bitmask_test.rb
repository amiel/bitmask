require 'test_helper'

class BitmaskTest < Test::Unit::TestCase
  TEST_MASKS = {
    :phone    => 0b0000001,
    :name     => 0b0000010,
    :gender   => 0b0000100,
    :email    => 0b0001000,
    :birthday => 0b0100000,
    :location => 0b1000000,
  }
  # Replace this with your real tests.
  def test_get
    bitmask = Bitmask.new TEST_MASKS, :phone => true, :name => true, :email => true
    assert bitmask.get(:phone)
    assert bitmask.get(:name)
    assert bitmask.get(:email)
    assert !bitmask.get(:gender)
    assert !bitmask.get(:birthday)
    assert !bitmask.get(:location)
  end

  def test_set
    bitmask = Bitmask.new TEST_MASKS, 0
    assert !bitmask.get(:phone)
    res = bitmask.set(:phone, true)
    assert res.is_a?(Bitmask)
    assert bitmask.get(:phone)
    assert !bitmask.get(:email)
    bitmask.set(:email, true)
    assert bitmask.get(:email)
  end

  def test_to_h
    bitmask = Bitmask.new TEST_MASKS, :phone => true, :name => true, :email => true
    assert_equal({:phone => true, :name => true, :email => true, :gender => false, :birthday => false, :location => false}, bitmask.to_h)
  end

  def test_to_a
    bitmask = Bitmask.new TEST_MASKS, :phone => true, :name => true, :email => true
    assert_equal([:phone, :name, :email], bitmask.to_a)
  end

  def test_lsb
    bitmask = Bitmask.new TEST_MASKS, :name => true, :email => true, :location => true
    mask = Bitmask.new TEST_MASKS, :gender => true, :email => true, :birthday => true, :location => true
    res = bitmask.to_i & mask.to_i
    res_mask = Bitmask.new TEST_MASKS, res
    assert_equal({:phone => false, :name => false, :gender => false, :email => true, :birthday => false, :location => true}, res_mask.to_h)
    assert_equal(TEST_MASKS[:name], bitmask.lsb)
    assert_equal(TEST_MASKS[:gender], mask.lsb)
    assert_equal(TEST_MASKS[:email], res_mask.lsb)
  end

  def test_msb
    bitmask = Bitmask.new TEST_MASKS, :name => true, :gender => true, :email => true, :location => true
    mask = Bitmask.new TEST_MASKS, :gender => true, :email => true, :birthday => true
    res = bitmask.to_i & mask.to_i
    res_mask = Bitmask.new TEST_MASKS, res
    assert_equal({:phone => false, :name => false, :gender => true, :email => true, :birthday => false, :location => false}, res_mask.to_h)
    assert_equal(TEST_MASKS[:location], bitmask.msb)
    assert_equal(TEST_MASKS[:birthday], mask.msb)
    assert_equal(TEST_MASKS[:email], res_mask.msb)
  end

  def test_each
    bitmask = Bitmask.new TEST_MASKS, :phone => true, :name => true, :email => true
    results = {}
    bitmask.each do |k, v|
      results[k] = v
    end

    assert_equal({:phone => true, :name => true, :email => true, :gender => false, :birthday => false, :location => false}, results)
  end

  def test_defaults
    bitmask = Bitmask.new(TEST_MASKS, {:phone => true, :email => true})
    assert  bitmask.get(:phone)
    assert !bitmask.get(:name)
    assert  bitmask.get(:email)
    assert !bitmask.get(:gender)
    assert !bitmask.get(:birthday)
    assert !bitmask.get(:location)
  end

  def test_to_i_and_create_from_integer
    bitmask = Bitmask.new TEST_MASKS, :phone => true, :name => true, :email => true
    bitmask_two = Bitmask.new(TEST_MASKS, bitmask.to_i)
    assert_equal(bitmask_two.to_h, {:phone => true, :name => true, :email => true, :gender => false, :birthday => false, :location => false})
  end

  def test_equality
    bitmask_one   = Bitmask.new TEST_MASKS, :phone => true, :name => true, :email => true
    bitmask_two   = Bitmask.new TEST_MASKS, :phone => true, :name => true, :email => true
    bitmask_three = Bitmask.new TEST_MASKS, :phone => true, :name => true, :email => false
    assert bitmask_one == bitmask_two
    assert bitmask_two != bitmask_three
  end

  def test_set_array
    bitmask = Bitmask.new TEST_MASKS, :phone => true, :name => true
    res = bitmask.set_array [:phone, :email]
    assert res.is_a?(Bitmask)
    assert_equal(bitmask.to_h, {:phone => true, :name => false, :email => true, :gender => false, :birthday => false, :location => false})
  end

  def test_set_raises
    bitmask = Bitmask.new TEST_MASKS, 0
    assert_raises ArgumentError do
      bitmask.set :foo, true
    end
  end

  def test_set_array_doesnt_raise
    bitmask = Bitmask.new TEST_MASKS, :phone => true, :name => true
    assert_nothing_raised do
      bitmask.set_array [:phone, :email, :foodebar]
    end
    assert_equal(bitmask.to_h, {:phone => true, :name => false, :email => true, :gender => false, :birthday => false, :location => false})
  end

  def test_chaining
    masks = {
      :cat  => 0b0001,
      :dog  => 0b0010,
      :fish => 0b0100,
    }
    bitmask = Bitmask.new(masks, {:cat => true})
    assert_equal "1", bitmask.to_i.to_s(2)    # => "1"
    bitmask.set(:dog, true).set(:cat, false).set(:fish, true)
    assert_equal "110", bitmask.to_i.to_s(2)    # => "110"
  end
end
