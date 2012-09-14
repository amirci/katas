#!/usr/bin/ruby

games = []
File.open("football.dat", "r")
  .each{|l| games << /^[0-9]{1,2}\.\s+(?<opponent>[A-Za-z_]+)[\s0-9]+\s+(?<for>[0-9]+)\s+\-\s+(?<against>[0-9]+)\s+[0-9]+$/.match(l.strip) }
  .close

puts games
  .compact
  .map{|d| {opponent: d[:opponent], for: d[:for].to_i, against: d[:against].to_i} } #convert to hash. how is this not a method?
  .min_by{|d| (d[:for]-d[:against]).abs }
  
