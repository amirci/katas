require 'rantly/rspec_extensions'


# CombinationExample rollPoints
# Straight (1,2,3,4,5 and 6)6 3 1 2 5 41000 points
# Three pairs of any dice2 2 4 4 1 1750 points
# Three of 11 4 1 11000 point       s
# Three of 22 3 4 2 2200 points
# Three of 33 4 3 6 3 2300 points
# Three of 44 4 4400 points
# Three of 52 5 5 5 4500 points
# Three of 66 6          2 6600 points
# Four of a kind 1 1 1 1 4 62 × Three-of-a-kind score (in example, 2000 pts)
# Five of a kind 5 5 5 4 5 53 × Three-of-a-kind score (in example, 1500 pts)
# Six of a kind 4 4 4 4 4 44 × Three-of-a-kind score (in example, 1600 pts)
# Every 14 3 1 2 2100 points
# Every 55       2 650 points 

def get_score(roll)
  roll = roll.sort
  return 750 if roll.size == 6 && [0, 2, 4].to_a.all? { |i| roll[i] == roll[i+1]}
  1000
end

describe 'Score Zonk' do
  let(:dice) { -> { range(1, 6) }}
  class Rantly
    def roll_uniq(n)
      values = (1..6).to_a
      throws = []
      while n != 0
        throws << choose(*values)
        values.delete throws.last
        n -= 1
      end
      throws
    end
  end 

  context "3 pairs of any dice" do
    let(:three_pairs) do -> (r) { 
      a, b, c = roll_uniq 3
      [a, a, b, b, c, c].shuffle
    }
    end
    it "returns 750" do
      property_of(&three_pairs).check { |roll| expect(get_score roll).to eq 750 }
    end
  end
  context 'four of a kind' do
    it "returns 2000" do

    end
  end

  context 'five of a kind' do

  end

  context "Score is 1000" do
    let(:one_to_six) { -> (r) { (1..6).to_a.shuffle }}
    it "1 to 6 returns 1000" do
      property_of(&one_to_six).check { |roll| expect(get_score roll).to eq 1000 }
    end
  end
end
