module ActiveResourceChangeable

  def self.included(base)
    class << base
      def find(params)
        TraceChanges.instance_variable_set(:@original_objekt, self.new(super(params).attributes))
        super(params)
      end
    end
  end

  @@hash = HashWithIndifferentAccess.new

  def prechanges(_self=self, original_objekt=TraceChanges.instance_variable_get(:@original_objekt), keys = [])
    hash = _self.attributes
    hash.each do |key, val|
      if val.is_a? ActiveResource::Base
        attr_changes = prechanges(val, original_objekt.send(key), keys.push(key))
        keys.pop
      elsif original_objekt.send(key) != val
        temp_hash = HashWithIndifferentAccess.new
        if keys.present?
          keys.each_with_index do |kkey, i|
            temp_hash = { "#{keys[i]}": "#{keys[i + 1]}"}
          end
          temp_hash[keys[keys.length - 1]] = {"#{key}": [original_objekt.send(key), val]}
          @@hash.merge!(temp_hash)
        else
          @@hash.merge!("#{key}": [original_objekt.send(key), val])
        end
      end
    end
  end
  
  def changes
    prechanges
    @@hash.deep_dup()
  end

end
