def output(message)
  prompt = '=>'
  puts("#{prompt} #{message}")
end

def input_number
  loop do
    input = gets.chomp
    # Allow inputting '$' and '%' on numbers
    input.gsub!(/[$%]/, '')
    return input.to_f if input =~ /^\d+(.\d+)?$/
  end
end

output('Welcome to Loan Calculator!')

loop do
  output('What is the loan amount?')
  loan_amount = input_number

  output('What is the APR?')
  interest = input_number
  # Allow inputting X% or 0.XX
  interest /= 100.0 if interest > 1.0
  interest /= 12.0

  output('What is the loan duration (in years)?')
  loan_duration = input_number
  loan_duration *= 12.0

  payments = loan_amount * (interest / (1.0 - (1.0 + interest)**-loan_duration))
  payments = payments.round(2)

  output("Monthly payments: $#{payments}")

  output('Do another calculation? [Yn]')
  answer = gets.chomp
  break if answer =~ /^[Nn]/
end

output('Thank you for using Loan Calculator!')
output('Goodbye...')
