pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--dragon fractal
-- by mike cramer

cls()


-- =================
-- model
-- =================

-- general


function reverse (arr)
 local i, j = 1, #arr
 result = arr
 while i < j do
  result[i], result[j] = result[j], result[i]
  i += 1
  j -= 1
 end
 return result
end

function numerical_not(var)
 if var == 0 then
  return 1
 else
  return 0
 end
end

function merge_arrays(arr1, arr2)
 result = arr1
 for i in all(arr2) do
  add( result, i)
 end
 return result
end

function is_empty(s)
  return s == nil or s == ''
end

function table_slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced+1] = tbl[i]
  end

  return sliced
end

-- ----------
-- fractal
-- ----------

-- class_dragon_fractal
 local class_dragon_fractal = {}
 class_dragon_fractal.__index = class_dragon_fractal

 function class_dragon_fractal:new()
  return setmetatable({ fold_lists = {} }, class_dragon_fractal)
 end -- new

 function class_dragon_fractal:current_iteration()
  return #self.fold_lists
 end -- current_iteration


 function class_dragon_fractal:flat_folds(up_to)
  result = {}
  if not up_to then
   up_to = self:current_iteration()
  end
  if up_to <= self:current_iteration() then
   for i=1,up_to,1 do
    result = merge_arrays(result, self.fold_lists[i] )
   end
  end
  return result
 end

 function class_dragon_fractal:iterate_next()
  new_folds = {1}
  for some_fold in all( reverse( self:flat_folds() ) ) do
   add (new_folds, numerical_not (some_fold))
  end
  add (self.fold_lists, new_folds)
 end -- iterate_next

 function class_dragon_fractal:iterate_up_to(up_to)
  while self:current_iteration() < up_to do
   self:iterate_next()
  end
 end


-- class_dragon_fractal




-- =================
-- view-controller
-- =================



-- ----------
-- drawing
-- ----------

-- class_point
 local class_point = {}
 class_point.__index = class_point

 function class_point:new( x, y )
  return setmetatable({ x = x , y = y  }, class_point)
 end -- new

 function class_point:magnitude()
   return sqrt(self.x^2 + self.y^2)
 end -- magnitude

 function class_point:__add(var)
  result = class_point:new(0,0)
  result.x = self.x + var.x
  result.y = self.y + var.y 
  return result
 end
 
 function class_point:__mul(b)
  result = class_point:new(0,0)
  result.x = self.x * b
  result.y = self.y * b
  return result
 end
 
 function class_point:__div(b)
  result = class_point:new(0,0)
  result = self * (1/b)
  return result
 end
 
 function class_point:__sub(var)
  result = class_point:new(0,0)
  result = self + (var * -1)
  return result
 end
 
 

-- class_point

-- class_orientation
 local class_orientation = {}
 class_orientation.__index = class_orientation

 function class_orientation:new( direction , delta_angle)
  return setmetatable({ direction = direction , delta_angle = delta_angle }, class_orientation)
 end -- new

 function class_orientation:left()
  self.direction += self.delta_angle
 end -- left

 function class_orientation:right()
  self.direction -= self.delta_angle
 end -- right

-- class_orientation

