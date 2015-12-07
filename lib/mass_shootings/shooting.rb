require 'active_model'
require 'active_support/core_ext/hash/keys'

module MassShootings
  #
  # A `MassShooting::Shooting` is when four or more people are shot in an event,
  # or related series of events, likely without a cooling off period.
  #
  class Shooting
    include ActiveModel::AttributeMethods
    include ActiveModel::Serializers::JSON

    class << self
      #
      # Creates a Shooting from a JSON object.
      # @return [Shooting]
      #
      def from_json(json)
        new(
          id:               json['id'],
          alleged_shooters: json['allegedShooters'],
          casualties:       json['casualties'].symbolize_keys,
          date:             Date.iso8601(json['date']),
          location:         json['location'],
          references:       json['references'].map(&method(:URI))
        )
      end
    end

    attr_reader :attributes
    define_attribute_methods :id, :alleged_shooters, :casualties, :date,
      :location, :references

    #
    # Retrieves an attribute by name.
    #
    def attribute(name)
      @attributes[name.to_sym]
    end

    #
    # Returns a hash representing the shooting.
    # @return [Hash{String => Object}]
    #
    def as_json(_=nil)
      json = {'id' => id}
      json['allegedShooters'] = alleged_shooters unless alleged_shooters.nil?
      json.merge(
        'casualties' => casualties.stringify_keys,
        'date'       => date.iso8601,
        'location'   => location,
        'references' => references.map(&:to_s))
    end

    #
    # Creates a new Shooting with the given attributes.
    #
    # @param [Hash] attributes Information pertaining to the Shooting.
    # @option attributes [String] id a unique identifier
    # @option attributes [Array<String>] alleged_shooters (nil) the names of the
    #         alleged shooters
    # @option attributes [Hash{Symbol => Integer}] casualties count of
    #         casualties, classified by type (`:dead` or `:injured`)
    # @option attributes [Date] date date the shooting occurred
    # @option attributes [String] location where the shooting occurred
    # @option attributes [Array<URI>] references links to relevant news sources
    #
    def initialize(attributes)
      @attributes = attributes
    end
  end
end
