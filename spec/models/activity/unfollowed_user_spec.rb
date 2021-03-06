require 'load_paths_helper'
require 'active_record_helper'
require 'support/shared/activity'
require 'activity/unfollowed_user'

describe Activity::UnfollowedUser do
  before do
    Time.zone = 'Melbourne'
  end

  it_should_behave_like 'an activity model'
  it_should_behave_like 'an activity models public API'
end
