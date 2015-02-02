module Midicat
  module Formatter
    def self.format(message)
      if message.is_a? MIDIMessage::ControlChange
        "Ch.#{message.channel}.#{message.index} -> #{message.value}"
      elsif message.is_a? MIDIMessage::NoteOn
        "Ch.#{message.channel}.#{message.name} ON @ #{message.velocity}"
      elsif message.is_a? MIDIMessage::NoteOff
        "Ch.#{message.channel}.#{message.name} OFF @ #{message.velocity}"
      elsif message.is_a? MIDIMessage::SystemExclusive::Message
        "SysEx. #{message.data.to_s}"
      else
        message
      end
    end
  end
end
