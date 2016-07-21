require "truevault/client"

module TrueVault
  class Group < Client
    def create(options = {})
      query = {
        query: {
          name: options[:name],
          policy: policy(options),
          user_ids: to_string(options[:user_ids])
          }
        }
      new_options = default_options_to_merge_with.merge(query)
      self.class.post("/#{@api_ver}/groups", new_options)
    end

    def find(group_id, options = {})
      options.merge!(default_options_to_merge_with)
      self.class.get("/#{@api_ver}/groups/#{group_id}", options)
    end

    def delete(group_id, options = {})
      options.merge!(default_options_to_merge_with)
      self.class.delete("/#{@api_ver}/groups/#{group_id}", options)
    end

    def update(group_id, options = {})
      query = {}
      query[:name] = options[:name] if options[:name]
      query[:policy] = policy(options) if options[:policy]
      query[:user_ids] = to_string(options[:user_ids]) if options[:user_ids]
      query[:operation] = options[:operation] if options[:operation]

      new_options = default_options_to_merge_with.merge(query: query)
      self.class.put("/#{@api_ver}/groups/#{group_id}", new_options)
    end

    def add_users(group_id, user_ids)
      query = {
        query: {
          user_ids: to_string(user_ids),
          operation: "APPEND"
          }
        }
      new_options = default_options_to_merge_with.merge(query)
      self.class.put("/#{@api_ver}/groups/#{group_id}", new_options)
    end

    def remove_users(group_id, user_ids)
      query = {
        query: {
          user_ids: to_string(user_ids),
          operation: "REMOVE"
          }
        }
      new_options = default_options_to_merge_with.merge(query)
      self.class.put("/#{@api_ver}/groups/#{group_id}", new_options)
    end

    def all
      self.class.get("/#{@api_ver}/groups", default_options_to_merge_with)
    end

    private

    def policy(options)
      if options[:policy]
        hash_to_base64_json(options[:policy])
      end
    end
  end
end
