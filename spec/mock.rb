class Mock
  def initialize(properties)
    @properties = properties
  end

  def method_missing(m, *args, &block)
    @properties[m]
  end
end