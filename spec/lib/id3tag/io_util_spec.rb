require "spec_helper"

describe ID3Tag::IOUtil do
  describe "find_null_byte" do
    subject { ID3Tag::IOUtil.find_null_byte(input) }
    context "when null byte is in after 4th byte" do
      let(:input) { StringIO.new("aabb\x00cc") }
      its(:terminator_reached) { should be_true  }
      its(:byte_count_before_terminator) { should eq(4)  }
      its(:byte_count_of_content_and_terminator) { should eq(5)  }
      its(:end_pos) { should eq(5)  }
      its(:start_pos) { should eq(0)  }
    end

    context "when null byte is in not present in 5 byte string" do
      let(:input) { StringIO.new("abcde") }
      its(:terminator_reached) { should be_false  }
      its(:byte_count_before_terminator) { should eq(5)  }
      its(:byte_count_of_content_and_terminator) { should eq(5) }
      its(:end_pos) { should eq(5) }
      its(:start_pos) { should eq(0) }
    end

    context "when null byte is 0th" do
      let(:input) { StringIO.new("\x00abcde") }
      its(:terminator_reached) { should be_true  }
      its(:byte_count_before_terminator) { should eq(0)  }
      its(:byte_count_of_content_and_terminator) { should eq(1) }
      its(:end_pos) { should eq(1) }
      its(:start_pos) { should eq(0) }
    end
  end

  describe "find_two_null_bytes" do
    subject { ID3Tag::IOUtil.find_two_null_bytes(input) }
    context "when null bytes are after 4th byte" do
      let(:input) { StringIO.new("aabb\x00\x00cc") }
      its(:terminator_reached) { should be_true  }
      its(:byte_count_before_terminator) { should eq(4)  }
      its(:byte_count_of_content_and_terminator) { should eq(6)  }
      its(:end_pos) { should eq(6)  }
      its(:start_pos) { should eq(0)  }
    end

    context "when null bytes are after 5th byte and has one null byte before them" do
      let(:input) { StringIO.new("aa\x00bb\x00\x00cc") }
      its(:terminator_reached) { should be_true  }
      its(:byte_count_before_terminator) { should eq(5)  }
      its(:byte_count_of_content_and_terminator) { should eq(7)  }
      its(:end_pos) { should eq(7)  }
      its(:start_pos) { should eq(0)  }
    end

    context "when null bytes are not present in 5 byte string" do
      let(:input) { StringIO.new("abcde") }
      its(:terminator_reached) { should be_false  }
      its(:byte_count_before_terminator) { should eq(5)  }
      its(:byte_count_of_content_and_terminator) { should eq(5) }
      its(:end_pos) { should eq(5) }
      its(:start_pos) { should eq(0) }
    end

    context "when null bytes are 0th" do
      let(:input) { StringIO.new("\x00\x00abcde") }
      its(:terminator_reached) { should be_true  }
      its(:byte_count_before_terminator) { should eq(0)  }
      its(:byte_count_of_content_and_terminator) { should eq(2) }
      its(:end_pos) { should eq(2) }
      its(:start_pos) { should eq(0) }
    end
  end

  describe "find_terminator" do
    it "raises error when unsupported encoding byte" do
      expect { ID3Tag::IOUtil.find_terminator(anything, 3) }.to raise_error(ArgumentError)
    end
  end

  describe "maintain_original_position" do
    let(:io) { StringIO.new("abcd") }
    it "accepts block and maintains original io position after block execution" do
      io.read(2)
      ID3Tag::IOUtil.maintain_original_position(io) do
        io.read(1).should eq("c")
      end
      io.read.should eq("cd")
    end
  end
end
