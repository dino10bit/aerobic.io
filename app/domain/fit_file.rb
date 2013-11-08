require 'fit'
require_relative "shared/initialize_from_data_object"
require_relative "workout"

module Domain

  # FitFile parses FIT data files and persists them.
  class FitFile
    include Domain::Shared::InitializeFromDataObject

    def persist!
      ::FitFile.transaction do
        fit_file = ::FitFile.new(name: @name, binary_data: @binary_data)
        workout = Domain::Workout.new(workout_data_object)
        workout.persist!
        fit_file.workout_id = workout.id
        fit_file.save!
      end
    end

    def active_duration
      totals.raw_total_timer_time
    end

    def distance
      totals.raw_total_distance
    end

    def duration
      totals.raw_total_elapsed_time
    end

    def end_time
      Time.zone.at(epoch + totals.raw_timestamp)
    end

    def start_time
     Time.zone.at(epoch + totals.raw_start_time)
    end

    private

    def workout_data_object
      OpenStruct.new( active_duration: active_duration,
                      distance: distance,
                      duration: duration,
                      end_time: end_time,
                      start_time: start_time,
                      user_id: @user_id,
                    )
    end

    def epoch
      Time.use_zone("UTC") do
        fit_epoch = Date.new(1989, 12, 31).in_time_zone.to_i
      end
    end

    # {"raw_timestamp"=>742862941, "raw_start_time"=>742852839,
    # "raw_start_position_lat"=>-450940140,
    # "raw_start_position_long"=>1729641408,
    # "raw_end_position_lat"=>-450940219, "raw_end_position_long"=>1729638741,
    # "raw_total_elapsed_time"=>10102350, "raw_total_timer_time"=>5483130,
    # "raw_total_distance"=>4132004, "raw_total_strides"=>4294967295,
    # "raw_field_27"=>2147483647, "raw_field_28"=>2147483647,
    # "raw_field_29"=>2147483647, "raw_field_30"=>2147483647,
    # "raw_message_index"=>0, "raw_total_calories"=>1100,
    # "raw_total_fat_calories"=>65535, "raw_avg_speed"=>7536,
    # "raw_max_speed"=>16121, "raw_avg_power"=>193, "raw_max_power"=>906,
    # "raw_total_ascent"=>423, "raw_total_descent"=>450, "raw_event"=>9,
    # "raw_event_type"=>1, "raw_avg_heart_rate"=>155, "raw_max_heart_rate"=>200,
    # "raw_avg_running_cadence"=>85, "raw_max_running_cadence"=>120,
    # "raw_intensity"=>0, "raw_lap_trigger"=>0, "raw_sport"=>2}
    def totals
      @total ||= to_fit.records
                       .select { |m| m.header[:message_type] == 0 }
                       .select { |m| m.header[:local_message_type] == 6 }
                       .first
                       .content
    end

    def to_fit
      @fit ||= Fit::File.read(StringIO.new(@binary_data))
    end
  end
end
