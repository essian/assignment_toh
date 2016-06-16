require 'pry'
require 'json'

@n=4
@blank = " | "


def create_board(type)
  tower1, tower2, tower3 = [] , [], [] 
  1.upto(@n) do |n|
    tower1 << 'o' * n
    tower2 << @blank
    tower3 << @blank
  end
  if type == "new"
    [tower1, tower2, tower3]
  elsif type == "winning"
    [tower3, tower2, tower1]
  end
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
  target = brd[move[1]].detect {|n| n!= @blank}
  binding.pry
  if (target == nil || target.count('o')>piece.count('o'))
    brd[move[0]].delete(piece)
    brd[move[0]].unshift(@blank)
    space = brd[move[1]].rindex(@blank)
    brd[move[1]].insert((space+1), piece)
    brd[move[1]].shift
    display_board(brd)
    brd
  else
    puts "That's not a valid move, try again."
    brd
  end
end

def user_wins?(brd)
  winning_brd = create_board('winning')
  brd == winning_brd
end

welcome
brd = create_board('new')
display_board(brd)

loop do
  prompt "Enter move:"
  move = gets.chomp
  if (move.downcase =~ /q.*/)
    prompt "You quit the game. Thanks for playing!"
    break
  else 
    begin
      JSON.parse(move)
    rescue
      puts "You must enter a valid move"
      next
    else
      move = JSON.parse(move)
    end
    if move.size != 2
      puts "You must enter an array of 2 values"
      next
    end
    if move[0] == move[1]
      puts "You cannot move a piece to its current position"
      next
    end
    unless ((0..2).include?(move[0]) && (0..2).include?(move[1]))
      puts "You can only choose locations 0, 1 or 2"
      next
    end
    brd = move_piece(move, brd)
    
    if user_wins?(brd)
      puts "You did it!"
      break
    end
  end

end





  






