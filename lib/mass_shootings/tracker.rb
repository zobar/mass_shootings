require 'active_support/core_ext/range/overlaps'

module MassShootings
  #
  # Retrieves mass shootings from the [r/GunsAreCool shooting tracker]
  # (https://www.reddit.com/r/GunsAreCool/wiki/2015massshootings).
  #
  module Tracker
    autoload :Page, 'mass_shootings/tracker/page'
    private_constant :Page

    class << self
      #
      # Retrieves a `Shooting` by unique ID.
      # @param [String] id the `Shooting`'s unique identifier. This is opaque;
      #        you should not depend on its format.
      # @return [Shooting]
      #
      def get(id)
        year, number = id.split '-', 2
        page(year)[id]
      end

      #
      # Retrieves all `Shooting`s that occurred within a date range.
      # @param [Range<Date>] date_range the date range to search. Inclusive and
      #        exclusive ranges are both supported.
      # @return [Array<Shooting>]
      #
      def in_date_range(date_range)
        pages_in_date_range(date_range).
          map(&method(:page)).
          flat_map(&:to_a).
          select { |shooting| date_range.cover? shooting.date }
      end

      #
      # Invalidates the in-memory cache. In a long-running process, you should
      # arrange for this method to be called approximately every 24 hours and 36
      # minutes.
      # @return [void]
      #
      def reset
        @pages = {}
      end

      private

      def page(year)
        pages[year] ||= Page.new year, Net::HTTP.get(uri(year))
      end

      def pages
        @pages || reset
      end

      def pages_in_date_range(date_range)
        result = []
        year = date_range.begin.year
        while date_range.overlaps? Date.new(year, 1, 1)...Date.new(year + 1, 1, 1)
          result << year.to_s
          year += 1
        end
        result
      end

      def uri(year)
        URI "https://www.reddit.com/r/GunsAreCool/wiki/#{year}massshootings"
      end
    end
  end
end
