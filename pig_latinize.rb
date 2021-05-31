class PigLatinize
    attr_reader :text

    VOWEL_SUFFIX = 'way'
    CONSONANT_SUFFIX = 'ay'

    CONSONANT_SOUNDS = ['qu']

    def initialize(text)        
        raise if text.nil?
        @text = text
    end

    def self.vowel?(char)
        ['a','e','i','o','u','y'].include?(char.downcase)
    end

    def self.consonant?(char)
        !vowel?(char)
    end

    def self.consonant_sound?(word, ptr)
        return true if consonant?(word[ptr])
        return true if CONSONANT_SOUNDS.include?(word[0..ptr])
        false                
    end

    def self.letter?(char)
        # treating apostrophes as letters to match one of the examples
        char.match?(/[[:alpha:],"\'","’"]/)
    end

    def self.tokenize(word)
        result = { :l => [''], :p => [] }
        start_pt = 0
        split_pt = 0

        # handle the letters
        if consonant?(word.chars[0])
            while consonant_sound?(word,split_pt) && split_pt < word.length && letter?(word.chars[split_pt]) do
                split_pt += 1
            end
        end
        if vowel?(word.chars[0])
            while split_pt < word.length && letter?(word.chars[split_pt]) do
                split_pt += 1
            end
        end
        result[:l][0] = word.chars[0..split_pt - 1].join
        
        # handle punctuation
        start_pt = split_pt
        while split_pt < word.length && letter?(word.chars[split_pt]) do
            split_pt += 1
        end

        if consonant?(word[0])
            result[:l][1] = word[start_pt..split_pt - 1]
        end
        
        result[:l] = correct_case(result[:l])
        result[:p][0] = word.chars[split_pt..word.length - 1].join

        result
    end

    def self.char_case(char)
        char == char.downcase ? 'lower' : 'upper'
    end

    def self.correct_case(tokens)
        if tokens.length > 1
            # if the word was capitalized, tokens[0] needs to be capitalized
            unless char_case(tokens[0]) == char_case(tokens[1])
                tokens[1][0] = tokens[1][0].upcase
                tokens[0][0] = tokens[0][0].downcase
            end
        end        
        tokens
    end

    def self.add_sfx(src, sfx_type)
        tail = sfx_type == :consonant ? CONSONANT_SUFFIX : VOWEL_SUFFIX
        # match suffix case to src case
        capitalize = true
        i = 0
        while i < src.length do
            if src[i].downcase == src[i]
                capitalize = false
                break
            end
            i += 1
        end
        tail = tail.upcase if capitalize
        src + tail
    end

    def self.translate(text)
        result = []
        text.split(' ').each do |word|
            tokens = tokenize(word)
            cyphertext = tokens[:l][0]
            if vowel?(cyphertext[0])
                result.push(add_sfx(cyphertext, :vowel) + tokens[:p][0])
            else
                result.push(add_sfx(tokens[:l][1] + cyphertext, :consonant) + tokens[:p][0])
            end
        end        
        result.join(' ')
    end

    def translate
        self.class.translate(text)
    end
end

if ARGV.count > 0
    puts PigLatinize.new(ARGV.join(' ')).translate
else
    puts "Usage: pig_latinize <text>"
end
