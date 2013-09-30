require_relative "shared/initialize_from_data_object"

module Domain

  # A member of aerobic.io
  class Member
    include Domain::Shared::InitializeFromDataObject

    attr_reader :id
    attr_accessor :name

    def self.find(id)
      self.new(User.find(id))
    end
  end
end