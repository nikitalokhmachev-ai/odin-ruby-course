def swap(array, idxi, idxj)
  temp = array[idxi]
  array[idxi] = array[idxj]
  array[idxj] = temp
  array
end

def bubble_sort(array)
  (0...array.length).each do |_|
    (0...array.length - 1).each do |i|
      array = swap(array, i, i + 1) if array[i] > array[i + 1]
    end
  end
  array
end

puts bubble_sort([12_321, 3, 78, 2, 0, 2, 100])
