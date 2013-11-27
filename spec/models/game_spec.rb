# == Schema Information
#
# Table name: games
#
#  id                   :integer          not null, primary key
#  board_id             :integer
#  title                :string(255)      not null
#  description          :text
#  creator_id           :integer
#  updator_id           :integer
#  created_at           :datetime
#  updated_at           :datetime
#  invite_only          :boolean          default(FALSE)
#  uploads_allowed      :boolean          default(FALSE)
#  theme                :string(255)
#  filter_content_by    :text
#  allow_keyword_search :boolean          default(FALSE)
#  state                :string(255)      default("draft")
#  current_round        :integer          default(1)
#  random_seed          :integer
#

require 'spec_helper'

describe Game do
  pending "add some examples to (or delete) #{__FILE__}"
end
