require 'mass_shootings/shooting'
require 'nokogiri'

module MassShootings
  module Tracker
    class Page
      include Enumerable

      attr_reader :page_id, :wiki
      delegate :each, to: :shootings
      delegate :[], to: :indexed

      def initialize(page_id, data)
        @page_id = page_id
        @wiki = Nokogiri::HTML.parse(data).css '.wiki'
      end

      private

      def format
        @format ||= /\A\s*Number\s*(?<number>.+?):\s*
          (?<date>.+?),\s*
          (?<alleged_shooters>.+),\s*
          (?<casualties>.*?\d.*?),\s*
          (?<location>.+)\s*\Z/x
      end

      def indexed
        @indexed ||= Hash[shootings.map { |shooting| [shooting.id, shooting] }]
      end

      def parse(elements)
        h2, as = elements[0], elements[1..-1]

        format.match h2.content do |match|
          alleged_shooters = parse_alleged_shooters match['alleged_shooters']
          attributes = {
            id:         "#{page_id}-#{match['number']}",
            casualties: parse_casualties(match['casualties']),
            date:       parse_date(match['date']),
            location:   match['location'],
            references: as.map { |a| URI(a[:href]) }
          }

          if alleged_shooters.any?
            attributes[:alleged_shooters] = alleged_shooters
          end

          Shooting.new attributes
        end
      end

      def parse_alleged_shooters(alleged_shooters)
        alleged_shooters.
          split(/\s*(?:,?\s+(?:and|&)\s+|[,;](?!\s*Jr\.))\s*/).
          reject do |shooter|
            shooter =~ /identified|identity|unnamed|unkn?own|unreported/i
          end
      end

      def parse_casualties(casualties)
        Hash[
          casualties.
            scan(/(\d+)\s+(.+?)\b/).
            map { |count, type| [type.to_sym, count.to_i] }
        ]
      end

      def parse_date(date)
        result = Date.strptime date, '%m/%d/%Y'
        result.year < 100 ? Date.strptime(date, '%m/%d/%y') : result
      rescue

      end

      def shootings
        @shootings ||= wiki.
          xpath('child::h2 | child::h2/following-sibling::p/a').
          slice_before { |element| element.node_name == 'h2' }.
          map(&method(:parse))
      end
    end
  end
end
