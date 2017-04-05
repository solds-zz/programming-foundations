statement = "The Flintstones Rock"
letter_frequencies = Hash.new(0)

statement.split('').each do |letter|
  letter_frequencies[letter] += 1 if letter =~ /[a-z]/i
end