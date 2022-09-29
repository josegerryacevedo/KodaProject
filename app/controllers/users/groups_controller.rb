class Users::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:edit, :update, :destroy, :show]

  def index
    group_ids = current_user.join_groups.where.not(state: [:decline, :leave]).pluck(:group_id)
    @groups = Group.where.not(id: group_ids).includes(:user) if params[:history] == 'group_list' || params[:history].blank?
    @groups = Group.where(user: current_user).includes(:user) if params[:history] == 'my_own_group'
    @joined_groups = JoinGroup.where(user: current_user).where(state: :approved).where.not(role: :admin).includes(:user, :group) if params[:history] == 'joined_group'
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      @join_group = current_user.join_groups.new(user_id: current_user, group: @group, role: :admin, is_owner: true, state: :approved)
      @join_group.save
      redirect_to users_groups_path, notice: 'Group Created!'
    else
      render :new
    end
  end

  def edit
    authorize @group, :edit?, policy_class: GroupPolicy
  end

  def update
    authorize @group, :update?, policy_class: GroupPolicy
    if @group.update(group_params)
      redirect_to users_groups_path, notice: 'Successfully Updated!'
    else
      render :edit
    end
  end

  def show
    @members = JoinGroup.where.not(user: current_user).where(state: :approved).includes(:user) if params[:history] == 'member'
  end

  def destroy
    authorize @group, :destroy?, policy_class: GroupPolicy
    if @group.destroy
      flash[:notice] = "Successfully Deleted!"
    else
      flash[:alert] = "Failed to delete!"
    end
    redirect_to users_groups_path
  end

  private

  def group_params
    params.require(:group).permit(:banner, :genre, :description)
  end

  def set_group
    @group = Group.find(params[:id])
  end
end