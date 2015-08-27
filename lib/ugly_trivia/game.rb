module UglyTrivia
  class Player
    attr_accessor :place, :purse, :in_penalty_box
    attr_reader :name
    def initialize(name)
      @name = name
      @place = 0
      @purse = 0
      @in_penalty_box = false
    end
    def win_one_purse
      self.purse += 1
      puts "#{self.name} now has #{self.purse} Gold Coins."
    end
    def has_won?
      !(self.purse == 6)
    end
    def move_on(roll)
      self.place += roll
      self.place = self.place - 12 if self.place > 11
      puts "#{self.name}'s new location is #{self.place}"
    end
  end

  class Game
    def  initialize
      @players = []

      @pop_questions = []
      @science_questions = []
      @sports_questions = []
      @rock_questions = []

      @is_getting_out_of_penalty_box = false

      50.times do |i|
        @pop_questions.push "Pop Question #{i}"
        @science_questions.push "Science Question #{i}"
        @sports_questions.push "Sports Question #{i}"
        @rock_questions.push "Rock Question #{i}"
      end
    end

  public
    def is_playable?
      @players.length >= 2
    end
    def add(player_name)
      @players << Player.new(player_name)

      puts "#{player_name} was added"
      puts "They are player number #{@players.length}"
    end
    def roll(roll)
      @current_player ||= @players[0] 
      puts "#{@current_player.name} is the current player"
      puts "They have rolled a #{roll}"
      forward(roll) if can_forward?(roll)
    end

    def was_correctly_answered
      puts "Answer was corrent!!!!"
      @current_player.win_one_purse
      winner = @current_player.has_won?
      next_player
      return winner
    end

    def wrong_answer
      puts 'Question was incorrectly answered'
      puts "#{@current_player.name} was sent to the penalty box"
      @current_player.in_penalty_box = true
    end

    def next_player
      next_index = @players.index(@current_player) + 1
      if next_index == @players.length
        @current_player = @players[0] 
      else
        @current_player = @players[next_index]
      end
    end

  private
    def ask_question
      puts @pop_questions.shift if current_category == 'Pop'
      puts @science_questions.shift if current_category == 'Science'
      puts @sports_questions.shift if current_category == 'Sports'
      puts @rock_questions.shift if current_category == 'Rock'
    end
    def can_forward?(roll)
      if @current_player.in_penalty_box == true
        can_getout_penalty_box?(roll)
      else
        true
      end
    end

    def can_getout_penalty_box?(roll)
        if roll % 2 != 0
          return @is_getting_out_of_penalty_box = true
          puts "#{@current_player.name} is getting out of the penalty box"
        else
          puts "#{@current_player.name} is not getting out of the penalty box"
          return @is_getting_out_of_penalty_box = false
        end
    end

    def forward(roll)
      @current_player.move_on(roll)
      puts "The category is #{current_category}"
      ask_question
    end

    def current_category
      case @current_player.place
        when 0,4,8 then return 'Pop'
        when 1,5,9 then return 'Science'
        when 2,6,10 then return 'Sports'
        else return 'Rock'
      end
    end

  end
end
