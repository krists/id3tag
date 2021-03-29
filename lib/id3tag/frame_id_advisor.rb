module ID3Tag
  class FrameIdAdvisor
    ANY_MAJOR_VERSION = 'x'

    COMMON_FRAME_IDS_BY_VERSION = {
      'v1.x' => {
        :artist => :artist,
        :title => :title,
        :album => :album,
        :year => :year,
        :comments => :comments,
        :genre => :genre,
        :track_nr => :track_nr
      },
      'v2.2' => {
        :artist => :TP1,
        :title => :TT2,
        :album => :TAL,
        :year => :TYE,
        :comments => :COM,
        :genre => :TCO,
        :track_nr => :TRK,
        :disc_nr => :TPA,
        :unsychronized_transcription => :ULT,
        :image => :PIC
      },
      'v2.3' => {
        :artist => :TPE1,
        :title => :TIT2,
        :album => :TALB,
        :year => :TYER,
        :comments => :COMM,
        :genre => :TCON,
        :track_nr => :TRCK,
        :disc_nr => :TPOS,
        :unsychronized_transcription => :USLT,
        :image => :APIC
      },
      'v2.4' => {
        :artist => :TPE1,
        :title => :TIT2,
        :album => :TALB,
        :year => :TDRC,
        :comments => :COMM,
        :genre => :TCON,
        :track_nr => :TRCK,
        :disc_nr => :TPOS,
        :unsychronized_transcription => :USLT,
        :image => :APIC
      }
    }

    def initialize(version, major_version)
      @version, @major_version = version, major_version
    end

    def advise(frame_name)
      version_ids && version_ids[frame_name]
    end

    def version_of_interest
      "v#{@version}.#{@major_version}"
    end

    private

    def version_ids
      COMMON_FRAME_IDS_BY_VERSION.fetch(version_of_interest)
    end
  end
end
