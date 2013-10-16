user = User.create! email: "user@example.com", password: "password"

admin = User.create! email: "admin@example.com", password: "password", admin: true

Board.create! title: "Lotus 4", number_of_players: 4, creator: admin
Board.create! title: "Lotus 5", number_of_players: 4, creator: admin
Board.create! title: "Lotus 6", number_of_players: 4, creator: admin
