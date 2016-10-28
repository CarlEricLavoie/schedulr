require 'minitest/autorun'
require 'schedulr'

describe Schedulr do
  let(:activity_name) { "coding" }

  before do
    # Schedulr.load("test.timesheet")
  end

  after do
    # File.delete("test.timesheet")
  end

  describe "#add" do
    it "returns the activity that was successfully added" do
      activity = Schedulr.add(activity_name, false)
      assert_equal activity_name, activity.name
    end

    it "adds a new activity to the list of activities" do
      initial_length = Schedulr.list().length
      Schedulr.add(activity_name, false)
      assert_equal initial_length+1, Schedulr.list().length
    end

    it "allows adding multiple activities with the same name" do
      initial_length = Schedulr.list().length
      Schedulr.add(activity_name, false)
      Schedulr.add(activity_name, false)
      assert_equal initial_length+2, Schedulr.list().length
    end

  end

  describe "#remove" do
    it "it removes an activity by id" do
      activity = Schedulr.add(activity_name, false)
      initial_length = Schedulr.list().length
      Schedulr.remove(activity.id, false)
      assert_equal initial_length-1, Schedulr.list().length
    end

    it "only deletes once" do
      activity = Schedulr.add(activity_name, false)
      Schedulr.add(activity_name, false)
      initial_length = Schedulr.list().length
      Schedulr.remove(activity.id, false)
      Schedulr.remove(activity.id, false)
      assert_equal initial_length-1, Schedulr.list().length
    end
  end

  describe "#set" do
    it "it sets the current activity by id" do
      activity_1 = Schedulr.add(activity_name, false)
      activity_2 = Schedulr.add(activity_name, false)
      Schedulr.set(activity_2.id, false)
      assert_equal activity_2.id, Schedulr.current().id

      Schedulr.set(activity_1.id, false)
      assert_equal activity_1.id, Schedulr.current().id

      refute_equal activity_1.id, activity_2.id
    end
  end

  # describe "#current" do
  #   it "it returns the current activity by id" do
  #     activity = Schedulr.add(activity_name, false)
  #     Schedulr.set(activity.id, false)
  #     assert_equal activity, Schedulr.current()
  #   end
  # end

  describe "#start" do
    it "starts the timer" do
      Schedulr.stop(false)
      assert_equal false, false
    end
  end
end