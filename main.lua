bump = require "bump"
classic = require "classic"

require "block"

info = {name = 'block'}

--  clicked points to create rectangle
mx1, my1 = nil, nil
mx2, my2 = nil, nil

-- points of rectangle
x_max = nil
y_max = nil
x_min = nil
y_min = nil

-- line points
x0, y0 = nil, nil
xd, yd = nil, nil

-- intersection points
ix1, iy1 = nil, nil
ix2, iy2 = nil, nil

function liang_barsky_algorithm(x_0, y_0, dx, dy)
  local p = {-dx, dx, -dy, dy}
  local q = {x_0 - x_min, x_max - x_0, y_0 - y_min, y_max - y_0}

  local u1 = -math.huge
  local u2 = math.huge

  for i=1, 4 do
    if p[i] == 0 then
      if q[i] < 0 then
        print("There is no intersection, line parallel to one of the rectangle lines")
        return nil
      end
    else
      local t = q[i]/p[i]
      if p[i] < 0 and u1 < t then
        u1 = t
      elseif p[i] > 0 and u2 > t then
        u2 = t
      end
    end
  end

  if u1 > u2 then
    print("Complety outside")
    return nil
  elseif u1 < 0 and 1 < u2 then
    print("Complety inside")
    return nil
  elseif 0 < u1 and u1 < 1 and 0 < u2 and u2 < 1 then
    print("Starts & ends outside")
    return x_0 + u1 * dx, y_0 + u1 * dy, x_0 + u2 * dx, y_0 + u2 * dy
  else
    if 0 < u1 and u1 < 1 then
      print("Starts outside, ends inside and intersect at u1")
      return x_0 + u1 * dx, y_0 + u1 * dy
    end
    if 0 < u2 and u2 < 1 then
      print("Starts inside, ends outside and intersect at u2")
      return x_0 + u2 * dx, y_0 + u2 * dy
    end
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == 'r' and world:hasItem(info) then
    -- remove rectangle, line and intersection points
    print("Remove")
    world:remove(info)

    x0, y0 = nil, nil
    xd, yd = nil, nil

    ix1, iy1 = nil, nil
    ix2, iy2 = nil, nil

    x_max = nil
    y_max = nil
    x_min = nil
    y_min = nil
  end
end

function love.mousepressed(x, y, button, isTouch, presses)
  if not(world:hasItem(info)) then
    -- double click logic
    if not(mx1) then
      mx1, my1 = x, y
    else
      mx2, my2 = x, y

      -- swap accordingly to not get a negativ delta
      if mx1 > mx2 then
        local ax = mx2
        mx2 = mx1
        mx1 = ax
      end
      if my1 > my2 then
        local ay = my2
        my2 = my1
        my1 = ay
      end

      x_max, y_max = mx2, my2
      x_min, y_min = mx1, my1

      Block:new(mx1, my1, {w=mx2-mx1, h=my2-my1, info = info})
      mx1, my1, mx2, my2 = nil, nil, nil, nil
    end
  else
    if not(mx1) then
      mx1, my1 = x, y
    else
      mx2, my2 = x, y
      x0, y0 = mx1, my1
      xd, yd = mx2-mx1, my2-my1

      ix1, iy1, ix2, iy2 = liang_barsky_algorithm(x0, y0, xd, yd)

      mx1, my1, mx2, my2 = nil, nil, nil, nil
    end
  end
end

function love.load()
  love.window.setTitle("Liang Barsky Algorithm")

  world = bump.newWorld()
end

function love.draw()
  if x_min then -- rectanlge
    love.graphics.rectangle("line", x_min, y_min, x_max-x_min, y_max-y_min)
  end

  if x0 then -- line
    love.graphics.line(x0, y0, x0 + xd, y0 + yd)
  end

  if ix1 then -- intersection 1
    love.graphics.circle('fill', ix1, iy1, 5)
  end

  if ix2 then -- intersection 2
    love.graphics.circle('fill', ix2, iy2, 5)
  end
end
