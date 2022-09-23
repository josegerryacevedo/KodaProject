class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: "friend_id"

  include AASM
  aasm column: :state do
    state :requesting, initial: true
    state :confirmed, :cancelled, :declined, :unfriended

    event :confirm do
      transitions from: :requesting, to: :confirmed
    end

    event :cancel, after: :delete_record_after_cancel do
      transitions from: :requesting, to: :cancelled
    end

    event :decline, after: :delete_record_after_decline do
      transitions from: :requesting, to: :declined
    end

    event :unfriend, after: :delete_record_after_unfriend do
      transitions from: :confirmed, to: :unfriended
    end
  end

  def delete_record_after_cancel
    delete_record
  end

  def delete_record_after_decline
    delete_record
  end

  def delete_record_after_unfriend
    delete_record
  end

  def delete_record
    Friendship.find(self.id).destroy
  end
end
