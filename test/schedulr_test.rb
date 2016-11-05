require 'minitest/autorun'
require 'schedulr'
require 'securerandom'

describe Schedulr do
  let(:random_day_offset) do
    1 + rand(200)
  end

  let(:start_time) do
    now = Time.now
    Time.new(now.year, now.month, now.day, 6, 00, 00) - (60*60*24*random_day_offset)
  end

  let(:end_time) do
    now = Time.now
    Time.new(now.year, now.month, now.day, 10, 30, 00) - (60*60*24*random_day_offset)
  end

  let(:schedulr_instance) { "test" }

  before do
    Schedulr.load(schedulr_instance)
    # Randomly generate the activity name for each test.
    # This will ensure tests are not sharing activity names by mistake
    @activity_name = SecureRandom.uuid

    @function_call_mock = MiniTest::Mock.new
    @function_call_mock.expect(:call, nil, [Object, Object])
  end

  after do
    File.delete("#{schedulr_instance}.timesheet")
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

  describe "#day" do
    it "returns an empty Day when no activites registered" do
      assert_equal 0, Schedulr.day().events.length
    end

    it "returns a Day with 1 event if there was one event today" do
      activity = Schedulr.add(@activity_name)
      Schedulr.set(activity.id)
      Schedulr.start()
      assert_equal 1, Schedulr.day().events.length
    end

    it "returns the proper day schedule when using the offset" do
      Time.stub :now, start_time do
        puts "event start day #{start_time}"
        Schedulr.load(schedulr_instance)
        activity = Schedulr.add(@activity_name)
        Schedulr.set(activity.id)
        Schedulr.start()
      end

      Time.stub :now, end_time do
        Schedulr.stop()
      end

      refute Schedulr.day().events.any?
      assert Schedulr.day(random_day_offset).events.any?
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

  describe "#start" do
    it "is persisted" do
      Schedulr.stub :save, @function_call_mock do
        Schedulr.start()
      end
      @function_call_mock.verify
    end
  end

  describe "#stop" do
    it "is persisted" do
      Schedulr.stub :save, @function_call_mock do
        Schedulr.start()
      end
      @function_call_mock.verify
    end
  end

  describe "#rename" do
    let(:test_activity_name) { "test_name" }

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

  describe "#list" do
    it "lists returns a list of Activities" do
      Schedulr.add(@activity_name)
      assert Schedulr.list().kind_of?(Array)
      assert Schedulr.list()[0].kind_of?(Activity)
    end

    it "returns the right activities" do
      activity = Schedulr.add(@activity_name)
      assert_equal activity.id, Schedulr.list()[0].id
    end

    it "returns an empty list if there are no activities" do
      assert_equal 0, Schedulr.list().length
      assert Schedulr.list().kind_of?(Array)
    end
  end


  describe "#load" do

    let(:path_to_test_file) { "load_test" }
    let(:path_to_test_file_2) { "load_test_2" }

    before do
      # Load Schedulr in an empty state
      File.delete("#{path_to_test_file}.timesheet") if File.exist?("#{path_to_test_file}.timesheet")
      File.delete("#{path_to_test_file_2}.timesheet") if File.exist?("#{path_to_test_file_2}.timesheet")
      Schedulr.load(path_to_test_file)
    end

    after do
      # Delete test files
      File.delete("#{path_to_test_file}.timesheet") if File.exist?("#{path_to_test_file}.timesheet")
      File.delete("#{path_to_test_file_2}.timesheet") if File.exist?("#{path_to_test_file_2}.timesheet")
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

      FileUtils.cp "#{path_to_test_file}.timesheet", "#{path_to_test_file_2}.timesheet"

      Schedulr.remove(activity.id)
      assert_equal 0, Schedulr.list().length

      # Call load from copied file and make sure it restores properly.
      Schedulr.load(path_to_test_file_2)
      assert_equal 1, Schedulr.list().length
      assert_equal activity.name, Schedulr.list()[0].name
    end
  end
end