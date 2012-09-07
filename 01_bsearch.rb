require 'test/unit'

class TestChop < Test::Unit::TestCase
	
	def chop(n, h)
		low = 0
		high = h.size
		mid = low+(high-low/2)-1
		#puts "Looking for #{n} in #{h.inspect} (low/mid/high: #{low}/#{mid}/#{high})"
		
		if h.size==0 || h.size==1 && h[mid] != n
			-1
		elsif h[mid] > n
			chop n, h[low,mid]
		elsif h[mid] < n
			chop n, h[mid,high]
		else
			mid
		end
	end
	
	def test_chop
			assert_equal(-1, chop(3, []))
			assert_equal(-1, chop(3, [1]))
			assert_equal(0,  chop(1, [1]))
			
			assert_equal(0,  chop(1, [1, 3, 5]))
			assert_equal(1,  chop(3, [1, 3, 5]))
			assert_equal(2,  chop(5, [1, 3, 5]))
			assert_equal(-1, chop(0, [1, 3, 5]))
			assert_equal(-1, chop(2, [1, 3, 5]))
			assert_equal(-1, chop(4, [1, 3, 5]))
			assert_equal(-1, chop(6, [1, 3, 5]))
			
			assert_equal(0,  chop(1, [1, 3, 5, 7]))
			assert_equal(1,  chop(3, [1, 3, 5, 7]))
			assert_equal(2,  chop(5, [1, 3, 5, 7]))
			assert_equal(3,  chop(7, [1, 3, 5, 7]))
			assert_equal(-1, chop(0, [1, 3, 5, 7]))
			assert_equal(-1, chop(2, [1, 3, 5, 7]))
			assert_equal(-1, chop(4, [1, 3, 5, 7]))
			assert_equal(-1, chop(6, [1, 3, 5, 7]))
			assert_equal(-1, chop(8, [1, 3, 5, 7]))
	end
end