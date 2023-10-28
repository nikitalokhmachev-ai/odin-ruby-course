def substrings(str, dictionary)
  hashmap = {}
  dictionary.each do |word|
    counts = str.downcase.scan(/(?=#{word})/).count
    hashmap[word] = counts if counts.positive?
  end
  hashmap
end

dictionary = %w[below down go going horn how howdy it i low own part partner sit]
puts substrings("Howdy partner, sit down! How's it going?", dictionary)
