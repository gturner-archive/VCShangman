require 'sinatra'
require 'sinatra/reloader'

$source_lines = IO.readlines('enable.txt')
incorrect = ""
message = ""


get '/' do
	incorrect = ""
	message = ""
    erb :home   
end

post '/game' do
	$source_lines_filtered = $source_lines.select{|item| item.chomp.length == params[:difficulty].to_i}
	number = rand($source_lines_filtered.length - 1)
	$word = $source_lines_filtered[number]
	$word_blanks = '_' * $word.chomp.length
	$word_to_guess = $word.chomp.split("")
	erb :index, :locals => {:message => message, :word_to_guess => $word_to_guess, :incorrect => incorrect, :word_blanks => $word_blanks}
end


get'/game' do
	message = ""
	guess = params['guess']
	if !guess.nil? && guess.length == 1
		if !$word_to_guess.include? guess
			incorrect += guess
		elsif $word_to_guess.include? guess
			while $word_to_guess.index(guess) != nil 
				index_of_guess = $word_to_guess.index(guess)
				$word_to_guess[index_of_guess] = "" 
				$word_blanks[index_of_guess] = guess
			end
		end
	end
	if incorrect.length >= 5
		message = "DEFEAT"
		incorrect = ""
	end
	if $word_blanks == $word.chomp 
		message = "VICTORY!"
		incorrect = ""
	end
	erb :index, :locals => {:message => message, :word_to_guess => $word_to_guess, :incorrect => incorrect, :word_blanks => $word_blanks}
end

