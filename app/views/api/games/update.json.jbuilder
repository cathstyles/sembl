json.partial! 'api/games/game', game: @game
json.(@result, 
  :notice,
  :alert
)