class PigLatinize
    attr_reader :text

    VOWEL_SUFFIX = 'way'
    CONSONANT_SUFFIX = 'ay'

    def initialize(text)        
        raise if text.nil?
        @text = text
    end

    def self.vowel?(char)
        ['a','e','i','o','u','y'].include?(char.downcase)
    end

    def vowel?(char)
        self.class.vowel?(char)
    end


    def self.consonant?(char)
        !vowel?(char)
    end

    def consonant?(char)
        self.class.consonant?(char)
    end

    def tokenize(word)
        self.class.tokenize(word)
    end    

    def self.tokenize(word)
        result = []
        if vowel?(word.chars[0])
            result = [word]
        else
            result[0] = ''
            split_pt = 0
            while split_pt < word.length && consonant?(word.chars[split_pt]) do
                split_pt += 1
            end

            result[0] = word[0..split_pt - 1]
            result[1] = word[split_pt, word.length-1]
        end
        correct_case(result)
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
        # (if the word started with a vowel, the case is already correct)
        
        tokens
    end

    def self.translate(text)
        result = []
        text.split(' ').each do |word|
            puts "#{word} --> #{}"
            tokens = tokenize(word)
            cyphertext = tokens[0]
            if vowel?(cyphertext[0])
                result.push(cyphertext + VOWEL_SUFFIX)
            else
                result.push(tokens[1] + tokens[0] + CONSONANT_SUFFIX)
            end 
        end
        result.join(' ')
    end

    def translate
        self.class.translate(text)
    end
end

# if ARGV.count > 0
#     puts PigLatinize.new(ARGV.join(' ')).translate
# else
#     puts "Usage: pig_latinize <text>"
# end

