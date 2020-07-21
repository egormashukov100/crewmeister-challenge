require 'icalendar'
require_relative './api'

module CmChallenge
  class Absences
    def self.to_ical(params)
      Icalendar::Calendar.new.tap do |cal|
        CmChallenge::Api.absences(params).each do |absence|
          cal.event do |e|
            e.dtstart     = Icalendar::Values::DateTime.new(Date.parse(absence[:start_date]))
            e.dtend       = Icalendar::Values::DateTime.new(Date.parse(absence[:end_date]))
            e.summary     = absence[:type]
            e.description = absence[:member_note]
            e.location    = absence[:formatted_address]
          end
        end
      end.to_ical
    end
  end
end
