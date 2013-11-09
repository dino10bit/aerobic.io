require "interactor"

# Takes a member_id and an unfollowed_id and removes the following relationship
# between the member and the unfollowed member.
#
class DeleteFollowing
  include Interactor

  def perform
    followed_member = User.find(unfollowed_id)

    ActiveRecord::Base.connection.execute(delete_user_followings_sql)
    context[:notice] = "No longer following #{followed_member.name}"
  end

  private

  def delete_user_followings_sql
    sql = <<-SQL
      delete from users_followings
      where user_id = #{member_id}
      and following_id = #{unfollowed_id}
    SQL
  end
end
