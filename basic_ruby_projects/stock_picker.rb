def stock_picker(prices)
  max_val = -1
  day1 = 0
  day2 = 0
  (0...prices.length - 1).each do |i|
    (i + 1...prices.length).each do |j|
      diff = prices[j] - prices[i]
      next unless max_val < diff

      day1 = i
      day2 = j
      max_val = diff
    end
  end
  [day1, day2]
end

puts stock_picker([17, 3, 6, 9, 15, 8, 6, 1, 17])
