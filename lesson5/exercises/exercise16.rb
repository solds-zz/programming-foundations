def generate_uuid
  hex_chars = "0123456789abcdef".split('')
  uuid = ""
  uuid_size = 36
  hyphen_indices = [8, 13, 18, 23]
  
  uuid_size.times do |i|
    if hyphen_indices.include?(i)
      uuid << '-'
    else
      uuid << hex_chars.sample
    end
  end
  uuid
end

