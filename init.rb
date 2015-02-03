require 'rubygems'
require 'bundler'
require 'sequel'
require 'dotenv'
require 'benchmark'
require 'pry'
require './link_provider'

Dotenv.load
DB = Sequel.connect(ENV['DATABASE_URI'])

INSERT_SIZE = ENV['INSERT_SIZE'].to_i
READ_SIZE = ENV['READ_SIZE'].to_i
TEST = ENV['TEST'].to_s

testfile = './test' << TEST << '.rb'
if !File.exist?(testfile)
  puts "No test file found " << testfile
  exit
end

def pretty_number(num)
  num.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end

puts "Starting test " << testfile
puts "  Inserts: " << pretty_number(INSERT_SIZE)
puts "  Reads:   " << pretty_number(READ_SIZE)
puts ""

require testfile
