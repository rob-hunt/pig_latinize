require_relative "pig_latinize"
require "test/unit"

class TestPigLatinize < Test::Unit::TestCase
    def test_initialize
        assert_raise ( RuntimeError ) { PigLatinize.new(nil) }
        assert_equal('foo', PigLatinize.new('foo').text) 
    end

    def test_vowel?
        ['a','A','e','E','i','I','o','O','u','U','y','Y'].each do |letter|
            assert_true(PigLatinize.vowel?(letter))
        end
        assert_false(PigLatinize.vowel?('b'))
    end    

    def test_consonant?
        ['b','B','x','X','w','W'].each do |letter|
            assert_true(PigLatinize.consonant?(letter))
        end
    end

    def test_letter?
        assert_true(PigLatinize.letter?('a'))
        assert_false(PigLatinize.letter?('.'))
        assert_false(PigLatinize.letter?('!'))
        assert_false(PigLatinize.letter?('?'))
        assert_true(PigLatinize.letter?("'"))
    end

    def test_char_case
        assert_equal('upper', PigLatinize.char_case('H'))
        assert_equal('lower', PigLatinize.char_case('h'))
    end

    def test_correct_case
        assert_equal(['h','Ello'], PigLatinize.correct_case(['H','ello']))
        assert_equal(['h','ello'], PigLatinize.correct_case(['h','ello']))
        assert_equal(['H','ELLO'], PigLatinize.correct_case(['H','ELLO']))
        assert_equal(['eat'], PigLatinize.correct_case(['eat']))
        assert_equal(['Eat'], PigLatinize.correct_case(['Eat']))
        assert_equal(['EAT'], PigLatinize.correct_case(['EAT']))        
    end


    def test_tokenize
        assert_equal(['h','ello'], PigLatinize.tokenize('hello')[:l])
        assert_equal(['h','Ello'], PigLatinize.tokenize('Hello')[:l])
        assert_equal(['H','ELLO'], PigLatinize.tokenize('HELLO')[:l])
        assert_equal(['eat'], PigLatinize.tokenize('eat')[:l])
        assert_equal(['th','ere'], PigLatinize.tokenize('there')[:l])
        assert_equal(['th','Ere'], PigLatinize.tokenize('There')[:l])
        assert_equal(['sh',"e's"], PigLatinize.tokenize("she's")[:l])
        assert_equal(['sh',"e’s"], PigLatinize.tokenize("she’s")[:l])

        assert_equal(
            { :l => ['w','orld'], :p => ['?!']}, 
            PigLatinize.tokenize('world?!'))
        assert_equal(
            { :l => ['eat'], :p => ['...']}, 
            PigLatinize.tokenize('eat...'))
        assert_equal(
            { :l => ['gr','eat'], :p => ['!']}, 
            PigLatinize.tokenize('great!'))
    end

    def test_add_sfx
        assert_equal('ELLOHAY', PigLatinize.add_sfx('ELLOH', :consonant))
        assert_equal('EATWAY', PigLatinize.add_sfx('EAT', :vowel))
    end

    def test_translate
        assert_equal('ellohay', PigLatinize.translate('hello'))
        assert_equal('eatway',PigLatinize.translate('eat'))
        assert_equal('yellowway',PigLatinize.translate('yellow'))
        assert_equal('eatway orldway', PigLatinize.translate('eat world'))
        assert_equal('Ellohay',PigLatinize.translate('Hello'))
        assert_equal('Applesway',PigLatinize.translate('Apples'))
        assert_equal('eatway… orldway?!',PigLatinize.translate('eat… world?!'))
        assert_equal('oolschay',PigLatinize.translate('school'))
        assert_equal("e’sshay eatgray!",PigLatinize.translate("she’s great!"))        
        assert_equal('Ellohay Erethay',PigLatinize.translate('Hello There'))
        assert_equal('ickquay',PigLatinize.translate('quick'))
        assert_equal('ELLOHAY',PigLatinize.translate('HELLO'))
        assert_equal('EATWAY', PigLatinize.translate('EAT'))
        assert_equal('eatway', PigLatinize.translate('eat'))
    end        
end