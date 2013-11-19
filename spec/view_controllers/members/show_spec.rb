require_relative "../../../app/view_controllers/members/show"

describe Members::Show do
  let(:view) { described_class.new(controller, current_member, member_id) }
  let(:controller) { double(:controller) }
  let(:current_member) { double(:current_member, id: 1, cache_key: "1") }
  let(:member_id) { 2 }

  let(:member) do
    double(:member,
           id: member_id,
           cache_key: member_id.to_s,
           activities: member_activities,
          )
  end

  let(:member_activities) { [activity_1, activity_2] }
  let(:activity_1) { double(:activity_1, cache_key: "a1") }
  let(:activity_2) { double(:activity_2, cache_key: "a2") }

  before do
    stub_const("User", Class.new)
    User.should_receive(:find).with(member_id) { member }
  end

  describe "#cache_key" do
    subject(:cache_key) { view.cache_key }

    it "should be a combination of the members cached keys" do
      cache_key.should == "1:2:a1:a2"
    end
  end

  describe "#render_activities" do
    subject(:render_activities) { view.render_activities }

    context "when the member has activities" do
      let(:member_activities) { [activity_1, activity_2] }

      before do
        controller.should_receive(:render).with(member_activities) do
          ["render"]
        end
      end

      it "should render the activities" do
        render_activities.should == "render"
      end
    end

    context "whent he member has no activities" do
      let(:member_activities) { [] }

      it "should render a message stating so" do
        render_activities.should == "You have no activity!"
      end
    end
  end
end
