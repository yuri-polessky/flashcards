task send_notifications: :environment do
  User.notify_pending_cards
end