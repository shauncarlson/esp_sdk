module ESP
  class CustomSignature < ESP::Resource
    ##
    # The organization this custom signature belongs to.
    belongs_to :organization, class_name: 'ESP::Organization'

    # Run a custom signature that has not been saved.  Useful for debugging a custom signature.
    # Returns a collection of alerts.
    # Throws an error if not successful.
    #
    # ==== Valid Arguments
    #
    # * +external_account_id+ - The external account to run the custom signature against.
    # * +signature+ - The signature code, in either ruby or javascript
    # * +language+ - The language the signature is written in.  Valid values are ruby, javascript
    # * +regions+ - An array of regions to run the custom signature in
    #
    # ==== Example
    #   alerts = ESP::CustomSignature.run!(external_account_id: 3, regions: ['us_east_1'], language: 'ruby', signature: 'signature code written in ruby')
    def self.run!(arguments = {})
      result = run(arguments)
      return result if result.is_a?(ActiveResource::Collection)
      result.message = result.errors.full_messages.join(' ')
      fail(ActiveResource::ResourceInvalid.new(result)) # rubocop:disable Style/RaiseArgs
    end

    # Run a custom signature that has not been saved.  Useful for debugging a custom signature.
    # Returns a collection of alerts.
    # If not successful, returns a CustomSignature object with the errors object populated.
    #
    # ==== Valid Arguments
    #
    # * +external_account_id+ - The external account to run the custom signature against.
    # * +signature+ - The signature code, in either ruby or javascript
    # * +language+ - The language the signature is written in.  Valid values are ruby, javascript
    # * +regions+ - An array of regions to run the custom signature in
    #
    # ==== Example
    #   alerts = ESP::CustomSignature.run(external_account_id: 3, regions: ['us_east_1'], language: 'ruby', signature: 'signature code written in ruby')
    def self.run(arguments = {})
      arguments = arguments.with_indifferent_access
      arguments[:regions] = Array(arguments[:regions])
      new(arguments).run
    end

    # Run this custom signature instance.
    # Returns a collection of alerts.
    # Throws an error if not successful.
    #
    # ==== Valid Arguments
    #
    # * +external_account_id+ - The external account to run the custom signature against.
    # * +regions+ - An array of regions to run the custom signature in
    #
    # ==== Example
    #   custom_signature = ESP::CustomSignature.find(365)
    #   alerts = custom_signature.run!(external_account_id: 3, regions: ['us_east_1'])
    def run!(arguments = {})
      result = run(arguments)
      return result if result.is_a?(ActiveResource::Collection)
      self.message = errors.full_messages.join(' ')
      fail(ActiveResource::ResourceInvalid.new(self)) # rubocop:disable Style/RaiseArgs
    end

    # Run this custom signature instance.
    # Returns a collection of alerts.
    # If not successful, returns a CustomSignature object with the errors object populated.
    #
    # ==== Valid Arguments
    #
    # * +external_account_id+ - The external account to run the custom signature against.
    # * +regions+ - An array of regions to run the custom signature in
    #
    # ==== Example
    #   custom_signature = ESP::CustomSignature.find(365)
    #   alerts = custom_signature.run(external_account_id: 3, regions: ['us_east_1'])
    def run(arguments = {})
      arguments = arguments.with_indifferent_access

      attributes['external_account_id'] ||= arguments[:external_account_id]
      attributes['regions'] ||= Array(arguments[:regions])

      response = connection.post endpoint, to_json
      ESP::Alert.send(:instantiate_collection, self.class.format.decode(response.body))
    rescue ActiveResource::BadRequest, ActiveResource::ResourceInvalid => error
      load_remote_errors(error, true)
      self.code = error.response.code
      self
    end

    ##
    # :singleton-method: find
    # Find a CustomSignature by id
    # :call-seq:
    #  find(id)

    # :singleton-method: create
    # Create a CustomSignature
    # :call-seq:
    #   create(attributes={})
    #
    # ==== Valid Attributes
    #
    # * +name+
    # * +risk_level+
    # * +resolution+
    # * +description+
    # * +signature+
    # * +active+
    # * +language+
    # * +identifier+

    # :method: save
    # Create or update a CustomSignature
    #
    # ==== Valid Attributes
    #
    # * +name+
    # * +risk_level+
    # * +resolution+
    # * +description+
    # * +signature+
    # * +active+
    # * +language+
    # * +identifier+
    #
    # :call-seq:
    #   save
    #   new(attributes={}).save

    # :method: destroy
    # Delete a CustomSignature

    private

    def endpoint
      if id.present?
        "#{self.class.prefix}custom_signatures/#{id}/run.json"
      else
        "#{self.class.prefix}custom_signatures/run.json"
      end
    end
  end
end
