describe ContactsMailer do
  it "should deliver the welecome email" do
    # expect
    ContactsMailer.should_receive(:welcome).with("email@example.com", "Jimmy Bean")
    # when
    post :contacts, "email" => "email@example.com", "Name" => "Jimmy Bean"
  end
end

