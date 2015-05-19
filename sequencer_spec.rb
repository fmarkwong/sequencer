# Developed and tested with Ruby MRI 2.2.1.p85
# and RSpec 3.2.3

require 'rspec'
require_relative 'sequencer'

describe Sequencer do

  describe "#process" do
    let(:words) { '' }
    let(:sequencer) { Sequencer.new }

    subject { sequencer.read(io: StringIO.new(words)).process }

    context 'words with sequences occuring once only' do
      let(:words) { %w(abcdef ghijklm  nopqrstuv).join("\n") }

      it 'should return all sequences' do
        expect(subject).to eq([
          {:sequence=>"abcd", :word=>"abcdef"},
          {:sequence=>"bcde", :word=>"abcdef"},
          {:sequence=>"cdef", :word=>"abcdef"},
          {:sequence=>"ghij", :word=>"ghijklm"},
          {:sequence=>"hijk", :word=>"ghijklm"},
          {:sequence=>"ijkl", :word=>"ghijklm"},
          {:sequence=>"jklm", :word=>"ghijklm"},
          {:sequence=>"nopq", :word=>"nopqrstuv"},
          {:sequence=>"opqr", :word=>"nopqrstuv"},
          {:sequence=>"pqrs", :word=>"nopqrstuv"},
          {:sequence=>"qrst", :word=>"nopqrstuv"},
          {:sequence=>"rstu", :word=>"nopqrstuv"},
          {:sequence=>"stuv", :word=>"nopqrstuv"}
        ])
      end
    end

    context 'words with with sequences occuring more than once' do
      let(:words) { %w(arrows carrots give me).join("\n") }

      it 'should return sequences occuring in one word only' do
        expect(subject).to eq([
          {:sequence=>"carr", :word=>"carrots"},
          {:sequence=>"give", :word=>"give"},
          {:sequence=>"rots", :word=>"carrots"},
          {:sequence=>"rows", :word=>"arrows"},
          {:sequence=>"rrot", :word=>"carrots"},
          {:sequence=>"rrow", :word=>"arrows"}
        ])
      end
    end

    context 'words with non-letter characters' do
      let(:words) { %w(ar^3ro@@ws c$!arrots g.ive ---me).join("\n") }

      it 'should return letter sequences only' do
        expect(subject).to eq([
          {:sequence=>"arro", :word=>"c$!arrots"},
          {:sequence=>"rots", :word=>"c$!arrots"},
          {:sequence=>"rrot", :word=>"c$!arrots"}
        ])
      end
    end

    context 'word with the same sequence twice' do
      let(:words) { %w(alfalfa falf lfdal).join("\n") }

      it 'should register as appearing in one word' do
        expect(subject).to eq([
          {:sequence=>"alfa", :word=>"alfalfa"},
          {:sequence=>"fdal", :word=>"lfdal"},
          {:sequence=>"lfal", :word=>"alfalfa"},
          {:sequence=>"lfda", :word=>"lfdal"}
        ])
      end
    end
  end

end
