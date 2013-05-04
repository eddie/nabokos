
class window.Tile

    constructor:(id, type, name)->
        @id = id
        @type = type
        @name = name

    solid:->
        return @type == "world" || @box()

    platform:->
        return @type == "platform"

    box:->
        return @type == "box"



class window.Tiles

    constructor:()->
        @tiles = []

    # TODO: Improve data testing
    loadFromData:(data)->

        for tile in data
            @tiles[tile.id] = new Tile(tile.id, tile.type, tile.name)

        return @

    get:(id)->

        return @tiles[id]

        return false

    # TODO: Multiple platform id's will mess up
    getPlatformID:->
        for tile in @tiles
            return tile.id if tile and tile.platform()

        return false

