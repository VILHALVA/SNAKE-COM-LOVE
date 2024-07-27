local cellSize = 20
local gridWidth = 40
local gridHeight = 30
local snake
local food
local direction
local nextDirection
local gameOver
local timer
local speed = 0.1
local score

function love.load()
    love.window.setMode(cellSize * gridWidth, cellSize * gridHeight)
    love.window.setTitle("Snake")

    snake = {
        {x = math.floor(gridWidth / 2), y = math.floor(gridHeight / 2)},
    }
    direction = 'right'
    nextDirection = direction
    gameOver = false
    timer = 0
    score = 0

    spawnFood()
end

function love.update(dt)
    if gameOver then return end

    timer = timer + dt
    if timer >= speed then
        timer = 0
        moveSnake()
        checkCollision()
        checkFood()
    end

    if love.keyboard.isDown('up') and direction ~= 'down' then
        nextDirection = 'up'
    elseif love.keyboard.isDown('down') and direction ~= 'up' then
        nextDirection = 'down'
    elseif love.keyboard.isDown('left') and direction ~= 'right' then
        nextDirection = 'left'
    elseif love.keyboard.isDown('right') and direction ~= 'left' then
        nextDirection = 'right'
    end
end

function love.draw()
    love.graphics.setColor(0, 1, 0)
    for _, segment in ipairs(snake) do
        love.graphics.rectangle('fill', (segment.x - 1) * cellSize, (segment.y - 1) * cellSize, cellSize, cellSize)
    end

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', (food.x - 1) * cellSize, (food.y - 1) * cellSize, cellSize, cellSize)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.print("Score: " .. score, 10, 10)

    if gameOver then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(30))
        love.graphics.printf("Game Over", 0, love.graphics.getHeight() / 2 - 15, love.graphics.getWidth(), "center")
        love.graphics.printf("Press R to Restart", 0, love.graphics.getHeight() / 2 + 15, love.graphics.getWidth(), "center")
    end
end

function moveSnake()
    local head = {x = snake[1].x, y = snake[1].y}
    direction = nextDirection

    if direction == 'up' then
        head.y = head.y - 1
    elseif direction == 'down' then
        head.y = head.y + 1
    elseif direction == 'left' then
        head.x = head.x - 1
    elseif direction == 'right' then
        head.x = head.x + 1
    end

    table.insert(snake, 1, head)
    table.remove(snake)
end

function checkCollision()
    local head = snake[1]

    if head.x < 1 or head.x > gridWidth or head.y < 1 or head.y > gridHeight then
        gameOver = true
    end

    for i = 2, #snake do
        if head.x == snake[i].x and head.y == snake[i].y then
            gameOver = true
        end
    end
end

function checkFood()
    if snake[1].x == food.x and snake[1].y == food.y then
        table.insert(snake, 1, {x = food.x, y = food.y})
        score = score + 1

        spawnFood()
    end
end

function spawnFood()
    local validPosition = false

    while not validPosition do
        food = {
            x = math.random(1, gridWidth),
            y = math.random(1, gridHeight)
        }

        validPosition = true

        for _, segment in ipairs(snake) do
            if segment.x == food.x and segment.y == food.y then
                validPosition = false
                break
            end
        end
    end
end

function love.keypressed(key)
    if key == 'r' and gameOver then
        love.load()
    end
end
