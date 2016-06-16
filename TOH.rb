require 'pry'
require 'json'

@n=4
@blank = " | "


def initialize_board
  tower1 = []
  tower2 = []
  tower3 = []  
  1.upto(@n) do |n|
    tower1 << 'o' * n
    tower2 << @blank
    tower3 << @blank
  end
  board =[tower1, tower2, tower3]
end

def winning_brd
  tower1 = []
  tower2 = []
  tower3 = []
  
  1.upto(@n) do |n|
    
    tower1 << @blank
    tower2 << @blank
    tower3 << 'o' * n
  end

  [tower1, tower2, tower3]

end

def display_board(board)
  @n.times do |n|
    print board[0][n] + '   '
    print board[1][n] + '   '
    print board[2][n] + '   '
    puts ''
  end
end

def prompt(content)
  puts ">> " + content
end

def welcome
  prompt "Welcome to Tower of Hanoi!"
  prompt "Instructions:"
  prompt "Enter where you'd like to move from and to in the format [1, 3]. Enter 'q' to quit."
  prompt "Current board: "
end

def move_piece(move, brd)
  prompt "piece moved"
  piece = brd[move[0]].detect {|n| n!= @blank}
  brd[move[0]].delete(piece)
  brd[move[0]].unshift(@blank)
  space = brd[move[1]].rindex(@blank)
  brd[move[1]].insert((space+1), piece)
  brd[move[1]].shift
  binding.pry
  brd
end

def user_wins?(brd)
  brd == winning_brd
end

welcome
brd = initialize_board
display_board(brd)

loop do
  prompt "Enter move:"
  move = gets.chomp
  if (move.downcase =~ /q.*/)
    prompt "You quit the game. Thanks for playing!"
    break
  else 
    move = JSON.parse(move)
    brd = move_piece(move, brd)
    display_board(brd)
    if user_wins?(brd)
      puts "You did it!"
      break
    end
  end

end





  






