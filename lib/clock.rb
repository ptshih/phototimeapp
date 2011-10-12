require 'clockwork'

handler do |job|
  puts "Running #{job}"
end

every(3.minutes, 'copyfiles.job')