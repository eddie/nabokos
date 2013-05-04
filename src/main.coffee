

window.Sokospace = {}

Sokospace.UI = new UI()
Sokospace.game = new Sokoban("sokoban")

Sokospace.game.load -> 
  Sokospace.game.start()