-- class_turtle
 local class_turtle = {}
 class_turtle.__index = class_turtle

 function class_turtle:new( direction, delta_angle, point )
  return setmetatable({ orientation = class_orientation:new(direction, delta_angle) , point = point , draw_mode = 0 }, class_turtle)
 end -- new

 function class_turtle:relocate_to(vector_point)
  self.point = vector_point
 end -- move_to


 function class_turtle:move_to(vector_point, input_color)
  new_point = self.point + vector_point
  self:do_draw(new_point, input_color)
  self.point = new_point
 end -- move_to
 
 function class_turtle:do_draw(new_point, input_color, draw_mode)
    if 
   ((0 <= self.point.x and self.point.x <= 128) and (0 <= self.point.y and self.point.y <= 128))
   or
   ((0 <= new_point.x and new_point.x <= 128) and (0 <= new_point.y and new_point.y <= 128))
   then

   self:draw_action(new_point, input_color, draw_mode)
   
   self.drawn_count += 1
  end
 end -- draw
 
 function class_turtle:draw_action(new_point, input_color, draw_mode)
 
   if self.draw_mode == 1 then
    line(self.point.x,self.point.y,new_point.x,new_point.y,input_color)
   elseif self.draw_mode == 2 then
    circ(self.point.x,self.point.y,  (self.point - new_point):magnitude()/4  ,input_color)
   elseif self.draw_mode == 3 then
    circ(self.point.x,self.point.y,  (self.point - new_point):magnitude()/2  ,input_color)
   else
    circ(self.point.x,self.point.y, 0 ,input_color)
   end
   
   self.max_draw_mode = 3
 end -- draw_action
 
 
 function class_turtle:next_draw_mode()
  self.draw_mode+=1
  self.draw_mode = self.draw_mode % ( self.max_draw_mode + 1 )
 end
 
 
 function class_turtle:forward(distance, input_color)
  vector_point = class_point:new(0,0)
  vector_point.y = distance * sin(self.orientation.direction)
  vector_point.x = distance * cos(self.orientation.direction)
  self:move_to(vector_point, input_color)
 end -- forward
 
 function class_turtle:left()
  self.orientation:left()
 end -- left
 
 function class_turtle:right()
  self.orientation:right()
 end -- right

 

 function class_turtle:draw_fractal_tape(tape, distance, color_max)
  
  index = 1
  
  self:forward( distance , index % color_max +1)
  for some_turn in all(tape) do
   index += 1
   if some_turn == 1 then
    self:left(1)
   else
    self:right(1)
   end
   self:forward( distance , index % color_max +1 )

  end
 end -- draw_fractal_tape
   

-- class_turtle


-- ------------------------------
-- setup initial conditions
-- ------------------------------

dragon = class_dragon_fractal:new()
dragon:iterate_up_to(10)

dragon.length = #dragon:flat_folds()
dragon.tape = dragon:flat_folds()

initial_point = class_point:new(64, 64)
initial_direction = 0
turtle = class_turtle:new(initial_direction, 0.5 , initial_point)

zoom_mode = "auto"

walk_distance = 3

throttled_length = 200

target_fps = 30
target_cpu = 0.001

rotation_enable = true
cls_enable = true
last_cls_enable = true

turtle.draw_mode = 1
alt_mode = false

-- setup initial conditions
-- ------------------------------




function _update()
 current_fps = stat(7)
 cpu = stat(1)
 mem = stat(0)
 
 if throttled_length < 1 then throttled_length = 1 end
 
 tape =  table_slice( dragon.tape, 1, throttled_length )
 
 if rotation_enable then
  turtle.orientation.delta_angle += .001
 end
 turtle:relocate_to(initial_point)
 turtle.drawn_count = 0
 
 turtle.orientation.direction = initial_direction
 if 1 < turtle.orientation.delta_angle then 
  turtle.orientation.delta_angle = 0
 end
 

if btnp(🅾️) then
 alt_mode = not alt_mode
 
end

if alt_mode then
 if btnp(⬆️) then
  turtle:next_draw_mode()
 end
 if btnp(⬇️) then
 end
 if btn(⬅️) then
  turtle.orientation.delta_angle += .01
 end
 if btn(➡️) then
  turtle.orientation.delta_angle -= .01
 end
 if btnp(❎) then
  cls_enable = not cls_enable
 end
else
 if btn(⬆️) then
  walk_distance *= 1.1
 end
 if btn(⬇️) then
  walk_distance /= 1.1
 end
 if btnp(⬅️) then
  turtle.orientation.delta_angle += .001
 end
 if btnp(➡️) then
  turtle.orientation.delta_angle -= .001
 end
 if btnp(❎) then
  rotation_enable = not rotation_enable
 end
end



end

function _draw()
 
 if cls_enable then 
  cls()
 end
 
 turtle:draw_fractal_tape(tape, walk_distance, 12)
 
 if alt_mode then
  rectfill(0,0,128,0,5)
 else
  rectfill(0,0,128,0,0)
 end
 
end




