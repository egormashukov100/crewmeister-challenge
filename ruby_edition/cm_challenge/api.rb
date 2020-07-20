require 'json'
require 'memoist'

require_relative 'absence_filter'

module CmChallenge
  class Api
    class << self
      extend Memoist

      def absences(params = {})
        absence_filter(params)
      end

      def vacations
        absence_filter(type: 'vacation').map do |absence|
          "#{absence[:user][:name]} is on vacation"
        end
      end

      def sickness
        absence_filter(type: 'sickness').map do |absence|
          "#{absence[:user][:name]} is sick"
        end
      end

      def members
        load_file('members.json')
      end

      private

      def absence_filter(params)
        AbsenceFilter.new(load_file('absences.json'), params).call.tap(&method(:include_user))
      end

      def include_user(scope)
        scope.map do |absence|
          absence.tap do |record|
            record[:user] = members_by_id[record[:user_id]]
            record.delete(:user_id)
          end
        end
      end

      memoize def members_by_id
        members.each_with_object({}) do |record, result|
          result[record[:user_id]] = record
          result[record[:user_id]].delete(:user_id)
        end
      end

      def load_file(file_name)
        file = File.join(File.dirname(__FILE__), 'json_files', file_name)
        json = JSON.parse(File.read(file))
        symbolize_collection(json['payload'])
      end

      def symbolize_collection(collection)
        collection.map { |hash| symbolize_hash(hash)}
      end

      def symbolize_hash(hash)
        hash.each_with_object({}) { |(k, v), h| h[k.to_sym] = v; }
      end
    end
  end
end
