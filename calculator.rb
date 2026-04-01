#!/usr/bin/env ruby

def safe_expression?(s)
  s = s.to_s.strip
  return false if s.empty?
  return false if s.length > 200
  # allow digits, whitespace and operators: + - * / ( ) . ^
  return false unless s =~ /\A[0-9\s+\-*\/().\^]+\z/

  operators = %w[+ - * / ^]
  # disallow three or more operators in a row
  return false if s =~ /[+\-*\/\^]{3,}/

  # disallow two different consecutive operators (allow '**')
  s.chars.each_cons(2) do |a, b|
    if operators.include?(a) && operators.include?(b)
      next if a == '*' && b == '*'
      return false
    end
  end

  # cannot end with an operator (except ')')
  last = s[-1]
  return false if operators.include?(last)

  # if starts with operator, only + or - allowed (unary)
  first = s[0]
  return false if operators.include?(first) && !['+', '-'].include?(first)

  true
end

def eval_expression(s)
  s = s.gsub('^', '**')
  begin
    result = Kernel.eval(s)
    puts result
  rescue ZeroDivisionError
    warn "Error: Division by zero"
  rescue SyntaxError, StandardError => e
    warn "Error: #{e.class} - #{e.message}"
  end
end

if ARGV.any?
  expr = ARGV.join(' ')
  if safe_expression?(expr)
    eval_expression(expr)
  else
    warn "Unsafe expression. Only digits and operators + - * / ( ) . ^ are allowed."
    exit 1
  end
else
  puts "Ruby Calculator REPL. Type 'exit' or 'quit' to leave."
  loop do
    print "calc> "
    line = STDIN.gets
    break if line.nil?
    line = line.strip
    break if ['exit', 'quit', 'q'].include?(line.downcase)
    next if line.empty?
    if safe_expression?(line)
      eval_expression(line)
    else
      warn "Unsafe expression. Only digits and operators + - * / ( ) . ^ are allowed."
    end
  end
end
