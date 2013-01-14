class Bitmask
  module Methods

    def ==(other)
      other.masks == self.masks && other.to_i == self.to_i
    end


    def initialize(value)
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

    def to_i
      @data
    end

    def to_a
      masks.keys.select { |k| get k }
    end

    def each(&blk)
      to_h.each(&blk)
    end

    def to_h
      masks.keys.inject({}) { |h, k| h[k] = get k; h }
    end

    # returns boolean value
    def get(attr)
      (@data & masks[attr]) == masks[attr]
    end


    # expects a boolean value
    def set(attr, value)
      raise ArgumentError, "unknown attribute: #{attr}" unless @masks[attr]
      case value
      when true
        new(@data | @masks[attr])
      when false
        new(@data & ~@masks[attr])
      end
    end

    def set_array(array)
      new(array & masks.keys)
    end

    private

    def init_from_hash(h)
      b = new(0)
      @data = h.inject(b) { |a, (attr, value)| a.set attr, value }.to_i
    end


  end
end
