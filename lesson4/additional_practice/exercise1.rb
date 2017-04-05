flintstones = %w[Fred Barney Wilma Betty Pebbles BamBam]
new_flintstones = {}

flintstones.each_with_index do |name, index|
  new_flintstones[name] = index
end