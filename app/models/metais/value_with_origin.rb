class Metais::ValueWithOrigin < BasicObject
  attr_reader :origin

  def initialize(value, origin)
    @value = value
    @origin = origin
  end

  def method_missing(name, *args)
    @value.send(name, *args)
  end
end