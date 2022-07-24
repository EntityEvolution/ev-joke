local url <const> = 'https://v2.jokeapi.dev/joke/Any?blacklistFlags=nsfw,religious,political,racist,sexist,explicit';

local function getJoke()
  local p = promise.new();
  PerformHttpRequest(url, function(statusCode, body, headers)
    if statusCode == 200 and not body.error then
      p:resolve(body);
    end
  end)
  return Citizen.Await(p);
end

RegisterCommand('joke', function(source)
  local result = json.decode(getJoke())
  if result.error or not result.setup or not result.delivery then
    TriggerEvent('chat:addMessage', {
      color = { 255, 0, 0 },
      multiline = true,
      args = {
        '^1Joke API Error:',
        '^2' .. result.error
      }
    })
    return;
  end
  local message = result.setup .. ' ' .. result.delivery;
  TriggerClientEvent('chat:addMessage', -1, {
    multiline = true,
    args = {"Joke", message}
  })
end)