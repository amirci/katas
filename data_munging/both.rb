#!/usr/bin/ruby

def parse_dat(file, exp)
  arr = []
  File.open(file, "r").each{|l| arr << exp.match(l.strip) }.close
  arr.compact.map do |v|
    hash = {}
    exp.named_captures.keys.map{|c| hash[c] = v[c]}
    hash
  end
end

puts parse_dat('weather.dat', /^(?<day>[0-9]{1,2})\s+(?<high>[0-9]+)\s+(?<low>[0-9]+)/).max_by{|d| d['high'].to_i-d['low'].to_i }
puts parse_dat('football.dat', /^[0-9]{1,2}\.\s+(?<opponent>[A-Za-z_]+)[\s0-9]+\s+(?<for>[0-9]+)\s+\-\s+(?<against>[0-9]+)\s+[0-9]+$/).min_by{|d| (d['for'].to_i-d['against'].to_i).abs }

