require_relative "../../spec_helper"

describe TrueVault::Group do
  describe "create a group" do
    let(:real_group){ TrueVault::Group.new(ENV["TV_API_KEY"], ENV["TV_ACCOUNT_ID"], "v1") }
    let(:create_group){ real_group.create(attributes_for(:group)) }

    before do
      VCR.insert_cassette "create_group"
    end

    after do
      VCR.eject_cassette
    end

    it "must parse the API response from JSON to a Ruby Hash" do
      create_group.must_be_instance_of Hash
    end

    it "must have been a successful API request" do
      create_group["result"].must_equal "success"
    end

    it "must have a redacted transaction_id" do
      create_group["transaction_id"].must_equal REDACTED_STRING
    end
  end

  describe "list groups" do
    let(:real_group){ TrueVault::Group.new(ENV["TV_API_KEY"], ENV["TV_ACCOUNT_ID"], "v1") }
    let(:list_groups){ real_group.all }

    before do
      VCR.insert_cassette "list_groups"
    end

    after do
      VCR.eject_cassette
    end

    it "must have been a successful API request" do
      list_groups["result"].must_equal "success"
    end

    it "must return a list of groups" do
      list_groups["groups"].wont_be_empty
    end
  end

  describe "find a group" do
    let(:real_group){ TrueVault::Group.new(ENV["TV_API_KEY"], ENV["TV_ACCOUNT_ID"], "v1") }
    let(:create_group) do
      VCR.use_cassette("create_group") { real_group.create(attributes_for(:group)) }
    end

    let(:find_group){ real_group.find(create_group["group"]["group_id"])}

    before do
      VCR.insert_cassette "find_group"
    end

    after do
      VCR.eject_cassette
    end

    it "must have been a successful API request" do
      find_group["result"].must_equal "success"
    end

    it "must return the group name" do
      find_group["group"]["name"].wont_be_empty
    end
  end

  describe "update a group" do
    let(:new_name) { "new name" }
    let(:real_group){ TrueVault::Group.new(ENV["TV_API_KEY"], ENV["TV_ACCOUNT_ID"], "v1") }

    let(:create_group) do
      VCR.use_cassette("create_group") { real_group.create(attributes_for(:group)) }
    end

    let(:update_group) do
      group_id = create_group["group"]["group_id"]
      real_group.update(group_id, {name: new_name})
    end

    before do
      VCR.insert_cassette "update_group"
    end

    after do
      VCR.eject_cassette
    end

    it "must have been a successful API request" do
      update_group["result"].must_equal "success"
    end

    it "must return the new group name" do
      update_group["group"]["name"].must_equal new_name
    end
  end

  describe "add user to a group" do
    let(:real_group){ TrueVault::Group.new(ENV["TV_API_KEY"], ENV["TV_ACCOUNT_ID"], "v1") }
    let(:real_user){ TrueVault::User.new(ENV["TV_API_KEY"], ENV["TV_ACCOUNT_ID"], "v1") }

    let(:create_group) do
      VCR.use_cassette("create_group") { real_group.create(attributes_for(:group)) }
    end

    let(:create_user) do
      VCR.use_cassette("create_user") do
        real_user.create(attributes_for(:user, attributes: attributes_for(:user_attributes)))
      end
    end

    let(:add_user) do
      group_id = create_group["group"]["group_id"]
      user_id = create_user["user"]["user_id"]
      real_group.add_users(group_id, user_id)
    end

    before do
      VCR.insert_cassette "add_user_to_group"
    end

    after do
      VCR.eject_cassette
    end

    it "must have been a successful API request" do
      add_user["result"].must_equal "success"
    end

    it "must return the user_ids" do
      add_user["group"]["user_ids"].wont_be_empty
    end
  end

  describe "remove user from a group" do
    let(:real_group){ TrueVault::Group.new(ENV["TV_API_KEY"], ENV["TV_ACCOUNT_ID"], "v1") }
    let(:real_user){ TrueVault::User.new(ENV["TV_API_KEY"], ENV["TV_ACCOUNT_ID"], "v1") }

    let(:create_group) do
      VCR.use_cassette("create_group") { real_group.create(attributes_for(:group)) }
    end

    let(:create_user) do
      VCR.use_cassette("create_user") do
        real_user.create(attributes_for(:user, attributes: attributes_for(:user_attributes)))
      end
    end

    let(:remove_user) do
      group_id = create_group["group"]["group_id"]
      user_id = create_user["user"]["user_id"]
      real_group.remove_users(group_id, user_id)
    end

    before do
      VCR.insert_cassette "remove_user_from_group"
    end

    after do
      VCR.eject_cassette
    end

    it "must have been a successful API request" do
      remove_user["result"].must_equal "success"
    end

    it "must return the user_ids" do
      remove_user["group"]["user_ids"].must_be_empty
    end
  end

  describe "delete a group" do
    let(:real_group){ TrueVault::Group.new(ENV["TV_API_KEY"], ENV["TV_ACCOUNT_ID"], "v1") }
    let(:create_group) do
      VCR.use_cassette("create_deletable_group") do
        real_group.create(attributes_for(:deletable_group))
      end
    end
    let(:delete_group){ real_group.delete(create_group["group"]["group_id"]) }

    before do
      VCR.insert_cassette "delete_group"
    end

    after do
      VCR.eject_cassette
    end

    it "must have been a successful API request" do
      delete_group["result"].must_equal "success"
    end
  end
end
