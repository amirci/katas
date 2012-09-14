#!/usr/bin/ruby

days = []
File.open("weather.dat", "r")
  .each{|l| days << /^(?<day>[0-9]{1,2})\s+(?<high>[0-9]+)\s+(?<low>[0-9]+)/.match(l.strip) }
  .close

puts days
  .compact
  .map{|d| {day: d[:day].to_i, low: d[:low].to_i, high: d[:high].to_i} } #convert to hash. how is this not a method?
  .max_by{|d| d[:high]-d[:low] }
  
