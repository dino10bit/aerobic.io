require 'spec_helper'

describe MembersController do
  let(:user) { double(User, id: 42, email: 'lol@lol.com') }

  before do
    session[:user_id] = 42
    User.stub(:find).with(42).and_return(user)
  end

  describe '#index' do
    before do
      get :index
    end

    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe '#show' do
    before do
      get :show, id: 1
    end

    it { should respond_with(:success) }
    it { should render_template(:show) }
  end

  @following
  describe 'follow' do
    before do
      FollowMember.should_receive(:perform) { result }
      post :follow, id: 22
    end

    let(:result) do
      double(:result, success?: true,
                      notice: 'My Notice')
    end

    it { should set_the_flash[:notice].to('My Notice') }
    it { should redirect_to(members_path) }
  end

  @following
  describe 'unfollow' do
    before do
      UnFollowMember.should_receive(:perform) { result }
      post :unfollow, id: 22
    end

    let(:result) do
      double(:result, success?: true,
                      notice: 'My Notice')
    end

    it { should set_the_flash[:notice].to('My Notice') }

    it { should redirect_to(members_path) }
  end
end
