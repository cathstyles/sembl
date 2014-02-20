json.partial! 'games/game', game: @game
json.(@result, 
  :notice,
  :alert
)