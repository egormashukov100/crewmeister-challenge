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
    subject { described_class.absences(params) }

    let(:params) { {} }

    it { is_expected.to all(have_key(:id)) }
    it { is_expected.to all(have_key(:start_date)) }
    it { is_expected.to all(have_key(:end_date)) }
    it { is_expected.to all(have_key(:crew_id)) }
    it { is_expected.to all( a_hash_including(:user)) } # TODO: Also test that user has :name and :id
    it { is_expected.to all( a_hash_including(:user)) } # TODO: Also test that user has :name and :id

    it_behaves_like 'collection'

    context 'when non existing parameter' do
      let(:params) { {wrong: 123} }

      it { expect { subject }.to raise_error }
    end

    context 'when user_id provided' do
      let(:params) { {user_id: 5192} }

      its(:length) { is_expected.to be(1) }
    end

    context 'when start_date provided' do
      let(:params) { {start_date: Date.new(2017, 6, 1)} }

      its(:length) { is_expected.to be(10) }
    end

    context 'when end_date provided' do
      let(:params) { {end_date: Date.new(2017, 2, 1)} }

      its(:length) { is_expected.to be(4) }
    end
  end

  describe '#vacations' do
    subject { described_class.vacations }

    it_behaves_like 'collection'

    it { is_expected.to all(end_with('is on vacation')) }

    its(:length) { is_expected.to be(35) }
  end

  describe '#sickness' do
    subject { described_class.sickness }

    it_behaves_like 'collection'

    it { is_expected.to all(end_with('is sick')) }

    its(:length) { is_expected.to be(7) }
  end
end
