class JoinGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group
  enum role: [:admin, :moderator, :normal]

  include AASM
  aasm column: :state do
    state :requesting, initial: true
    state :approved, :cancelled, :declined, :leaved, :removed

    event :approve do
      transitions from: :requesting, to: :approved
    end

    event :cancel, after: :delete_record_after_cancel do
      transitions from: :requesting, to: :cancelled
    end

    event :decline, after: :delete_record_after_decline do
      transitions from: :requesting, to: :declined
    end

    event :leave, after: :delete_record_after_leave do
      transitions from: :approved, to: :leaved
    end

    event :remove, after: :delete_record_after_remove do
      transitions from: :approved, to: :removed
    end

    event :request do
      transitions from: :leaved, to: :requesting
    end
  end

  def delete_record_after_remove
    delete_record
  end

  def delete_record_after_decline
    delete_record
  end

  def delete_record_after_cancel
    delete_record
  end

  def delete_record_after_leave
    delete_record
  end

  def delete_record
    JoinGroup.find(self.id).destroy
  end
end