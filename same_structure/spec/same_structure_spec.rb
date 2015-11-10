class Array
  def same_structure_as(other)
    Array.same_element_structure self, other
  end

  private
  def self.same_element_structure(a, b)
    none_is_an_array(a, b) ||
    both_are_arrays(a, b)  &&
    a.size == b.size && 
    a.each.with_index.all? { |e, i| self.same_element_structure e, b[i] }
  end

  def self.both_are_arrays(a, b)
    a.instance_of?(Array) && b.instance_of?(Array)
  end

  def self.none_is_an_array(a, b)
    !a.instance_of?(Array) && !b.instance_of?(Array)
  end
end



describe "Same structure" do

  {
    [ 1, 1, 1 ] => [ 2, 2, 2 ],
    [ 1, [ 1, 1 ] ] => [ 2, [ 2, 2 ] ], 
  }.each do |a, b|
    it "returns true when they have the same structure" do
      expect(a.same_structure_as b).to be true
    end
  end

  {
    [ 1, [ 1, 1 ] ] => [[ 2, 2 ], 2 ],
    [ 1, [ 1, 1 ] ] => [[ 2 ], 2 ]
  }.each do |a, b|
    it "returns false when they don't have the same structure" do
      expect(a.same_structure_as b).to be false
    end
  end

end
