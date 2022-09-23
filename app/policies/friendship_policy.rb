class FriendshipPolicy < ApplicationPolicy
  def cancel?
    record.user == user
  end

  def confirm?
    record.friend == user
  end

  def decline?
    record.friend == user
  end

  def unfriend?
    record.friend == user || record.user == user
  end
end