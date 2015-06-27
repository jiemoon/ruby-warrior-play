require 'logger'

class Player

  def initialize
    @health = 20
    @isAttacked = false
    @isPivoted = false
    @isGotWall = false
    @logger = Logger.new(STDOUT)
  end

  def play_turn(warrior)
    if warrior.feel(:backward).wall? then
      @isGotWall = true
    end

    if warrior.health < @health
      @isAttacked = true
    elsif warrior.health == @health
      @isAttacked = false
    end

    if @isPivoted && (warrior.look[0].enemy? ||
       warrior.look[1].enemy? ||
       warrior.look[2].enemy?)
      @isPivoted = true
    else
      @isPivoted = false
    end

    if @isAttacked &&
       !@isPivoted &&
       !@isGotWall && warrior.health > 16
      warrior.pivot!
      @isPivoted = true
      @health = warrior.health
      return 0
    end

    if warrior.health < 7
      if !@isAttacked
        warrior.rest!
        @health = warrior.health
        return 0
      elsif warrior.feel(:backward).empty?
        warrior.walk! :backward
        @health = warrior.health
        return 0
      end
    end

    if warrior.feel.wall? && !@isGotWall then
      warrior.pivot!
      @isGotWall = true
      return 0
    end

    if warrior.feel.stairs? && !@isGotWall then
      warrior.pivot!
      return 0
    end

    if warrior.look[0].captive? ||
       warrior.look[1].captive? ||
       warrior.look[2].captive?
      if warrior.feel.empty?
        warrior.walk!
      elsif warrior.feel.captive?
        warrior.rescue!
      end
    elsif warrior.look[0].enemy? ||
       warrior.look[1].enemy? ||
       warrior.look[2].enemy?
      warrior.shoot!
    elsif warrior.feel.empty?
      warrior.walk!
    end

    @health = warrior.health

  end

end
