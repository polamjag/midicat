require 'optparse'
require 'midicat/version'

module Midicat
  class Cli
    attr_reader :device, :options

    def initialize args
      @options = {
        raw_mode: false
      }

      opt = OptionParser.new
      opt.on('--raw', 'Enable raw mode (shows raw midi event)') { @options[:raw_mode] = true }
      opt.version = Midicat::VERSION
      opt.parse! args

      @ni = Nibbler.new

      if UniMIDI::Input.all.length > 1
        @device = UniMIDI::Input.gets
      elsif UniMIDI::Input.all.length == 1
        @device = UniMIDI::Input.all[0]
        puts @device.pretty_name
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
          show_message device.name, data
        end
      end
    end

    def show_message device_name, data
      timestamp = sprintf "%12.4f", data[:timestamp]

      if @options[:raw_mode]
        puts "#{timestamp} #{device_name} #{data[:data]}"
      else
        messages = @ni.parse(*data[:data])

        if messages.is_a? Array
          messages.each do |message|
            pretty_print timestamp, device_name, message
          end
        else
          pretty_print timestamp, device_name, messages
        end
      end
    end

    def pretty_print timestamp, device_name, message
      puts "#{timestamp} #{device_name} #{Midicat::Formatter::format message}"
    end
  end
end
