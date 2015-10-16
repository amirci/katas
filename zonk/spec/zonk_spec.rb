require 'rantly/rspec_extensions'
require 'byebug'

# Straight (1,2,3,4,5 and 6) -> 1000 points
# Three pairs of any dice -> 750 points
# Three of 1 -> 1000 points
# Three of 2 -> 200 points
# Three of 3 -> 300 points
# Three of 4 -> 400 points
# Three of 5 -> 500 points
# Three of 6 -> 600 points
# Four of a kind -> 2 × Three-of-a-kind score
# Five of a kind -> 3 × Three-of-a-kind score
# Six  of a kind -> 4 × Three-of-a-kind score
# Every 1 -> 100 points
# Every 5 -> 50 points 

def get_score(roll)
  three_pairs = -> {
    roll.size == 6 && 
    [0, 2, 4].to_a.all? { |i| roll[i] == roll[i+1] } &&
    roll[0] != roll[2] && roll[2] != roll[4]
  }

  roll = roll.sort
  
  return 1000 if roll == (1..6).to_a
  
  return 750 if three_pairs.call
  
  repeat_score = (1..6).map do |num|
    score=num == 1 ? 1000 : num * 100
    amount = roll.find_all { |e| e == num }.size
    (amount >= 3 && score * (amount - 2)) || 0
  end.reduce(:+)
  
  return repeat_score if repeat_score > 0

  'Zonk'
end

describe 'Zonk score' do
  
  three_of_a_kind = [[1, 1000]] + (2..6).map { |i| [i, i*100] }
  
  class Rantly
    def dice_roll(n=1)
      size(n) { range(1,6) }
    end
    def roll_uniq(n, values = (1..6).to_a)
      throws = []
      while n != 0
        throws << choose(*values)
        values.delete throws.last
        n -= 1
      end
      throws
    end
    
    def same_of_a_kind(n, number = nil)
      number ||= range(1, 6)
      len = range(0, 6 - n)
      values = (1..6).to_a
      values.delete number
      rolled = Array.new(n) {number} + roll_uniq(len, values)
      rolled.shuffle
    end
  end 

  it "returns 750 for 3 pairs of any dice" do
    property_of {
      a, b, c = roll_uniq 3
      [a, a, b, b, c, c].shuffle
    }.check do |roll| 
      expect(get_score roll).to eq 750
    end
  end

  (3..6).each do |times|
    three_of_a_kind.each do |number, expected|
      it "returns #{expected * (times - 2)} points when #{number} repeats #{times} times" do
        property_of { same_of_a_kind times, number }.check do |roll|
          expect(get_score roll).to eq expected * (times - 2)
        end
      end
    end
  end
  
  it "returns 1000 for 1 to 6 straight" do
    property_of { (1..6).to_a.shuffle }.check do |roll| 
      expect(get_score roll).to eq 1000
    end
  end
  
  # Test.assert_equals get_score([1]), 100
  # Test.assert_equals get_score([5]), 50
  # Test.assert_equals get_score([1,1]), 200
  # get_score([3,4,1,1,5]); # returns 250 = points from two 1 and one 5
  #   get_score([2,3,2,3,3,2]); # returns 500 = three of 2 + three of 3
  #   get_score([1,1,1,1,1,5]); # returns 3050 = five 1 + one 5
  #   get_score([2,3,4,3,6,6]); # returns "Zonk" = no combinations here
  #   get_score([2,2,6,6,2,2]); # returns 400 = four 2, this cannot be scored as three pairs
  #   get_score([1,3,4,3,4,1]); # returns 750 = three pairs
  #   get_score([3,3,3,3]); # returns 600 = four of 3
  #   get_score([1,2,3,4,5]); # returns 150 = it's not straight
      
  
  it "returns 100 for each one that repeats once or twice" do
    property_of {
      len = range(1, 2)
      Array.new(len) { 1 }
    }.check do |roll|
      expect(get_score roll).to eq (100 * roll.size)
    end
  end
  
  it "returns 50 for each five that repeats once or twice" do
    property_of {
      len = range(1, 2)
      Array.new(len) { 5 }
    }.check do |roll|
      expect(get_score roll).to eq (50 * roll.size)
    end
  end
  
  [2, 3, 4, 6].each do |i|
    it "returns Zonk for only #{i}" do 
      expect(get_score [i]).to eq 'Zonk'
    end
  end
end
