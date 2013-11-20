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
#  nodes_attributes  :json             default([{"round"=>0}]), not null
#  links_attributes  :json             default([]), not null
#

require 'spec_helper'

describe Board do
  pending "add some examples to (or delete) #{__FILE__}"
end
