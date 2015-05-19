# Public: Class to read dictionary of words, parse out 4 letter
# sequences and filter for those sequences that occur in 
# exactly one word of dictionary. Results printed to text files.
#
# Examples
#
#   s = Sequencer.new.read(file_name: 'dictionary.txt')
#   s.process
#   s.output
#
#   Results are written to sequences.txt and words.txt. 
#
# Developed and tested with Ruby MRI 2.2.1.p85

require 'open-uri'

class Sequencer

  def initialize(sequence_size: 4, occurance_limit: 1)
    @sequence_size = sequence_size
    @sequence_occurance_limit = occurance_limit
  end

  # accepts file name, url or IO object
  def read(file_name: nil, url: nil, io: nil)
    fh = open(file_name: file_name, url: url, io: io)
    @words = fh.read.split
    fh.close
    self
  end

  # can choose between fast and slow algorithm
  def process(algorithm: :fast)
    send({fast: :process_fast, slow: :process_slow}[algorithm])
  end

  def output
    File.open('sequences.txt', 'w') do |se|
      File.open('words.txt', 'w') do |wo|
        @results.each do |r|
          se.puts r[:sequence] 
          wo.puts r[:word]
        end
      end
    end
  end

  private

  # returns array of hashes of :sequence and :word values
  # # => [ {:sequence=>"bcde", :word=>"abcdef"},
  #        {:sequence=>"hijk", :word=>"ghijklm"} ]
  def process_fast
    sequence_tally = {}

    @words.each do |word|
      tally_sequences_of(word, sequence_tally)
    end

    @results = sequence_tally.sort.select do |k,v|
      v[:count] == @sequence_occurance_limit
    end.map { |k,v| {sequence: k, word: v[:word]} }
  end

  # splits word into sequences and tallies occurances.  
  # Filters out sequences over occurance limit. 
  def tally_sequences_of(word, sequence_tally)
    sequences_of(word).each do |s|
      if sequence_tally[s]
        next if sequence_tally[s][:count] > @sequence_occurance_limit 
        next if sequence_tally[s][:word] == word #don't count if same sequence in same word
        sequence_tally[s][:count] += 1
      else
        sequence_tally[s] = {count: 1, word: word}
      end
    end
  end

  # splits word into sequences filtering out non alphabet chars
  def sequences_of(word)
    (0..word.length - @sequence_size).inject([]) do |sequence_list, index|
      sequence = word[index, @sequence_size]
      /^[a-zA-Z]+$/ =~ sequence ? sequence_list << sequence : sequence_list
    end
  end

  #for urls, using URI.parse because
  #http://sakurity.com/blog/2015/02/28/openuri.html
  def open(file_name: nil, url: nil, io: nil)
    return File.open(file_name, 'r+') if file_name
    return URI.parse(url).open if url
    return io if io
    raise 'Error: missing or incorrect parameter'
  end


# Process methods using brute force algorithm.  Only for reference purposes.
# Do not use in production.

  def process_slow
    hit_cache = {}
    @results = []
    @words.each do |word|
      sequences_of(word).each do |s|
        @results << {sequence: s, word: word} if appear_once?(s, hit_cache)
      end
    end
    @results.sort_by!{ |r| r[:sequence] }
  end

  def appear_once?(sequence, hit_cache)
    return false if hit_cache[sequence]
    i = 0
    @words.each do |word|
       i += 1 if word.include? sequence
       if i > @sequence_occurance_limit 
         hit_cache[sequence] = :hit
         return false
       end 
    end
    i == 1 ? true : false
  end

end
