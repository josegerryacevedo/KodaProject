class JoinGroupPolicy < ApplicationPolicy
  def create?
    record.user != user
  end

  def leave?
    record.user == user
  end

  def cancel?
    record.user == user
  end

  def approve?
    user.join_groups.find_by(group: record.group).admin? && user.join_groups.find_by(group: record.group).moderator?
  end

  def decline?
    user.join_groups.find_by(group: record.group).admin? && user.join_groups.find_by(group: record.group).moderator?
  end

  def update?
    user.join_groups.find_by(group: record.group).admin? && user.join_groups.find_by(group: record.group).moderator?
  end

  def remove?
    user.join_groups.find_by(group: record.group).admin? && user.join_groups.find_by(group: record.group).moderator?
  end
end