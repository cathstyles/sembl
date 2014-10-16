namespace :sembl do
  task send_game_reminders: [:environment] do
    Player.requiring_invitation_reminder.each(&:deliver_invitation_reminder)
    Player.requiring_turn_reminder.each(&:deliver_turn_reminder)
    Game.requiring_stale_and_incomplete_player_set_notification.each(&:deliver_stale_and_incomplete_player_set_notifications)
  end
end
