#!/usr/bin/env ruby
require 'benchmark'
require_relative 'sequencer'


s = Sequencer.new
s.read(url: 'https://s3.amazonaws.com/cyanna-it/misc/dictionary.txt')
s.process
s.output



# Benchmark.bm(15) do |bm|
#   bm.report('process(slow)') { s.process(algorithm: :slow) }
#   bm.report('process(fast)') { s.process }
# end
