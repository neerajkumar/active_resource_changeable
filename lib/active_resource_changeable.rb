require_relative "./active_resource_changeable/version"
require "active_support"

module ActiveResourceChangeable
  extend ActiveSupport::Concern

  included do
    before_save :previous_values

    after_save :changes
  end

  attr_reader :previous_objekt

  def previous_values
    self.previous_objekt = self.class.new(self.attributes)
  end


  def changes
    changes = {}

    self.attributes.each do |key, value|
      changes.merge({key: [self.previous_objekt.send(key), value]}) if self.previous_objekt.send(key) != value
    end

    changes
  end

end
