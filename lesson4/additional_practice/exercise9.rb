def titleize(string)
  new_string = string.split.map do |word|
    word.capitalize
  end
  new_string.join(' ')
end