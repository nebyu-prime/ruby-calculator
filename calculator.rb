#!/usr/bin/env ruby

def safe_expression?(s)
  s.strip!
  return false if s.empty?
  # allow digits, whitespace, + - * / ( ) . and ^ for power
  !!(s =~ /\A[0-9\s+\-*/().^]+\z/)
end

def eval_expression(s)
  s = s.gsub('^', '**')
  begin
    result = eval(s)
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
