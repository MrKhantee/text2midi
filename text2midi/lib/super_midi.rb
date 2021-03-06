class SuperMidi
  
  def self.run_test
    "Hello world".to_midi
  end
  
  FILE_DIRECTORY = "public/midifiles"
end

class String
  
  def to_midi(tempo=40,instr=0,file = nil, note_length='quarter')
    midi_max = 108.0
    midi_min = 21.0
    file = "#{RAILS_ROOT}/#{SuperMidi::FILE_DIRECTORY}/#{Time.now.to_f.to_s}.mid" unless file
    
    #low, high = min, max
    low = 21.0
    high = 108.0
    
    song = MIDI::Sequence.new
    # Create a new track to hold the melody, user controlled slider for tempo control 
    song.tracks << (melody = MIDI::Track.new(song))
    melody.events << MIDI::Tempo.new(MIDI::Tempo.bpm_to_mpq(tempo))
    melody.events << MIDI::ProgramChange.new(0,instr)
    self.each_byte do |letter|
    number = letter.to_i
      
    temp_1 = number-midi_min
    temp_2 = midi_max - low
    
    midi_note = (midi_min + ((temp_1) * (temp_2)/high)).to_i
      
    melody.events << MIDI::NoteOnEvent.new(0, midi_note, 127, 0)
    melody.events << MIDI::NoteOffEvent.new(0, midi_note, 127,
    song.note_to_delta(note_length))
    end
    open(file, 'w') { |f| song.write(f) }
    return file
  end
  
end