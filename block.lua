Block = classic:extend()

function Block:new(x, y, opts)
  local opts = opts or {}
  if opts then for k, v in pairs(opts) do self[k] = v end end

  self.x, self.y = x, y

  local item = world:add(self.info, self.x, self.y, self.w or 100, self.h or 25)
end

function Block:update(dt)
end

function Block:draw()
end
