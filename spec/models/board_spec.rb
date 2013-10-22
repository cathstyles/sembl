# == Schema Information
#
# Table name: boards
#
#  id                :integer          not null, primary key
#  title             :string(255)      not null
#  number_of_players :integer          not null
#  creator_id        :integer
#  updator_id        :integer
#  created_at        :datetime
#  updated_at        :datetime
#  game_attributes   :text             default("{\"nodes\": [{\"round\": 0}], \"links\": []}"), not null
#

require 'spec_helper'

describe Board do
  pending "add some examples to (or delete) #{__FILE__}"
end
