
def p_puts (message = '', fill_char = ' ', line_width = 40)
  line_width = message.length+2 if message.length > line_width
  l_length = (line_width-message.length)/2
  r_length = (line_width - message.length - l_length)
  puts "|#{fill_char*l_length}#{message}#{fill_char*r_length}|"
end