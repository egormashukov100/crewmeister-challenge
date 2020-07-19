require 'json'

module CmChallenge
  class Api
    class << self
      def absences(user_id: nil, start_date: nil, end_date: nil)
        load_file('absences.json')
        # TODO: 1) map for absences.json and add user info to absence
      end

      def vacations
        # TODO: 3) list abcenses where type == 'vacation'
        # "#{member.name} is on vacation"
      end

      def sickness
        # TODO: 4) list abcenses where type == 'sickness'
        # "#{member.name} is sick"
      end

      def members
        load_file('members.json')
      end

      private

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

# puts CmChallenge::Api.absences.first
# puts CmChallenge::Api.members.first
