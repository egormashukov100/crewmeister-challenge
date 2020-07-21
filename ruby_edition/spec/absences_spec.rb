# frozen_string_literal: true

require_relative '../cm_challenge/absences'

RSpec.describe CmChallenge::Absences do
  describe '#to_ical' do
    subject { described_class.to_ical }
  end
end
