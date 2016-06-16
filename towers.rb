#!/usr/bin/ruby

require 'pry'
require 'json'

class TowerOfHanoi
  def initialize(height)
    @height = height
    @blank = ' ' * @height
  end

def create_board(type)
  tower1, tower2, tower3 = [] , [], [] 
  1.upto(@height) do |n|
    tower1 << ('o' * n) + (' ' * (@height-n))
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
  @height.times do |n|
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

def find_top_piece(tower, brd)
  brd[tower].detect {|n| n!= @blank}
end

def move_piece(move, brd, piece)
  brd[move[0]].delete(piece)
  brd[move[0]].unshift(@blank)
  space = brd[move[1]].rindex(@blank)
  brd[move[1]].insert((space+1), piece)
  brd[move[1]].shift
  brd
end

def make_move(move, brd)
  piece = find_top_piece(move[0], brd)
  target = find_top_piece(move[1], brd)
  if (target == nil || target.count('o')>piece.count('o'))
    move_piece(move, brd, piece)    
  else
    puts "That's not a valid move, try again."
  end
  brd
end

def user_wins?(brd)
  winning_brd = create_board('winning')
  brd == winning_brd
end

def play
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
      brd = make_move(move, brd)
      display_board(brd)
      
      if user_wins?(brd)
        puts "You did it!"
        break
      end
    end

  end
end
end





  






