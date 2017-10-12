function love.conf(c)
  c.title = "Flappy"
  local window = c.screen or c.window -- love 0.9 renamed "screen" to "window"
  window.width = 720/2
  window.height = 1280/2
end