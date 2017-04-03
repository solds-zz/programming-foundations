require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')
LANGUAGE = 'en'

def messages(message, lang = LANGUAGE)
  MESSAGES[lang][message]
end

def prompt(message)
  puts("=> #{message}")
end

def valid_number?(number)
  number =~ /^\d+(.\d+)?$/
end

def operation_to_message(operator)
  message = case operator
            when '+'
              messages('adding')
            when '-'
              messages('subtracting')
            when '*'
              messages('multiplying')
            when '/'
              messages('dividing')
            end
  message
end

number1 = 0
number2 = 0
operator = ''

prompt(messages('welcome'))

name = ''
loop do
  name = gets.chomp

  if name.empty?
    prompt(messages('valid_name'))
  else
    break
  end
end

prompt("#{messages('hello')}, #{name}.")

loop do # main loop
  loop do
    prompt(messages('first_num'))
    number1 = gets.chomp

    if valid_number?(number1)
      number1 = number1.to_f
      break
    else
      prompt(messages('invalid_num'))
    end
  end

  loop do
    prompt(messages('second_num'))
    number2 = gets.chomp

    if valid_number?(number2)
      number2 = number2.to_f
      break
    else
      prompt(messages('invalid_num'))
    end
  end

  loop do
    prompt(messages('operator_prompt'))
    operator = gets.chomp

    if %w(+ - * /).include?(operator)
      break
    else
      prompt(messages('invalid_op'))
    end
  end

  prompt("#{operation_to_message(operator)} #{messages('operating')}")

  result = case operator
           when '+'
             number1.to_i + number2.to_i
           when '-'
             number1.to_i - number2.to_i
           when '*'
             number1.to_i * number2.to_i
           when '/'
             unless number2.zero?
               number1.to_f / number2.to_f
             else
               messages('undefined')
             end
           end

  prompt("#{messages('result')} #{result}")

  prompt(messages('another_calc'))
  answer = gets.chomp
  break unless answer.upcase.start_with?('Y')
end

prompt(messages('goodbye'))