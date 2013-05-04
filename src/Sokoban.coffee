
# Eddie eblundell@gmail.com
# 12 December 2012 12/12/12

# Sakoban!Rules

# - Only one box can be pushed at a time.
# - A box cannot be pulled.
# - The player cannot walk through boxes or walls.
# - The puzzle is solved when all boxes are located at storage locations.

class Sokoban

  currentLevel: 1
  maxLevel:4
  container: $('#container') # TODO: Change this, outside class
  paused: false

  constructor:(stage)->
    @stage = stage
    @UI = new UI(@)
    @setup()

  start:->
    @paused = false

  pause: ->
    @paused = true

  setup:->
    @canvas = document.getElementById(@stage)
    @context = @canvas.getContext('2d')

    @width = @canvas.width
    @height = @canvas.height

  setupControls:->
    that = @
    document.onkeydown = (event)->
      event.preventDefault()

      if that.paused == false
        switch event.keyCode
          when 37 then that.player.move("left")
          when 38 then that.player.move("up")
          when 39 then that.player.move("right")
          when 40 then that.player.move("down")
          when 16 then window.location.reload()
          when 48 then that.loadLevel(3)
  loadLevel:(level,done=false) ->

    that = @
    @level.loadJSON "levels/"+level+".json",->
      that.player.setLevel(that.level)
      that.canvas.height = that.level.getHeight()
      that.currentLevel = level

      if done then done()

  nextLevel:->

    @currentLevel = @currentLevel + 1

    instance = @
    @loadLevel @currentLevel, ->
      instance.start()

  reloadLevel:->

    instance = @
    @loadLevel @currentLevel, ->
      instance.start()

  load:(done)->

    @spriteLoader = new SpriteLoader(done)

    @level = new Level(@spriteLoader)

    @playerSprite = @spriteLoader.load("img/george_0.png")
    @player = new Player(@playerSprite)
    @setupControls()

    that = @
    @level.loadJSON "levels/1.json",->
      that.player.setLevel(that.level)

    @tickInterval = window.setInterval @tick, 1000/10

  tick:=>

    if @paused then return

    if @level.isComplete()
      @UI.showMenu()
      @UI.updateScores()
      @UI.gameOver() if @currentLevel+1 == @maxLevel
      @pause()

    @context.fillStyle = '#eee'
    @context.fillRect(0,0,@width,@height)

    @UI.update()
    @level.render(@context)
    @player.render(@context)

window.Sokoban = {}
window.Sokoban.game = new Sokoban("sokoban")

window.Sokoban.game.load ->
  window.Sokoban.game.start()
