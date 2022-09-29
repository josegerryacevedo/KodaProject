class Users::JoinGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:create, :remove]
  before_action :set_join_group, except: [:index, :new, :create]

  def index
    @join_groups = JoinGroup.includes(:user, :group)
    @sent_requests = @join_groups.where(user: current_user).requesting
    @received_requests = @join_groups.requesting
  end

  def create
    authorize @group, :create?, policy_class: JoinGroupPolicy
    is_user_existing = current_user.join_groups.where(group_id: params[:group_id]).blank?
    if is_user_existing
      @join_group = JoinGroup.new(group_id: params[:group_id])
      @join_group.user = current_user
      @join_group.role = :normal
      @join_group.save
      redirect_to users_groups_path, notice: 'Sent Request!'
    elsif redirect_to users_groups_path, alert: 'Already sent request!'
    end
  end

  def update
    authorize @join_group, :update?, policy_class: JoinGroupPolicy
    if @join_group.update(role: params[:join_group][:role])
      redirect_to users_group_path, notice: 'Successfully Updated!'
    else
      render :index
    end
  end

  def leave
    authorize @join_group, :leave?, policy_class: JoinGroupPolicy
    if @join_group.may_leave? && @join_group.leave!
      flash[:notice] = "Successfully Leaved!"
    else
      flash[:alert] = @join_group.errors.full_messages.join(', ')
    end
    redirect_to users_groups_path
  end

  def cancel
    authorize @join_group, :cancel?, policy_class: JoinGroupPolicy
    if @join_group.may_cancel? && @join_group.cancel!
      flash[:notice] = "Successfully Cancelled!"
    else
      flash[:alert] = @join_group.errors.full_messages.join(', ')
    end
    redirect_to users_join_groups_path
  end

  def approve
    authorize @join_group, :approve?, policy_class: JoinGroupPolicy
    if @join_group.may_approve? && @join_group.approve!
      flash[:notice] = "Successfully Approved!"
    else
      flash[:alert] = @join_group.errors.full_messages.join(', ')
    end
    redirect_to users_join_groups_path
  end

  def decline
    authorize @join_group, :decline?, policy_class: JoinGroupPolicy
    if @join_group.may_decline? && @join_group.decline!
      flash[:notice] = "Successfully Declined!"
    else
      flash[:alert] = @join_group.errors.full_messages.join(', ')
    end
    redirect_to users_join_groups_path
  end

  def remove
    authorize @join_group, :remove?, policy_class: JoinGroupPolicy
    if @join_group.may_remove? && @join_group.remove!
      flash[:notice] = "Successfully Removed!"
    else
      flash[:alert] = @join_group.errors.full_messages.join(', ')
    end
    redirect_to users_group_path(@group)
  end

  private

  def set_join_group
    @join_group = JoinGroup.find(params[:join_group_id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end
end