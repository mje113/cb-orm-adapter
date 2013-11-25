require 'spec_helper'
require 'example_app_shared'

if !defined?(Couchbase::Model)
  puts "** require 'coucbase/model' to run the specs in #{__FILE__}"
else
  Couchbase.bucket # establish connection to default

  module CbOrmSpec
    class User < Couchbase::Model
      attribute :name
    end

    class Note < Couchbase::Model
      # belongs_to :user
    end

    # here be the specs!
    describe '[Couchbase orm adapter]' do
      before do
        # User.delete_all
        # Note.delete_all
      end

      it_should_behave_like "example app with orm_adapter" do
        let(:user_class) { User }
        let(:note_class) { Note }
      end

      # describe "#conditions_to_fields" do
      #   describe "with non-standard association keys" do
      #     class PerverseNote < Note
      #       belongs_to :user, :foreign_key => 'owner_id'
      #       belongs_to :pwner, :polymorphic => true, :foreign_key => 'owner_id', :foreign_type => 'owner_type'
      #     end

      #     let(:user) { User.create! }
      #     let(:adapter) { PerverseNote.to_adapter }

      #     it "should convert polymorphic object in conditions to the appropriate fields" do
      #       adapter.send(:conditions_to_fields, :pwner => user).should == {'owner_id' => user.id, 'owner_type' => user.class.name}
      #     end

      #     it "should convert belongs_to object in conditions to the appropriate fields" do
      #       adapter.send(:conditions_to_fields, :user => user).should == {'owner_id' => user.id}
      #     end
      #   end
      # end
    end
  end
end
