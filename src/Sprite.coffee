
class window.SpriteLoader

  constructor:(done)->
    @sprites = {}
    @expected = 0
    @loaded  = 0

    @finished = done

  load:(path)->
    name = path.split('/')[1].split(".")[0]
    @expected++

    sprite = new Sprite(path)
    sprite.load @done

    @sprites[name] = sprite
    sprite

  done:=>
    @loaded++

    if @loaded==@expected 
      @finished()

  get:(name)->
    if @sprites[name]
      @sprites[name]


class window.Sprite

  constructor:(path)->
    @path = path

  load:(done)->
    @imageObj = new Image()
    @imageObj.onload = done
    @imageObj.src = @path

  render:(context,x,y,width=48,height=48)->
    context.drawImage(@imageObj,x,y,width,height)

  # TODO: Think about argument arrangment
  renderAnim:(context,x,y,sx=0,sy=0,width=48,height=48)->
    context.drawImage(@imageObj,sx*width,sy*height,width,height,x,y,width,height)
