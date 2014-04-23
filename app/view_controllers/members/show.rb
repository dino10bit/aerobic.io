require 'i18n'
require 'kaminari'

module Members
  # View Controller for managing the logic around rendering /members/show
  #
  class Show
    include Rails.application.routes.url_helpers

    attr_reader :member

    def initialize(controller, current_member, member_id, page = 1)
      @controller = controller
      @current_member = current_member
      @member = User.find(member_id)
      @page = page
    end

    def cache_key
      [
        @current_member.cache_key,
        @member.cache_key,
        workouts.map(&:cache_key)
      ].flatten.join(':')
    end

    def render_workouts
      if workouts.any?
        @controller.render(partial: 'workouts/grouped',
                           object: workouts.group_by(&:date),
                           locals: { workouts: workouts }
                          ).first
      else
        if @current_member == member
          I18n.t('workouts.none.first_person')
        else
          I18n.t('workouts.none.third_person', name: member.name)
        end
      end
    end

    def member_title
      if viewing_self?
        'You'
      else
        @member.name
      end
    end

    def member_joined_date
      member.created_at
    end

    def workouts_count
      workouts.count
    end

    def follower_count
      followers.count
    end

    def following_count
      following.count
    end

    def workouts_path
      member_workouts_path(@member.id)
    end

    def followers_path
      member_followers_path(@member.id)
    end

    def followings_path
      member_follows_path(@member.id)
    end

    private

    def viewing_self?
      @current_member == @member
    end

    def followers
      @followers ||= @member.followers
    end

    def following
      @following ||= @member.followings
    end

    def workouts
      @workouts ||= @member.workouts.desc.page(@page)
    end
  end
end
