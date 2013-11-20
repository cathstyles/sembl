# == Schema Information
#
# Table name: things
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text             default("")
#  creator_id  :integer
#  updator_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  image       :string(255)
#  attribution :string(255)
#  item_url    :string(255)
#  copyright   :string(255)
#  attributes  :json             default([]), not null
#

require 'spec_helper'

describe Thing do
end
