Object = require "classic"
require "tile"
require "train"

function love.load()
    x = 64
    y = 64
    gridw = 64
    gridh = 64
    mousex = 0
    mousey = 0
    mouse_floor_x = 0
    mouse_floor_y = 0
    track_limit = 16
    success = false
    freeze = false
    bg = love.graphics.newImage("background.png")
    object_tracker = {}
    current_tile_stack = {}
    for i = 0,15 do
        table.insert(object_tracker, {})
        for j = 0,8 do
            local empty_tile = Tile(i * x, j * y, "empty", "empty_tile.png")
            table.insert(object_tracker[i + 1], empty_tile)
        end
    end
    local start_tile = Tile(2 * x, 5 * y, "start", "start_tile.png")
    object_tracker[3][6] = start_tile
    local end_tile = Tile(12 * x, 1 * y, "end", "end_tile.png")
    object_tracker[13][2] = end_tile
    end_position = {12, 1}
    table.insert(current_tile_stack, {2, 5})
    local mountain_tile = Tile(6 * x, 3 * y, "mountain", "mountain_tile.png")
    object_tracker[7][4] = mountain_tile
    local mountain_tile = Tile(1 * x, 8 * y, "mountain", "mountain_tile.png")
    object_tracker[2][9] = mountain_tile
    local mountain_tile = Tile(6 * x, 4 * y, "mountain", "mountain_tile.png")
    object_tracker[7][5] = mountain_tile
end

