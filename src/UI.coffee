

class window.UI
  stepsCounter: $('#step-counter')
  levelCounter: $('#level-counter')
  highscoreTable: $('#highscores')

  nextBtn: $('#next-level')
  restartBtn: $('#restart-level')
  restartGame: $('#restart-game')
  menuDiv: $('#menu')
  statusDiv: $('#game-status')

  constructor:(game)->
    @game = game
    instance = this
    @highscore = new Highscore()

    @restartGame.hide()

    @nextBtn.on 'click', ->
      instance.game.nextLevel()
      instance.hideMenu()
      instance.levelCounter.html("Level " + instance.game.currentLevel)

    @restartBtn.on 'click', ->
      instance.game.reloadLevel()
      instance.hideMenu()
      instance.levelCounter.html("Level " + instance.game.currentLevel)

    @restartGame.on 'click', ->
      instance.game.loadLevel 1, ->
        instance.game.start()
        instance.levelCounter.html("Level " + instance.game.currentLevel)

      instance.hideMenu()
      instance.restartGame.hide()
      instance.nextBtn.show()

  gameOver:->
    $("#game-status").text("Game over!")
    @nextBtn.hide()
    @restartGame.show()

  update:->
    steps = @game.player.getSteps()
    @stepsCounter.html(steps + " steps")

  updateScores:->
    steps = @game.player.getSteps()
    @highscore.setScore(@game.currentLevel, steps)
    @updateHighscoreTable()

  updateHighscoreTable:->
    body = @highscoreTable.find("tbody")
    body.html("")

    for level,score of @highscore.getScores()
      body.append("<tr><td>"+level+"</td><td>"+score+"</td></tr>")

  showMenu:->
    @menuDiv.fadeIn()

  hideMenu:->
    @menuDiv.fadeOut()
