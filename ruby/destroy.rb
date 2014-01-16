#!/usr/bin/env ruby
require './destroyer'

d = Destroyer.new
newlines_since_result = 0
result = nil

while char=STDIN.getc
	if result
		newlines_since_result += 1
	else
		result = d.process(char)
		puts result if result
	end

	if newlines_since_result == 2
		d = Destroyer.new
		result = nil
		newlines_since_result = 0
	end
end

