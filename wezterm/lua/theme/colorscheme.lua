local M = {}

M.variants = {
  night = "Tokyo Night",
  storm = "Tokyo Night Storm",
  day = "Tokyo Night Day",
  moon = "Tokyo Night Moon",
}

M.current = M.variants.night

function M.get()
  return M.current
end

return M
