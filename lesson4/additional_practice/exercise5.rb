flintstones = %w[Fred Barney Wilma Betty BamBam Pebbles]

flintstones.find_index { |name| name.start_with?('Be') }