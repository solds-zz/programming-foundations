hsh = { 
  first: ['the', 'quick'], 
  second: ['brown', 'fox'], 
  third: ['jumped'], 
  fourth: ['over', 'the', 'lazy', 'dog'] 
}

hsh.each_value do |words|
  words.join.split('').each do |letter|
    puts letter if letter =~ /[aeiou]/i
  end
end
