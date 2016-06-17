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
      tower1 << ('o' * n).ljust(@height+1, ' ')
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
    welcome
    @height.times do |n|
      print board[0][n]
      print board[1][n]
      print board[2][n]
      puts ''  
    end
    3.times { |n| print (n+1).to_s.ljust(@height+1, ' ') }
    puts "\n"
  end

  def prompt(content)
    puts ">> " + content
  end

  def welcome
    system('clear')
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
    if (target.nil? || target.count('o')>piece.count('o'))
      move_piece(move, brd, piece)
    else
      raise 
    end
    brd
  end

  def user_wins?(brd)
    winning_brd = create_board('winning')
    brd == winning_brd
  end

  def user_quit?(move)
    move.downcase =~ /q.*/
  end

  def convert_to_array(move)
    begin
      JSON.parse(move).map { |m| m - 1 }
    rescue
      puts "You must enter a valid array"
    end
  end

  def valid?(move, brd)
    if move.size != 2
      puts "You must enter an array of 2 values" 
    elsif !(move[0].between?(0,2) && move[1].between?(0, 2))
      puts "You can only choose locations 1, 2 or 3" 
    elsif find_top_piece(move[0], brd)==nil
      puts "There are no pieces in that tower to move, try again." 
    elsif move[0] == move[1]
      puts "You cannot move a piece to its current position" 
    else
      true
    end
  end

  def play  
    brd = create_board('new')
    display_board(brd)
    loop do
      prompt "Enter move:"
      move = gets.chomp
      break if user_quit?(move)
      move = convert_to_array(move)
      next if !move
      next if !valid?(move, brd)
      begin
        brd = make_move(move, brd)
      rescue
        puts "You can't place a larger piece on a smaller piece. Try again."
        next
      end
      display_board(brd)
      if user_wins?(brd)
        puts "You did it!"
        break
      end
    end
    puts "Thanks for playing. You were hilarious."
  end
end






  






