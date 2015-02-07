module Midicat
  class Cli
    attr_reader :device

    def initialize()
      @ni = Nibbler.new

      if UniMIDI::Input.all.length > 0
        @device = UniMIDI::Input.gets
      else
        puts "no MIDI device found!"
        exit! 1
      end

      unless @device.nil?
        begin
          mainloop @device.open
        ensure
          @device.close
        end
      end
    end

    def mainloop(device)
      loop do
        device.gets.each do |data|
          timestamp = sprintf "%12.4f", data[:timestamp]
          ms = @ni.parse(*data[:data])
          if ms.is_a? Array
            ms.each do |mss|
              puts "#{timestamp} #{device.name} #{Midicat::Formatter::format mss}"
            end
          else
            puts "#{timestamp} #{device.name} #{Midicat::Formatter::format ms}"
          end
        end
      end
    end
  end
end
