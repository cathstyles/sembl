FactoryGirl.define do
  factory :board do
    title { "#{Forgery(:lorem_ipsum).word} #{number_of_players}" }
    number_of_players { (2..6).to_a.sample }
    nodes_attributes { '[{"y":600.0,"x":412.4031007751938,"fixed":1,"round":0},{"y":424.03846153846155,"x":800.0,"fixed":1,"round":1},{"y":288.46153846153845,"x":257.36434108527135,"fixed":1,"round":1},{"y":400.96153846153845,"x":0.0,"fixed":1,"round":1},{"y":0.0,"x":741.0852713178296,"fixed":1,"round":2},{"y":14.423076923076923,"x":120.93023255813954,"fixed":1,"round":2},{"y":279.8076923076923,"x":579.8449612403101,"fixed":1,"round":3}]' }
    links_attributes { '[{"source":0,"target":1},{"source":0,"target":2},{"source":0,"target":3},{"source":1,"target":4},{"source":2,"target":4},{"source":2,"target":5},{"source":3,"target":5},{"source":4,"target":6},{"source":5,"target":6},{"source":0,"target":6}]' }
  end
end
