user = User.create! email: "user@example.com", password: "password"

admin = User.create! email: "admin@example.com", password: "password", admin: true

Board.create! title: "Lotus 3", number_of_players: 3, game_attributes: '{"nodes":[{"round":0,"fixed":1,"x":348,"y":341},{"round":1,"fixed":1,"x":473,"y":280},{"round":1,"fixed":1,"x":298,"y":233},{"round":1,"fixed":1,"x":215,"y":272},{"round":2,"fixed":1,"x":454,"y":133},{"round":2,"fixed":1,"x":254,"y":138},{"round":3,"fixed":1,"x":402,"y":230}],"links":[{"source":0,"target":1},{"source":0,"target":2},{"source":0,"target":3},{"source":1,"target":4},{"source":2,"target":4},{"source":2,"target":5},{"source":3,"target":5},{"source":4,"target":6},{"source":5,"target":6},{"source":6,"target":0}]}', creator: admin
Board.create! title: "Lotus 4", number_of_players: 4, creator: admin
Board.create! title: "Lotus 5", number_of_players: 4, creator: admin
Board.create! title: "Lotus 6", number_of_players: 4, creator: admin
