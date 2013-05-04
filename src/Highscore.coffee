
# Really simple highscore tracking, currently only uses
# HTML5 storage, not supposed to be great - just want to add a quick
# highscore system to finish up the game

# TODO: Allow other storage methods, including server

class window.Highscore

  constructor:->
    @loadScores()

  loadScores:->

    if "sokoban" of localStorage
      @highscores = JSON.parse(localStorage["sokoban"])
    else
      @highscores = {}

    return @highscores

  setScore:(level, score)->
    oldScore = @getScore(level)

    if oldScore > 0 and oldScore < score
      return

    @highscores[level] = parseInt(score)
    localStorage["sokoban"] = JSON.stringify(@highscores)

  getScore:(level)->
    if level of @highscores
      return parseInt(@highscores[level])

    return 0

  getScores:->
    @highscores
