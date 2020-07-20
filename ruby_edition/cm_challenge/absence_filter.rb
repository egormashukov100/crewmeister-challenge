require 'date'
require 'memoist'

module CmChallenge
  class AbsenceFilter
    extend Memoist

    FILTER_BY = %i[user_id start_date end_date type]

    attr_reader :base_scope, :params

    def initialize(base_scope, params = {})
      @base_scope = base_scope
      @params = params
    end

    def call
      validate!

      base_scope
        .then(&method(:filter_by_user))
        .then(&method(:filter_by_type))
        .then(&method(:filter_by_start_date))
        .then(&method(:filter_by_end_date))
    end

    private

    FILTER_BY.each do |param|
      define_method "#{param}_value" do
        params[param]
      end
    end

    def validate!
      params.each do |param, value|
        throw 'Not allowed parameter', param unless FILTER_BY.include?(param)
      end
    end

    def filter_by_user(scope)
      return scope unless user_id_value

      scope.select { |record| record[:user_id] == user_id_value.to_i }
    end

    def filter_by_type(scope)
      return scope unless type_value

      scope.select { |record| record[:type] == type_value }
    end

    def filter_by_start_date(scope)
      return scope unless start_date_value

      scope.select { |record| Date.parse(record[:start_date]) >= start_date_value }
    end

    def filter_by_end_date(scope)
      return scope unless end_date_value

      scope.select { |record| Date.parse(record[:end_date]) <= end_date_value }
    end
  end
end
