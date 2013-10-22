# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  source_id  :integer
#  target_id  :integer
#  game_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Link < ActiveRecord::Base
end
