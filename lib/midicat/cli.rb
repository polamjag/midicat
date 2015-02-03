module Midicat
  class Cli
    attr_reader :devices

    def initialize(devices)
      @devices = []
      @ni = Nibbler.new

      devices.each_with_index do |d, i|
        puts d.pretty_name
        @devices[i] = d.open
      end

      mainloop unless @devices.empty?
    end

    def mainloop
      loop do
        @devices.each do |device|
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
end