function love.update(dt)
    mousex, mousey = love.mouse.getPosition()
    mouse_floor_x = math.floor(mousex / 64)
    mouse_floor_y = math.floor(mousey / 64)
    if (current_tile_stack[table.maxn(current_tile_stack)][1] - 1 == end_position[1] and current_tile_stack[table.maxn(current_tile_stack)][2] == end_position[2]) or (current_tile_stack[table.maxn(current_tile_stack)][1] + 1 == end_position[1] and current_tile_stack[table.maxn(current_tile_stack)][2] == end_position[2]) or (current_tile_stack[table.maxn(current_tile_stack)][1] == end_position[1] and current_tile_stack[table.maxn(current_tile_stack)][2] - 1 == end_position[2]) or (current_tile_stack[table.maxn(current_tile_stack)][1] == end_position[1] and current_tile_stack[table.maxn(current_tile_stack)][2] == end_position[2] + 1) then
        success = true
        freeze = true
        table.insert(current_tile_stack, end_position)
        train = Train(current_tile_stack)
    end
    if love.mouse.isDown(1) and track_limit > 0 and not freeze then
        if ((mouse_floor_x == current_tile_stack[table.maxn(current_tile_stack)][1] - 1 and mouse_floor_y == current_tile_stack[table.maxn(current_tile_stack)][2]) or (mouse_floor_x == current_tile_stack[table.maxn(current_tile_stack)][1] + 1 and mouse_floor_y == current_tile_stack[table.maxn(current_tile_stack)][2]) or (mouse_floor_x == current_tile_stack[table.maxn(current_tile_stack)][1] and mouse_floor_y == current_tile_stack[table.maxn(current_tile_stack)][2] - 1) or (mouse_floor_x == current_tile_stack[table.maxn(current_tile_stack)][1] and mouse_floor_y == current_tile_stack[table.maxn(current_tile_stack)][2] + 1)) and check_square(mouse_floor_x, mouse_floor_y) then
            if mouse_floor_x == current_tile_stack[table.maxn(current_tile_stack)][1] then
                local track = Tile(mouse_floor_x * x, mouse_floor_y * y, "track", "trackVertical.png")
                object_tracker[mouse_floor_x + 1][mouse_floor_y + 1] = track
            else
                local track = Tile(mouse_floor_x * x, mouse_floor_y * y, "track", "trackHorizontal.png")
                object_tracker[mouse_floor_x + 1][mouse_floor_y + 1] = track
            end
            table.insert(current_tile_stack, {mouse_floor_x, mouse_floor_y})
            track_limit = track_limit - 1
            if table.maxn(current_tile_stack) >= 4 then
                if current_tile_stack[table.maxn(current_tile_stack) - 2][1] == current_tile_stack[table.maxn(current_tile_stack)][1] - 1 and current_tile_stack[table.maxn(current_tile_stack) - 2][2] == current_tile_stack[table.maxn(current_tile_stack)][2] - 1 then
                    if current_tile_stack[table.maxn(current_tile_stack) - 1][1] == current_tile_stack[table.maxn(current_tile_stack)][1] then
                        object_tracker[current_tile_stack[table.maxn(current_tile_stack) - 1][1] + 1][current_tile_stack[table.maxn(current_tile_stack) - 1][2] + 1].image = love.graphics.newImage("trackTopLeftTurn.png")
                    else
                        object_tracker[current_tile_stack[table.maxn(current_tile_stack) - 1][1] + 1][current_tile_stack[table.maxn(current_tile_stack) - 1][2] + 1].image = love.graphics.newImage("trackBottomRightTurn.png")
                    end
                end
                if current_tile_stack[table.maxn(current_tile_stack) - 2][1] == current_tile_stack[table.maxn(current_tile_stack)][1] + 1 and current_tile_stack[table.maxn(current_tile_stack) - 2][2] == current_tile_stack[table.maxn(current_tile_stack)][2] - 1 then
                    if current_tile_stack[table.maxn(current_tile_stack) - 1][1] == current_tile_stack[table.maxn(current_tile_stack)][1] then
                        object_tracker[current_tile_stack[table.maxn(current_tile_stack) - 1][1] + 1][current_tile_stack[table.maxn(current_tile_stack) - 1][2] + 1].image = love.graphics.newImage("trackTopRightTurn.png")
                    else
                        object_tracker[current_tile_stack[table.maxn(current_tile_stack) - 1][1] + 1][current_tile_stack[table.maxn(current_tile_stack) - 1][2] + 1].image = love.graphics.newImage("trackBottomLeftTurn.png")
                    end
                end
                if current_tile_stack[table.maxn(current_tile_stack) - 2][1] == current_tile_stack[table.maxn(current_tile_stack)][1] - 1 and current_tile_stack[table.maxn(current_tile_stack) - 2][2] == current_tile_stack[table.maxn(current_tile_stack)][2] + 1 then
                    if current_tile_stack[table.maxn(current_tile_stack) - 1][1] == current_tile_stack[table.maxn(current_tile_stack)][1] then
                        object_tracker[current_tile_stack[table.maxn(current_tile_stack) - 1][1] + 1][current_tile_stack[table.maxn(current_tile_stack) - 1][2] + 1].image = love.graphics.newImage("trackBottomLeftTurn.png")
                    else
                        object_tracker[current_tile_stack[table.maxn(current_tile_stack) - 1][1] + 1][current_tile_stack[table.maxn(current_tile_stack) - 1][2] + 1].image = love.graphics.newImage("trackTopRightTurn.png")
                    end
                end
                if current_tile_stack[table.maxn(current_tile_stack) - 2][1] == current_tile_stack[table.maxn(current_tile_stack)][1] + 1 and current_tile_stack[table.maxn(current_tile_stack) - 2][2] == current_tile_stack[table.maxn(current_tile_stack)][2] + 1 then
                    if current_tile_stack[table.maxn(current_tile_stack) - 1][1] == current_tile_stack[table.maxn(current_tile_stack)][1] then
                        object_tracker[current_tile_stack[table.maxn(current_tile_stack) - 1][1] + 1][current_tile_stack[table.maxn(current_tile_stack) - 1][2] + 1].image = love.graphics.newImage("trackBottomRightTurn.png")
                    else
                        object_tracker[current_tile_stack[table.maxn(current_tile_stack) - 1][1] + 1][current_tile_stack[table.maxn(current_tile_stack) - 1][2] + 1].image = love.graphics.newImage("trackTopLeftTurn.png")
                    end
                end
            end
        end
    end
    if love.mouse.isDown(2) and not freeze then
        if mouse_floor_x == current_tile_stack[table.maxn(current_tile_stack)][1] and mouse_floor_y == current_tile_stack[table.maxn(current_tile_stack)][2] and object_tracker[mouse_floor_x + 1][mouse_floor_y + 1].name == "track" then
            local empty_tile = Tile(mouse_floor_x * x, mouse_floor_y * y, "empty", "empty_tile.png")
            object_tracker[mouse_floor_x + 1][mouse_floor_y + 1] = empty_tile
            table.remove(current_tile_stack, table.maxn(current_tile_stack))
            track_limit = track_limit + 1
            if current_tile_stack[table.maxn(current_tile_stack)][1] == current_tile_stack[table.maxn(current_tile_stack) - 1][1] then
                object_tracker[current_tile_stack[table.maxn(current_tile_stack)][1] + 1][current_tile_stack[table.maxn(current_tile_stack)][2] + 1].image = love.graphics.newImage("trackVertical.png")
            else
                object_tracker[current_tile_stack[table.maxn(current_tile_stack)][1] + 1][current_tile_stack[table.maxn(current_tile_stack)][2] + 1].image = love.graphics.newImage("trackHorizontal.png")
            end
        end
    end
    if success then
        train:update(dt)
    end
end

function love.draw()
    love.graphics.draw(bg, 0, 0)
    for i, column in ipairs(object_tracker) do
        for j, tile in ipairs(column) do
            tile:draw()
        end
    end
    love.graphics.print("Number of tracks left: " .. track_limit, 0, 0)
    if success then
        love.graphics.print("Congratulations, you beat the level!", 524, 0)
        train:draw()
    end
end

function check_square(x, y)
    if x >= 0 and x <= 15 and y >= 0 and y <= 8 then
        return object_tracker[x + 1][y + 1].name == "empty"
    end
end
