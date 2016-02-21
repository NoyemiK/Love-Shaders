function love.load()
    love.window.setMode(1280, 720)
    
    --The table of shader effects
    shaderArray = {}
    shaderArray[1] = love.graphics.newShader[[
    extern number time;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
      
      //Creates time-dependent sine modulation effect
      number noise = 0.01*sin((2*3.14) * (time*16) * texture_coords.y);
      number height = floor(texture_coords.y * 720);
      
      //Divide the image into two scan regions
      if (mod(height, 2) != 0){
        color.r = 0;
        color.b = 1 - (floor(noise*160)/16);
        color.g = pixel.g * abs(sin(time));
        texture_coords.x += noise;
        return Texel(texture, texture_coords) * color;
        } else {
        pixel.r = pixel.r * abs(floor(sin(time) * 4) / 4);
        pixel.b = 0.5 * pixel.b;
        return pixel;
      }
    }
  ]]
  
  shaderArray[2] = love.graphics.newShader[[
    extern number time;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
      
      //Creates time-dependent sine modulation effect. Sine amplitude controls x draw modulation.
      number noise = 0.01*sin((2*3.14) * (time));
      number height = floor(texture_coords.y * 720);
      
      //This divides the image into two scan regions
      if (mod(height, 2) != 0){
          color.r = 0;
          color.b = 1 - (floor(noise*160)/16);
          color.g = 1 - (floor(noise*160)/16);
          texture_coords.x += noise;
          return Texel(texture, texture_coords) * color;
        } else {
          pixel.r = pixel.r;
          pixel.b = 0.5 * pixel.b;
          pixel.g = pixel.g * 0.5;
          return pixel;
      }
    }
  ]]
  
  shaderArray[3] = love.graphics.newShader[[
    extern number time;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
      
      //Creates time-dependent pulse modulation effect
      number phase = time * 3;
      number noise = 0.01 * floor(sin((2*3.14) * 5 * texture_coords.y - phase));
      number height = floor(texture_coords.y * 720);
      
      //This divides the image into two scan regions
      if (mod(height, 2) != 0){
          color.g = 0;
          color.b = 1 - (floor(noise*160)/16);
          color.r = (0.7 *color.r) - (floor(sin(time) * 4)/6);
          texture_coords.x += noise;
        return Texel(texture, texture_coords) * color;
        } else {
          pixel.r = 0;
          pixel.b = 0.5 * pixel.b;
          pixel.g = 0.5 * pixel.g;
          return pixel;
      }
    }
  ]]
  
  shaderArray[4] = love.graphics.newShader[[
    extern number time;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
      
      //Creates time-dependent pulse modulation effect
      number phase = time * 4;
      number noise = 0.01 * sin((2*3.14) * 5 * texture_coords.y - phase);
      number heightmod = floor(sin(3.14 * 3 * texture_coords.y - phase));
      number height = floor(texture_coords.y * 720);
      
      //This divides the image into two scan regions
      if (mod(height, 2) != 0){
          color.r = 0;
          color.g = 0.8 - (floor(noise*160)/16);
          color.b = 1 - (floor(noise*160)/16);
          texture_coords.y += 0.01 * heightmod;
          return Texel(texture, texture_coords) * color;
        } else {
          pixel.b = 0.5 * pixel.b;
          pixel.g = 0;
          return pixel;
      }
    }
  ]]
  
  shaderArray[5] = love.graphics.newShader[[
    extern number time;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
      
      //Creates time-dependent pulse modulation effect
      number phase = time * 4;
      number noise = 0.01 * sin((2*3.14) * 5 * texture_coords.y - phase);
      number heightmod = max(sin(phase), 0.2);
      number height = floor(texture_coords.y * 720);
      
      //This divides the image into two scan regions
      if (mod(height, 2) != 0){
          color.r = 0;
          color.g = 0.8 - (floor(noise*160)/16);
          color.b = 1 - (floor(noise*160)/16);
          texture_coords.y += 0.01 * heightmod;
          return Texel(texture, texture_coords) * color;
        } else {
          pixel.b = 0.5 * pixel.b;
          pixel.g = 0;
          return pixel;
      }
    }
  ]]
    liza = love.graphics.newImage('assets/lizaveta.png')
    sel = 1
  end
  
  function love.draw()
    dt = love.timer.getTime()%8
    
    --Send the clock to the shader to control the speed or modulation of effects
    shaderArray[sel]:send("time", dt)
    love.graphics.setShader(shaderArray[sel])
    love.graphics.draw(liza, 0, 0)
  end
  
  function love.update()
    --This is where you press the Z key to cycle shaders!
    function love.keypressed()
      if key == z then
        sel = sel + 1
        if (sel > table.getn(shaderArray)) then
          sel = 1
        end
      end
    end
    
  end
  