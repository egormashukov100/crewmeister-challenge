require 'json'
require 'memoist'
require_relative 'absence_filter'

module CmChallenge
  class Api
    class << self
      extend Memoist

      def absences(params)
        include_user(AbsenceFilter.new(load_file('absences.json'), params).call)
        # AbsenceFilter.new(load_file('absences.json'), params).call.tap do |scope|
        #   include_user(scope)
        # end
      end

      def vacations
        # AbsenceFilter.new(load_file('absences.json'), type: 'vacation').call
      end

      def sickness
        # AbsenceFilter.new(load_file('absences.json'), type: 'sickness').call
      end

      def members
        load_file('members.json')
      end

      private

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

# puts CmChallenge::Api.absences(user_id: 2735)
# puts CmChallenge::Api.absences(type: 'vacation')
# puts CmChallenge::Api.absences(type: 'sickness')
# puts CmChallenge::Api.members.first
