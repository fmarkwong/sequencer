# Sequencer

Public: Class to read dictionary of words, parse out 4 letter
sequences and filter for those sequences that occur in 
exactly one word of dictionary. Results printed to text files.

Example:
```ruby
   s = Sequencer.new.read(file_name: 'dictionary.txt')
   s.process
   s.output
```

Results are written to sequences.txt and words.txt. 

Developed and tested with Ruby MRI 2.2.1.p85
and RSpec 3.2.3
