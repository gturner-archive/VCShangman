require 'sinatra'

def all_letters(str)
    str[/[a-zA-Z]+/]  == str
end

$source_lines = IO.readlines('enable.txt')
incorrect = ""
message = ""
home_error = ""
game_error = ""

get '/' do
	home_error = ""
	incorrect = ""
	message = ""
    erb :home, :locals => {:home_error => home_error}   
end

post '/game' do
	$source_lines_filtered = $source_lines.select{|item| item.chomp.length == params[:difficulty].to_i}
	if $source_lines_filtered.length >= 1
		number = rand($source_lines_filtered.length - 1)
		$word = $source_lines_filtered[number]
		$word_blanks = '_' * $word.chomp.length
		$word_to_guess = $word.chomp.split("")
		erb :index, :locals => {:game_error => game_error, :message => message, :incorrect => incorrect, :word_blanks => $word_blanks}
	else
		home_error = "Please enter a valid integer between 2 and 28"
		erb :home, :locals => {:home_error => home_error}
	end 
end


get'/game' do
	message = ""
	guess = params['guess'].downcase
	if !guess.nil? && guess.length == 1 && all_letters(guess)
		game_error = ""
		if !$word_to_guess.include? guess
			incorrect += guess
		elsif $word_to_guess.include? guess
			while $word_to_guess.index(guess) != nil 
				index_of_guess = $word_to_guess.index(guess)
				$word_to_guess[index_of_guess] = "" 
				$word_blanks[index_of_guess] = guess
			end
		end
	else
		game_error = "please enter one valid character, A - Z"
	end
	if incorrect.length >= 5
		message = "DEFEAT!, your word was #{$word}"
		incorrect = ""
	end
	if $word_blanks == $word.chomp 
		message = "VICTORY! Way to go champ!"
		incorrect = ""
	end
	erb :index, :locals => {:game_error => game_error, :message => message, :incorrect => incorrect, :word_blanks => $word_blanks}
end

