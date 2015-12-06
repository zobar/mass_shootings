require 'spec_helper'
require 'mass_shootings/tracker'

describe MassShootings::Tracker do
  let(:alleged_shooters) { ['Alleged Shooter'] }
  let(:casualties)       { {dead: dead, injured: injured} }
  let(:date)             { Date.today }
  let(:dead)             { 1 }
  let(:injured)          { 2 }
  let(:id)               { "#{year}-#{number}" }
  let(:location_)        { 'City, ST' }
  let(:number)           { 1 }
  let(:reference)        { URI('http://example.com/reference') }
  let(:references)       { [reference] }
  let(:year)             { date.year }

  let(:description) do
    [
      "Number #{number}: #{date.strftime('%-m/%-d/%Y')}",
      alleged_shooters.join(' and '),
      casualties.map { |c| c.reverse.join ' ' }.join(' '),
      location_
    ].join ', '
  end

  let(:page) do
    <<-HTML
      <!DOCTYPE html>
      <title></title>
      <div class='wiki'>
        <h2>#{description}</h2>
        <p><a href='#{reference}'>#{reference}</a>
      </div>
    HTML
  end

  let(:uri) do
    URI "https://www.reddit.com/r/GunsAreCool/wiki/#{year}massshootings"
  end

  before { Net::HTTP.stubs(:get).with(uri).returns(page) }
  after  { MassShootings::Tracker.reset }

  describe '.get' do
    subject { MassShootings::Tracker.get id }

    it 'sets the alleged shooter' do
      subject.alleged_shooters.must_equal alleged_shooters
    end

    it 'sets the date' do
      subject.date.must_equal date
    end

    it 'sets the dead' do
      subject.casualties[:dead].must_equal dead
    end

    it 'sets the id' do
      subject.id.must_equal id
    end

    it 'sets the injured' do
      subject.casualties[:injured].must_equal injured
    end

    it 'sets the location' do
      subject.location.must_equal location_
    end

    it 'sets the references' do
      subject.references.must_equal references
    end

    describe 'with an unknown alleged shooter' do
      let(:alleged_shooters) { ['Unknown'] }

      it 'does not set the alleged shooter' do
        subject.alleged_shooters.must_be_nil
      end
    end

    describe 'with an unidentified alleged shooter' do
      let(:alleged_shooters) { ['Unidentified'] }

      it 'does not set the alleged shooter' do
        subject.alleged_shooters.must_be_nil
      end
    end

    describe 'with two alleged shooters' do
      let(:alleged_shooters) { ['Alleged', 'Shooter'] }

      it 'sets the alleged shooters' do
        subject.alleged_shooters.must_equal alleged_shooters
      end
    end

    describe 'with three alleged shooters' do
      let(:alleged_shooters)           { ['Three', 'Alleged', 'Shooters'] }
      let(:formatted_alleged_shooters) { 'Three, Alleged, and Shooters' }

      it 'sets the alleged shooters' do
        subject.alleged_shooters.must_equal alleged_shooters
      end
    end
  end

  describe '.in_date_range' do
    subject          { MassShootings::Tracker.in_date_range date_range }
    let(:date_2)     { date.prev_year }
    let(:date_range) { from...to }
    let(:from)       { date_2 }
    let(:id_2)       { "#{year_2}-#{number_2}" }
    let(:number_2)   { 7 }
    let(:to)         { date }
    let(:year_2)     { date_2.year }

    let(:description_2) do
      "Number #{number_2}: #{date_2.strftime('%-m/%-d/%Y')}, Alleged Shooter 2, 11 dead 12 injured, City 2, S2"
    end

    let(:page_2) do
      <<-HTML
        <!DOCTYPE html>
        <title></title>
        <div class='wiki'>
          <h2>#{description_2}</h2>
        </div>
      HTML
    end

    let(:uri_2) do
      URI "https://www.reddit.com/r/GunsAreCool/wiki/#{year_2}massshootings"
    end

    before { Net::HTTP.stubs(:get).with(uri_2).returns(page_2) }

    describe 'exclusive' do
      it 'excludes shootings on the end date' do
        subject.map(&:id).must_equal [id_2]
      end
    end

    describe 'inclusive' do
      let(:date_range) { from..to }

      it 'includes shootings on the end date' do
        subject.map(&:id).must_equal [id_2, id]
      end
    end
  end
end
