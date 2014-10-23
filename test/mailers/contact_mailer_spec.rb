require 'rails_helper'

class ContactMailerTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end
  describe "POST contacts/create" do
    it "should deliver the welecome email" do
      # expect
      ContactsMailer.should_receive(:welcome).with("email@example.com", "Jimmy Bean")
      # when
      post :signup, "email" => "email@example.com", "Name" => "Jimmy Bean"
    end
  end
end
