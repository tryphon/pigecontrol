require 'spec_helper'

describe Sox, "command" do

  before(:each) do
    @command = mock(Sox::Command, :run => true)
    Sox::Command.stub!(:new).and_return(@command)
  end

  it "should create a new Sox::Command" do
    Sox::Command.should_receive(:new).and_return(@command)
    Sox.command {}
  end

  it "should yield the created Sox::Command" do
    Sox.command { |sox| sox.should == @command }
  end
  
  it "should run the Sox::Command" do
    @command.should_receive(:run).and_return(true)
    Sox.command {}.should be_true
  end
  
end

describe Sox::Command do

  it {
    Sox::Command.new do |sox|
      sox.input "input1.wav"
      sox.input "input2", :type => "ogg"
      
      sox.output "output", :type => "ogg", :compression => 8
    end.command_line.should == "sox input1.wav --type ogg input2 --compression 8 --type ogg output"
  }

  before(:each) do
    @command = Sox::Command.new

    @filename = "filename"
    @options = { :option1 => "value1" }
  end

  describe "input" do
    
    it "should create a File with specified arguments and adds it in command inputs" do
      @command.input @filename, @options
      @command.inputs.should == [ Sox::Command::File.new(@filename, @options) ]
    end

  end

  describe "output" do
    
    it "should create a File with specified arguments and adds it in command output" do
      @command.output @filename, @options
      @command.output.should == Sox::Command::File.new(@filename, @options)
    end

  end

  describe "effect" do

    before(:each) do
      @arguments = Array.new(3) { |n| "argument#{n}" }
    end
    
    it "should create an Effect with specified argument and adds it in command effects" do
      @command.effect :effect_name, @arguments
      @command.effects.should == [ Sox::Command::Effect.new(:effect_name, @arguments) ]
    end

  end

  describe "command_arguments" do

    def mock_file(command_arguments)
      mock(Sox::Command::File, :command_arguments => command_arguments, :options => {}, :filename => "dummy")
    end

    def mock_effect(command_arguments)
      mock(Sox::Command::Effect, :command_arguments => command_arguments)
    end

    before(:each) do
      @command.inputs = Array.new(3) { |n| mock_file "input#{n}" }
      @command.output = mock_file("output")
      @command.effects = Array.new(3) { |n| mock_effect "effect#{n}" }
    end
    
    it "should concat inputs, output and effects command arguments" do
      @command.command_arguments.should == "input0 input1 input2 output effect0 : effect1 : effect2"
    end

    context "when playlist is useful " do
      before(:each) do
        @command.playlist.stub :useful? => true
      end

      it "should concat playlist path, output and effects command arguments" do
        @command.command_arguments.should == "#{@command.playlist.path} output effect0 : effect1 : effect2" 
      end

      it "should create playlist if needed" do
        @command.playlist.should_receive(:create)
        @command.command_arguments
      end
    end

  end

  describe "command_line" do
    
    it "should concat sox binary path and command_arguments" do
      @command.stub!(:command_arguments).and_return("command_arguments")
      @command.command_line.should == "sox command_arguments"
    end
    
  end

  describe "run" do

    before(:each) do
      @command.stub!(:command_line).and_return("command_line")
    end
    
    it "should invoke system with command_line" do
      @command.should_receive(:system).with(@command.command_line)
      @command.run
    end

    it "should delete playlist" do
      @command.playlist.should_receive(:delete)
      @command.run
    end

    it "should return true if command line is successful" do
      @command.stub :system => true
      @command.run.should be_true
    end

    it "should return false if command line fails" do
      @command.stub :system => false
      @command.run.should be_false
    end

  end

  describe "run!" do

    it "should not raise error when run returns true" do
      @command.stub :run => true
      lambda { @command.run! }.should_not raise_error
    end
    
    it "should raise an error when run returns false" do
      @command.stub :run => false
      lambda { @command.run! }.should raise_error
    end

  end

  describe "playlist" do
    
    it "should have .m3u extension (sox requirement)" do
      @command.playlist.path.should match(/\.m3u$/)
    end

    after(:each) do
      @command.playlist.delete
    end

  end

  describe Sox::Command::File do

    before(:each) do
      @file = Sox::Command::File.new("test")
    end

    it "should create command_arguments filename only without options" do 
      @file.filename = "filename"
      @file.options = {}

      @file.command_arguments.should == "filename"
    end
    
    it "should create command_arguments with options and filename (--option1 value1 --option2 value2 ... filename)" do
      @file.filename = "filename"
      @file.options = {:option1 => "value1", :option2 => "value2"}

      @file.command_arguments.should == "--option1 value1 --option2 value2 filename"
    end

  end

  describe Sox::Command::Effect do

    before(:each) do
      @effect = Sox::Command::Effect.new("test")
    end

    it "should create command_arguments with name and arguments" do 
      @effect.name = "name"
      @effect.arguments = ["argument1", "argument2"]

      @effect.command_arguments.should == "name argument1 argument2"
    end
    
  end

  describe Sox::Command::Playlist do

    def mock_file(name, options = {})
      mock Sox::Command::File, :filename => name, :options => options
    end

    subject { Sox::Command::Playlist.new [mock_file("input")] }

    describe "create" do
      
      it "should create a playlist file with input files" do
        subject.stub :inputs => [mock_file("input1"), mock_file("input2")]
        IO.read(subject.create).should == "input1\ninput2\n"
      end

      after(:each) do
        subject.delete
      end

    end

    describe "delete" do
      
      it "should close playlist if exists" do
        subject.instance_variable_set("@file", file = mock)
        file.should_receive(:close).with(true)
        subject.delete
      end

      it "should do nothing when file doesn't exist'" do
        lambda { subject.delete }.should_not raise_error
      end

    end

    describe "useful? " do

      it "should be useful if concatenated filenames are longer than 500 characters" do
        subject.stub :inputs => Array.new(51) { mock_file("a" * 10) }
        subject.should be_useful
      end

      it "should not be useful if one of the input file has an option" do
        subject.stub :inputs => [ mock_file("dummy", :option => true) ]
        subject.should_not be_useful
      end

      it "should not be useful if concatenated filenames use less than 500 characters" do
        subject.stub :inputs => Array.new(50) { mock_file("a" * 10) }
        subject.should_not be_useful
      end

    end

  end

end
