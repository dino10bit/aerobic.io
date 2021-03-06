require 'spec_helper'

include FollowingHelper

@following
describe FollowingHelper do
  describe '#following_link_for_members' do
    subject { following_link_for_members(member, other_member) }
    let(:member) { double(:member, id: 1, name: 'Justin Morris') }
    let(:other_member) { double(:other_member, id: 2, name: 'Gus Gollings') }

    describe 'when both members are the same member' do
      let(:other_member) { member }

      it { should be_nil }
    end

    describe 'when the member already follows the other member' do
      before do
        member.stub(:follows?).with(other_member) { true }
      end

      it do
        should == "<form action=\"/members/2/unfollow\" class=\"button_to\" "\
                  "method=\"post\"><div><input class=\"button--follow\" "\
                  "type=\"submit\" value=\"Unfollow Gus Gollings\" "\
                  "/></div></form>"
      end
    end

    describe 'when the member does not follow the other member' do
      before do
        member.stub(:follows?).with(other_member) { false }
      end

      it do
        should == "<form action=\"/members/2/follow\" class=\"button_to\" "\
                  "method=\"post\"><div><input class=\"button--follow\" "\
                  "type=\"submit\" value=\"Follow Gus Gollings\" "\
                  "/></div></form>"
      end
    end
  end

  describe '#member_relationship_status_for_members' do
    subject { member_relationship_status_for_members(member, other_member) }
    let(:member) { double(:member, id: 1, name: 'Justin Morris') }
    let(:other_member) { double(:other_member, id: 2, name: 'Gus Gollings') }

    describe 'when the member already follows the other member' do
      before do
        other_member.stub(:follows?).with(member) { true }
      end

      it { should == 'Gus Gollings follows you' }
    end

    describe 'when the member does not follow the other member' do
      before do
        other_member.stub(:follows?).with(member) { false }
      end

      it { should == 'Gus Gollings doesn’t follow you' }
    end
  end
end
