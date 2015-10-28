def palindrome_chain_length(n)
  reverse = -> (num) { num.to_s.reverse.to_i }
  is_palindrome = -> (num) { num == reverse.call(num) }
  steps = 0

  while !is_palindrome.call(n)
    steps += 1
    n = n + reverse.call(n)
  end
  
  steps
end


describe 'Palindrome chain' do
  
  it 'needs 4 times to make 87 palindrome' do
    expect(palindrome_chain_length 87).to eq 4
  end
end