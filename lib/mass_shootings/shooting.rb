require 'active_model'

module MassShootings
  #
  # A `MassShooting::Shooting` is when four or more people are shot in an event,
  # or related series of events, likely without a cooling off period.
  #
  class Shooting
    include ActiveModel::AttributeMethods

    define_attribute_methods :id, :alleged_shooters, :casualties, :date,
      :location, :references

    #
    # Retrieves an attribute by name.
    #
    def attribute(name)
      @attributes[name.to_sym]
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
