module ActiveResourceChangeable

  def self.included(base)
    class << base
      def find(params)
        TraceChanges.instance_variable_set(:@original_objekt, self.new(super(params).attributes))
        super(params)
      end
    end
  end


  def changes(_self=self, original_objekt=TraceChanges.instance_variable_get(:@original_objekt))
    @changes_hash ||= HashWithIndifferentAccess.new
    _self.attributes.each do |key, value|
      ## For associated objects
      if value.is_a?(ActiveResource::Base) && !(%w(stateType countryType statusType).include?(key)) && !@changes_hash.has_key?(key)
        attr_changes = changes(value, original_objekt.send(key))
        puts "attr_changes: #{attr_changes}"
        puts "key: #{key}"
        puts "value: #{value.inspect}"
        puts "changes_hash: #{@changes_hash}\n"
        @changes_hash = {"#{key}": attr_changes} unless attr_changes.empty? && @changes_hash.has_key?(key)
      elsif original_objekt.send(key) != value
        @changes_hash.merge!({"#{key}": [original_objekt.send(key), value]})
      end
    end

    @changes_hash.deep_dup()
  end

end
