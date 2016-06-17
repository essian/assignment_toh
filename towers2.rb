#!/usr/bin/ruby

require 'pry'
require 'json'

class TowerOfHanoi
  def initialize(num)
    @num = num
  end

  def prompt(content)
    puts "\n>> " + content
  end

  def welcome
    system('clear')
      prompt "Welcome to Tower of Hanoi!"
      prompt "Instructions:"
      prompt "Enter where you'd like to move from and to in the format [1, 3]. Enter 'q' to quit."
      prompt "Your goal is to move the tower from peg 1 to peg three."
      prompt "You can only move one piece at a time, and a larger piece can never be placed on top of a smaller piece."
      prompt "Current board: \n\n"
  end

  def create_board(n, type)
    tower1, tower2, tower3 = [], [], []
    n.times { |n| tower1 << n+1 }
    type == :initial ? [tower1, tower2, tower3] : [tower2, tower3, tower1]
  end

  def convert_to_array(move)
    begin
      JSON.parse(move)
    rescue
      puts "You must enter a valid array"
    end
  end

  def move_piece(move, brd)
    start_tower = move[0] - 1 
    finish_tower = move[1] - 1
    piece = brd[start_tower].shift
    brd[finish_tower].unshift(piece)
    brd
  end

  def user_quit?(move)
    move.downcase =~ /q.*/
  end

  def valid?(move, brd)
      if move.size != 2
        puts "You must enter an array of 2 values" 
      elsif !(move[0].between?(1, 3) && move[1].between?(1, 3))
        puts "You can only choose locations 1, 2 or 3" 
      elsif brd[move[0]-1].first==nil
        puts "There are no pieces in that tower to move, try again." 
      elsif move[0] == move[1]
        puts "You cannot move a piece to its current position" 
      elsif !brd[move[1]-1].first.nil? && (brd[move[0]-1].first > brd[move[1]-1].first)
        puts "You can only place a piece on top of a larger piece or the base"
      else
        true
      end
    end

    def pad(array)
      diff = @num-array.size
      diff.times {|n|array.unshift 0}
      array
    end

    def display_board(brd)
      system('clear')
      welcome
      print_brd = brd.map { |j| pad(j.dup) }
      @num.times do |n|
        3.times { |tower|print (('o' * print_brd[tower][n]).ljust(@num+1, ' ')) }
        puts "\n"
      end
      3.times { |n| print (n+1).to_s.ljust(@num+1, ' ') }
      puts "\n"
    end

  def play
    brd = create_board(@num, :initial)
    winning_brd = create_board(@num, :winning)
    display_board(brd)
    loop do
      prompt "What is your move"
      move = gets.chomp
      break if user_quit?(move)
      move = convert_to_array(move)
      next if !move
      next if !valid?(move, brd)
      brd = move_piece(move, brd)  
      display_board(brd)
      if brd == winning_brd
        puts "You did it!"
        break
      end
    end
    puts "Thanks for playing. You were amazing."
  end

end
