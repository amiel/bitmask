require "bitmask/version"

# Bitmask represents a set of boolean values as an Integer.
#
# Examples:
#
#   masks = {
#           :cat  => 0b0001,
#           :dog  => 0b0010,
#           :fish => 0b0100
#         }
#
#   bitmask = Bitmask.new(masks, {:cat => true})
#   bitmask.to_i            # => 1
#   bitmask.get :cat        # => true
#   bitmask.get :dog        # => false
#   bitmask.set :dog, true
#   bitmask.get :dog        # => true
#   bitmask.to_i            # => 3
#   bitmask.to_h            # => { :cat => true, :dog => true, :fish => false }
#
#   bitmask = Bitmask.new(masks, 0b101)
#   bitmask.to_h            # => { :cat => true, :dog => false, :fish => true }
#   bitmask.to_i            # => 5
#   bitmask.to_i.to_s(2)    # => "101"
#
#   Bitmask.new(masks, 5) == Bitmask.new(masks, { :cat => true, :dog => false, :fish => true }) # => true
#
class Bitmask

  def ==(other)
    other.masks == @masks && other.to_i == self.to_i
  end

  # create an object with which to manipulate an integer as a set of boolean values
  #
  # arguments
  # masks::  a Hash where the key is the boolean attribute and the value is the bitmask.
  #             { :some_attribute => 0b0001, :another_attribute => 0b0010 }
  # value::  can be a Hash or Integer
  def initialize(masks, value)
    @masks = masks
    case value
    when Hash
      init_from_hash(value)
    when Array
      hash = Hash[value.zip(Array.new(value.size, true))]
      init_from_hash(hash)
    else
      @data = value.to_i
    end
  end

  attr_reader :masks

  def to_i
    @data
  end

  def to_a
    @masks.keys.select { |k| get k }
  end

  def each(&blk)
    to_h.each(&blk)
  end

  def to_h
    @masks.keys.inject({}) { |h, k| h[k] = get k; h }
  end

  # returns boolean value
  def get(attr)
    (@data & @masks[attr]) == @masks[attr]
  end

  # expects a boolean value
  def set(attr, value)
    raise ArgumentError, "unknown attribute: #{attr}" unless @masks[attr]
    case value
    when true
      Bitmask.new(@masks, @data | @masks[attr])
    when false
      Bitmask.new(@masks, @data & ~@masks[attr])
    end
  end

  def set_array(array)
    self.class.new(@masks, array & @masks.keys)
  end

  private

  def init_from_hash(h)
    b = Bitmask.new(@masks, 0)
    @data = h.inject(b) { |a, (attr, value)| a.set attr, value }.to_i
  end
end

