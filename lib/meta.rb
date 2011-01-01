module Meta
  def create_method( name, &block )
    self.class.send( :define_method, name.to_sym, &block )
  end
end