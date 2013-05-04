
class window.Player

  constructor:(sprite)->
    @sprite = sprite
    @dir = 3
    @frame = 0
    @steps = 0

  setLevel:(level)->
    @steps = 0
    @level = level
    @x = @level.getStartPos().x
    @y = @level.getStartPos().y

  textToDir:(dir)->
    switch dir
      when "down" then return 0
      when "left" then return 1
      when "up" then return 2
      when "right" then return 3

  # TODO: Cleanup these direction calculations
  move: (direction)->

    # Update animation
    @frame = @frame + 1
    @dir = @textToDir(direction)

    tx = 0
    ty = 0

    # Determine the block coordinates the player is facing
    switch direction
      when "down"  then tx = @x;     ty = @y + 1
      when "left"  then tx = @x - 1; ty = @y
      when "up"    then tx = @x;     ty = @y - 1
      when "right" then tx = @x + 1; ty = @y

    collision = @level.collisionAt(tx,ty)

    return if @level.tileLockedAt(tx,ty)

    if not collision
      @x = tx
      @y = ty

    else if collision.box()

      # Work out the coordinates for the box based
      # upon the direction of the player

      switch direction
        when "down"  then nx = tx;     ny = ty + 1
        when "left"  then nx = tx - 1; ny = ty
        when "up"    then nx = tx;     ny = ty - 1
        when "right" then nx = tx + 1; ny = ty

      if @level.collisionAt(nx,ny) or @level.tileLockedAt(nx,ny)
        return

      @level.moveTile(tx,ty,nx,ny)
      @x = tx
      @y = ty

    else
      return

    @steps++


  getSteps:->
    return @steps

  render:(context)->
    if (@frame+1) > 4 then @frame = 0
    @sprite.renderAnim(context,@x*48,@y*48,@dir,@frame)
