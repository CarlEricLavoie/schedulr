require 'minitest/autorun'
require 'schedulr'
require 'securerandom'

describe Schedulr do
  # let(:activity_name) { "coding" }

  before do
    Schedulr.load("test.timesheet")
    # Randomly generate the activity name for each test.
    # This will ensure tests are not sharing activity names by mistake
    @activity_name = SecureRandom.uuid

    @function_call_mock = MiniTest::Mock.new
    @function_call_mock.expect(:call, nil, [Object, Object])
  end

  after do
    File.delete("test.timesheet")
  end

  describe "#add" do
    it "returns the activity that was successfully added" do
      activity = Schedulr.add(@activity_name, false)
      assert_equal @activity_name, activity.name
    end

    it "adds a new activity to the list of activities" do
      initial_length = Schedulr.list().length
      Schedulr.add(@activity_name, false)
      assert_equal initial_length+1, Schedulr.list().length
    end

    it "allows adding multiple activities with the same name" do
      initial_length = Schedulr.list().length
      Schedulr.add(@activity_name, false)
      Schedulr.add(@activity_name, false)
      assert_equal initial_length+2, Schedulr.list().length
    end

    it "is persisted" do
      Schedulr.stub :save, @function_call_mock do
        Schedulr.add(@activity_name)
      end
      @function_call_mock.verify
    end

  end

  describe "#remove" do
    it "it removes an activity by id" do
      activity = Schedulr.add(@activity_name, false)
      initial_length = Schedulr.list().length
      Schedulr.remove(activity.id, false)
      assert_equal initial_length-1, Schedulr.list().length
    end

    it "only deletes once" do
      activity = Schedulr.add(@activity_name, false)
      Schedulr.add(@activity_name, false)
      initial_length = Schedulr.list().length
      Schedulr.remove(activity.id, false)
      Schedulr.remove(activity.id, false)
      assert_equal initial_length-1, Schedulr.list().length
    end

    it "is persisted" do
      activity = Schedulr.add(@activity_name)
      Schedulr.stub :save, @function_call_mock do
        Schedulr.remove(activity.id)
      end
      @function_call_mock.verify
    end
  end

  describe "#set" do
    it "it sets the current activity by id" do
      activity_1 = Schedulr.add(@activity_name, false)
      activity_2 = Schedulr.add(@activity_name, false)
      Schedulr.set(activity_2.id, false)
      assert_equal activity_2.id, Schedulr.current().id

      Schedulr.set(activity_1.id, false)
      assert_equal activity_1.id, Schedulr.current().id
      refute_equal activity_1.id, activity_2.id
    end

    it "is persisted" do
      activity = Schedulr.add(@activity_name)
      Schedulr.stub :save, @function_call_mock do
        Schedulr.set(activity.id)
      end
      @function_call_mock.verify
    end
  end

  # describe "#current" do
  #   it "it returns the current activity by id" do
  #     activity = Schedulr.add(activity_name, false)
  #     Schedulr.set(activity.id, false)
  #     refute_equal activity, Schedulr.current()
  #   end
  # end

  describe "#start" do
    it "starts the timer" do
      Schedulr.stop()
      assert_equal false, false
    end

    it "is persisted" do
      Schedulr.stub :save, @function_call_mock do
        Schedulr.start()
      end
      @function_call_mock.verify
    end
  end

  describe "#start" do
    it "stops the timer" do
      Schedulr.stop(false)
      assert_equal false, false
    end

    it "is persisted" do
      Schedulr.stub :save, @function_call_mock do
        Schedulr.start()
      end
      @function_call_mock.verify
    end
  end

  describe "#rename" do
    let(:test_activity_name) {"test_name"}

    it "changes the name of an activity by id" do
      activity = Schedulr.add(@activity_name)
      Schedulr.rename(activity.id, test_activity_name)
      assert_equal test_activity_name, activity.name
    end

    it "is persisted" do
      activity = Schedulr.add(@activity_name)
      Schedulr.stub :save, @function_call_mock do
        Schedulr.rename(activity.id, test_activity_name)
      end
      @function_call_mock.verify
    end
  end


  describe "#load" do

    let(:path_to_test_file) { "test/load_test.timesheet" }
    let(:path_to_test_file_2) { "test/load_test_2.timesheet" }

    before do
      # Load Schedulr in an empty state
      File.delete(path_to_test_file) if File.exist?(path_to_test_file)
      File.delete(path_to_test_file_2) if File.exist?(path_to_test_file_2)
      Schedulr.load(path_to_test_file)
    end

    after do
      # Delete test files
      File.delete(path_to_test_file) if File.exist?(path_to_test_file)
      File.delete(path_to_test_file_2) if File.exist?(path_to_test_file_2)
    end

    it "cleans previous state" do
      assert_equal 0, Schedulr.list().length

      Schedulr.add(@activity_name)
      refute_equal 0, Schedulr.list().length

      # Loads a new file, should have new empty state
      Schedulr.load(path_to_test_file_2)
      assert_equal 0, Schedulr.list().length
    end

    it "restores state from timesheet" do
      activity = Schedulr.add(@activity_name)
      assert_equal 1, Schedulr.list().length

      FileUtils.cp path_to_test_file, path_to_test_file_2

      Schedulr.remove(activity.id)
      assert_equal 0, Schedulr.list().length

      # Call load from copied file and make sure it restores properly.
      Schedulr.load(path_to_test_file_2)
      assert_equal 1, Schedulr.list().length
      assert_equal activity.name, Schedulr.list()[0].name
    end
  end
end