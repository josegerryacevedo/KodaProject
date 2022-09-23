class PostPolicy < ApplicationPolicy
  def edit?
    record.user == user
  end

  def update?
    false
  end

  def destroy?
    record.user == user
  end
end