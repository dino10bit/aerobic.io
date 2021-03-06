require 'load_paths_helper'
require 'support/active_record_array_with_kaminari'
require 'members/show'

describe Members::Show do
  let(:view) { described_class.new(context, current_member, member_id) }
  let(:context) { double(:context) }

  let(:current_member) do
    double(:current_member, id: 1, cache_key: '1', name: 'Justin Morris')
  end

  let(:member_id) { 2 }

  let(:member) do
    double(:member,
           name: 'Justin',
           id: member_id,
           cache_key: member_id.to_s,
           workouts: member_workouts,
           followers: member_followers,
           followings: member_followings
          )
  end

  let(:member_followers) { [double, double, double] }
  let(:member_followings) { [double] }
  let(:member_workouts) do
    ActiveRecordArrayWithKaminari.new([workout_1, workout_2])
  end

  let(:workout_1) { double(:workout_1, cache_key: 'a1', date: Date.today) }
  let(:workout_2) { double(:workout_2, cache_key: 'a2', date: Date.today) }

  before do
    stub_const('User', Class.new)
    User.should_receive(:find).with(member_id) { member }
  end

  describe '#cache_key' do
    subject(:cache_key) { view.cache_key }

    it 'should be a combination of the members cached keys' do
      cache_key.should == '1:2:a1:a2'
    end
  end

  describe '#render_workouts' do
    subject(:render_workouts) { view.render_workouts }

    let(:render_params) do
      {
        partial: 'workouts/grouped',
        object: { Date.today =>  member_workouts.page },
        locals: { workouts: member_workouts.page }
      }
    end

    context 'when the member has workouts' do
      let(:member_workouts) { ActiveRecordArrayWithKaminari.new([workout_1]) }

      before do
        context.should_receive(:render).with(render_params) do
          'render'
        end
      end

      it 'should render the workouts' do
        render_workouts.should == 'render'
      end
    end

    context 'when the member has no workouts' do
      let(:member_workouts) { ActiveRecordArrayWithKaminari.new([]) }

      context 'and is looking at their own feed' do
        let(:current_member) { member }

        before do
          I18n.should_receive(:t)
          .with('workouts.none.first_person') do
            'You have no workouts!'
          end
        end

        it 'should render a message stating so' do
          render_workouts.should == 'You have no workouts!'
        end
      end

      context 'when looking at another members feed' do
        before do
          I18n.should_receive(:t)
          .with('workouts.none.third_person', name: member.name) do
            'Gareth Townsend has no workouts!'
          end
        end

        it 'should render a message stating so' do
          render_workouts.should == 'Gareth Townsend has no workouts!'
        end
      end
    end
  end

  describe '#member_title' do
    subject { view.member_title }

    it { should == 'Justin' }

    context 'the current_member is the member' do
      let(:current_member) { member }

      it { should == 'Hey, it’s you!' }
    end
  end
end
