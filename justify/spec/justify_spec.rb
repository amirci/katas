require 'byebug'
require 'rantly/rspec_extensions' 

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

# Use spaces to fill in the gaps between words.
# Each line should contain as many words as possible.
# Use '\n' to separate lines.
# Gap between words can't differ by more than one space.
# Lines should end with a word not a space.
# '\n' is not included in the length of a line.
# Large gaps go first, then smaller ones: 'Lorem---ipsum---dolor--sit--amet' (3, 3, 2, 2 spaces).
# Last line should not be justified, use only one space between words.
# Last line should not contain '\n'
# Strings with one word do not need gaps ('somelongword\n').

def justify(text, width)
  justify_lines text.split(/\W+/), width
end

def spaces(words, width)
  total = words.map(&:size).reduce(:+)
  spaces = width - total - words.length + 2
  words[0..-2].join(' ') + (' ' * spaces) + words.last + "\n"
end

def scan_line(words, width)
  length, line = 0, []
  is_smaller = -> { length + line.length - 1 <= width }
  while words.length > 0 && is_smaller.call
    line << words.shift
    length += line.last.length
  end
  words.unshift(line.pop) unless is_smaller.call
  [line, words]
end

def justify_lines(words, width)
  line, words = scan_line words, width
  return line.join(' ') if words.length == 0
  spaces(line, width) + justify_lines(words, width)
end

require 'faker'
class Rantly 
  def words
    Rantly(50) { choose *Faker::Lorem.words(100) }.join ' '
  end
end

class String
  def to_lines
    split "\n"
  end

  def to_words
    split ' '
  end

  def count_spaces
    count ' '
  end
end

class Array
  def count_letters
    map(&:length).reduce(:+)
  end
end

RSpec::Matchers.define :starts_with_a_word do |expected|
  match do |actual|
    actual.match /^\w/
  end
end
RSpec::Matchers.define :ends_with_a_word do |expected|
  match do |actual|
    actual.match /\w$/
  end
end

describe "Justifying text - " do
  let(:text) { lambda { |r| r.words } }
  let(:width) { 30 }

  it "scan line" do
    line, words = scan_line 'laudantium debitis enim labore sonoma'.split(' '), 30
    expect(words).to eq ['sonoma']
  end

  it "returns the same text when no counting spaces nor \\n" do
    property_of(&text).check do |text| 
      actual = justify(text, width).gsub("\n", ' ').split(/\s+/).join ' '
      expect(actual).to eq text
    end
  end

  context "the last line" do
    it "has no \\n at the end" do
      property_of(&text).check do |text| 
        actual = justify(text, width)[-1]
        expect(actual).not_to eq "\n"
      end
    end

    it "has only one space between each word" do
      property_of(&text).check do |text| 
        line = justify(text, width).to_lines.last
        expect(line.to_words.count).to eq line.count_spaces + 1
      end
    end
  end

  context "every line but the last" do
    it "has the maximum number of words" do
      property_of(&text).check do |text|
        lines = justify(text, width).to_lines
        (0..lines.count-2).each do |i|
          current = lines[i].to_words
          total = current.size - 1 + current.count_letters
          next_word = lines[i+1].to_words.first
          msg = "'#{lines[i]}' (#{total}) + '#{next_word}' (#{next_word.size}) + 1 > #{width}"
          expect(total + next_word.size + 1).to be > width, msg
        end
      end
    end

    it "justifies each line to width characters" do
      property_of(&text).check do |text|
        lines = justify(text, width).to_lines[0..-2]
        lines.each do |line|
          expect(line.size).to be == width, "The line '#{line}' has size #{line.size} != #{width}"
        end
      end
    end

    it "divides spaces evenly +/- 1" do
      property_of(&text).check do |text|
        lines = justify(text, width).to_lines[0..-2]
        lines.each do |line|
          spaces = line.scan(/\s+/)
          expect(spaces.size).to be <= 2, "Spaces are not even +/- 1 in '#{line}'"
        end
      end
    end

    it "starts with a word and ends with a word" do
      property_of(&text).check do |text|
        lines = justify(text, width).to_lines[0..-2]
        lines.each do |line|
          expect(line).to starts_with_a_word
          expect(line).to ends_with_a_word
        end
      end
    end
  end

end

