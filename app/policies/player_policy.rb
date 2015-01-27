class PlayerPolicy < ApplicationPolicy

  def create?
    !!user && (user.id == record.game.creator_id || user.admin?) && (record.game.draft? || record.game.joining?)
  end

  def destroy?
    puts 'destroy'
    puts 'user', user.inspect
    puts 'game', record.game.inspect
    puts 'admin', user.admin?
    puts 'draft', record.game.draft?
    !!user && (user.id == record.game.creator_id || user.admin?) && (record.game.draft? || record.game.joining?)
  end
end
