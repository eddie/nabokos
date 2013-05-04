

class window.Level

  constructor:(spriteLoader)->
    @spriteLoader = spriteLoader
    @playerID = 9

  loadJSON:(path,done)->

    that = @

    $.getJSON path, (data) ->
      that.tileData = data.tiles
      that.data = data.data
      that.tileSize = data.meta.tileSize
      that.width = data.meta.width
      that.lockedGrid = []

      for tile in that.tileData
        if not that.spriteLoader.get(tile.name)
          that.spriteLoader.load(tile.path)

      that.tiles = new Tiles().loadFromData(that.tileData)

      done()

    false

  getHeight:->
    Math.floor(@data.length/@width) * @tileSize

  xyToIndex:(x,y)->
    (y * @width) + x

  moveTile:(x,y,nx,ny)->
    oldLoc = @xyToIndex(x,y)
    newLoc = @xyToIndex(nx,ny)

    newTile = @tiles.get(@data[newLoc])

    # TODO: This could be improved
    if newTile and newTile.platform()
      @lockedGrid[newLoc] = 1

    @data[newLoc] = @data[oldLoc]
    @data[oldLoc] = 0

  isComplete:->
    platformID = @tiles.getPlatformID()

    if platformID and @data.indexOf(platformID) == -1
      return true

    false

  getStartPos:->
    location = @data.indexOf(@playerID)
    {
      x: location % @width
      y: Math.floor(location/@width)
    }

  tileLockedAt:(x,y)->
    location = @xyToIndex(x,y)
    return (location of @lockedGrid)

  collisionAt:(x,y)->
    location = @xyToIndex(x,y)
    tile = @tiles.get(@data[location])

    if tile and tile.solid()
      return tile

    return false

  drawTile:(context,id,x,y)->

    return if id == 0 or id == @playerID

    tile = @tiles.get(id)

    if tile
      @spriteLoader.get(tile.name).render(context,x*@tileSize,y*@tileSize)

  render:(context)->
    xOffset = 0
    yOffset = 0

    for i in [0...@data.length]
      xOffset = i % @width
      if((i % @width)==0)
        yOffset = yOffset + 1
        xOffset = 0
      @drawTile(context,@data[i],xOffset,yOffset-1)
