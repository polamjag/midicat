module Midicat
  class Cli
    attr_reader :devices

    def initialize(devices)
      @threads = []
      @devices = []
      @ni = Nibbler.new

      devices.each_with_index do |d, i|
        puts d.pretty_name
        @devices[i] = d.open
        @threads << Thread.new do
          mainloop @devices[i]
        end
      end

      @threads.each { |t| t.join } unless @threads.nil?
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
