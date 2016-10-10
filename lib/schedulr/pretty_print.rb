
def p_puts (message)
  s_length = (60-message.length)/2
  puts "#{'-'*s_length}#{message}#{'-'*s_length}"
end