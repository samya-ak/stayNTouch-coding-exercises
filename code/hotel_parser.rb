require 'yaml'

# Goal is to parse the yaml and allow the fields to be accessed using [] and .
class HashAccessorWrapper
  # Recursively traverse the hash map values if the value is a hash map
  # Return a new object with added functionality for accessor when value is a hash map
  def initialize(raw_data)
    @data = {}
    raw_data.each do |key, value|
      wrapped = case value
                when Hash
                  HashAccessorWrapper.new(value)
                when Array
                  value.map { |v| v.is_a?(Hash) ? HashAccessorWrapper.new(v) : v }
                else
                  value
                end
      @data[key.to_s] = wrapped
    end
  end

  # Handle the case when user tries to use [] to access hash values
  def [](key)
    @data[key.to_s]
  end

  # Handle the case when user tries to use . notation to access hash values
  def method_missing(name, *args)
    if @data.key?(name.to_s)
      @data[name.to_s]
    else
      super
    end
  end

  # Correctly return value whether a method is present for respond_to method
  def respond_to_missing?(name, include_private = false)
    @data.key?(name.to_s) || super
  end
end

# Implements a method to parse the contents of a YAML file and return
# an object whose values are accessible using the [] operator or method calls
class HotelParser
  def self.parse(filename)
    # Parse the yaml file and use the hash map returned by it for further processing
    raw = YAML.load_file(filename)
    HashAccessorWrapper.new(raw)
  end
end
