local Debug = false

local Liv = {
  print = {
    "Liv:Dear Commandant, everything seems stable",
		"Liv:Dear Commandant, System check complete, awaiting further orders",
		"Liv:Dear Commandant, Script stable, all readings nominal"
  },
  warn = {
		"Liv:Commandant, please be cautious!",
		"Liv:Warning detected, I recommend checking the systems",
		"Liv:Something feels off... please verify the parameters"
	}
}

local function debug(typede, ...)
  if not Debug then return end
    local typede = typede or "print"
    local chat = Liv[typede] or Liv["print"]
    local randomdebug = chat[math.random(1, #chat)]
    local msg = table.concat({...}, "")
    
    if typede == "warn" then
      warn(randomdebug, msg)
    else
      print(randomdebug, msg)
  end
end

print = function(...)
  debug("print", ...)
end

warn = function(...)
  debug("warn", ...)
end
