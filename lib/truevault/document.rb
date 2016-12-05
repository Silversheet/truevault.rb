require 'truevault/client'

module TrueVault
  class Document < Client
    ####################################################
    ## JSON (structured text data store) API Methods  ##
    ####################################################

    # vault_id        should be a valid vault ID
    # document_id     should be a valid document ID
    # document_data   should be a Ruby Hash. Method will convert it to JSON and base64 encode as required
    def create(vault_id, document_data, options = {})
      body = {}
      body[:document] = hash_to_base64_json(document_data)
      body[:owner_id] = options[:owner_id] if options[:owner_id]

      new_options = default_options_to_merge_with.merge(body: body)
      self.class.post("/#{@api_ver}/vaults/#{vault_id}/documents", new_options)
    end

    def find(vault_id, document_id, options = {})
      options.merge!(default_options_to_merge_with)
      self.class.get("/#{@api_ver}/vaults/#{vault_id}/documents/#{document_id}", options)
    end

    def delete(vault_id, document_id, options = {})
      options.merge!(default_options_to_merge_with)
      self.class.delete("/#{@api_ver}/vaults/#{vault_id}/documents/#{document_id}", options)
    end

    def update(vault_id, document_id, document_data, options = {})
      options.merge!(default_options_to_merge_with)
      options[:body] = {:document => hash_to_base64_json(document_data)}
      self.class.put("/#{@api_ver}/vaults/#{vault_id}/documents/#{document_id}", options)
    end

    def update_owner(vault_id, document_id, owner_id)
      query = { body: { owner_id: owner_id } }
      options = default_options_to_merge_with.merge(query)

      self.class.put(
        "/#{@api_ver}/vaults/#{vault_id}/documents/#{document_id}/owner",
        options
      )
    end

    def all(vault_id)
      self.class.get("/#{@api_ver}/vaults/#{vault_id}/documents", default_options_to_merge_with)
    end
  end
end
