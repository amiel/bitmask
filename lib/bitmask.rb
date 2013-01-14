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
require 'bitmask/methods'
class Bitmask

  include Bitmask::Methods

  # create an object with which to manipulate an integer as a set of boolean values
  #
  # arguments
  # masks::  a Hash where the key is the boolean attribute and the value is the bitmask.
  #             { :some_attribute => 0b0001, :another_attribute => 0b0010 }
  # value::  can be a Hash or Integer
  def initialize(masks, value)
    @masks = masks
    super(value)
  end

  attr_reader :masks

  def new(value)
    Bitmask.new(masks, value)
  end

end

