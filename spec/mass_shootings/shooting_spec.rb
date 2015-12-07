require 'spec_helper'
require 'mass_shootings/shooting'

describe MassShootings::Shooting do
  let(:alleged_shooters) { ['Alleged Shooter'] }
  let(:casualties)       { {dead: 1, injured: 2} }
  let(:date)             { Date.today }
  let(:id)               { 'id' }
  let(:location_)        { 'Location' }
  let(:reference)        { URI 'http://example.com' }
  let(:references)       { [reference] }

  describe '.from_json' do
    subject { MassShootings::Shooting.from_json json }

    let(:json) do
      {
        'id'              => id,
        'allegedShooters' => alleged_shooters,
        'casualties'      => casualties.stringify_keys,
        'date'            => date.iso8601,
        'location'        => location_,
        'references'      => references.map(&:to_s)
      }
    end

    it 'sets the alleged shooters' do
      subject.alleged_shooters.must_equal alleged_shooters
    end

    it 'sets the casualties' do
      subject.casualties.must_equal casualties
    end

    it 'sets the date' do
      subject.date.must_equal date
    end

    it 'sets the id' do
      subject.id.must_equal id
    end

    it 'sets the location' do
      subject.location.must_equal location_
    end

    it 'sets the references' do
      subject.references.must_equal references
    end
  end

  describe '#as_json' do
    subject        { shooting.as_json }
    let(:shooting) { MassShootings::Shooting.new attributes }

    let(:attributes) do
      {
        id:               id,
        alleged_shooters: alleged_shooters,
        casualties:       casualties,
        date:             date,
        location:         location_,
        references:       references
      }
    end

    it 'sets the alleged shooters' do
      subject['allegedShooters'].must_equal alleged_shooters
    end

    it 'sets the casualties' do
      subject['casualties'].must_equal casualties.stringify_keys
    end

    it 'sets the date' do
      subject['date'].must_equal date.iso8601
    end

    it 'sets the id' do
      subject['id'].must_equal id
    end

    it 'sets the location' do
      subject['location'].must_equal location_
    end

    it 'sets the references' do
      subject['references'].must_equal references.map(&:to_s)
    end
  end
end
