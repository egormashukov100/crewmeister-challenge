require_relative '../cm_challenge/api'

RSpec.describe CmChallenge::Api do

  shared_examples 'collection' do
    it { is_expected.to respond_to(:each) }
    its(:length) { is_expected.to be_positive }
  end

  describe '#members' do
    subject { described_class.members }

    it { is_expected.to all(have_key(:id)) }
    it { is_expected.to all(have_key(:name)) }
    it { is_expected.to all(have_key(:user_id)) }

    it_behaves_like 'collection'
  end

  describe '#absences' do
    subject { described_class.absences }

    it { is_expected.to all(have_key(:id)) }
    it { is_expected.to all(have_key(:start_date)) }
    it { is_expected.to all(have_key(:end_date)) }
    it { is_expected.to all(have_key(:crew_id)) }
    it { is_expected.to all( a_hash_including(:user, a_hash_including(:name))) }

    it_behaves_like 'collection'

    context 'when user_id provided' do
      let(:params) { {user_id: 5192} }

      its(:length) { is_expected.to be(10) }
    end

    context 'when start_date provided' do
      let(:params) { {start_date: Time.new(2017, 05, 22)} }

      its(:length) { is_expected.to be(10) }
    end

    context 'when end_date provided' do
      let(:params) { {end_date: Time.new(2017, 05, 22)} }

      its(:length) { is_expected.to be(10) }
    end
  end

  describe '#vacations' do
    subject { described_class.vacations }

    it_behaves_like 'collection'

    it { is_expected.to all(end_with('is on vacation')) }

    its(:length) { is_expected.to be(10) }
  end

  describe '#sickness' do
    subject { described_class.vacations }

    it_behaves_like 'collection'

    it { is_expected.to all(end_with('is sick')) }

    its(:length) { is_expected.to be(10) }
  end
end
