import os
import wave

def harvest_raw_audio_streams(filepath):
    if not os.path.exists(filepath):
        print(f"Error: File '{filepath}' not found.")
        return

    with open(filepath, 'rb') as f:
        data = f.read()

    output_dir = "extracted_sounds"
    os.makedirs(output_dir, exist_ok=True)

    # Focus strictly inside our known asset memory block boundaries
    start_offset = 131072
    end_offset = 333319
    asset_segment = data[start_offset:end_offset]

    sound_count = 1
    ptr = 0
    
    # Sweep across the memory block looking for valid 8-bit PCM audio waves
    # 90s sound assets are typically blocks of data with varying values 
    # bounded by null segments (0x00) or high repetitive framing flags
    while ptr < len(asset_segment):
        # Look for a non-silent byte chunk to mark a potential sound wave start
        if asset_segment[ptr] != 0x00 and asset_segment[ptr] != 0xFF:
            start_run = ptr
            
            # Scan forward to calculate the length of this continuous data run
            while ptr < len(asset_segment) and asset_segment[ptr] != 0x00:
                ptr += 1
            
            run_length = ptr - start_run
            
            # Real game sound effects (like explosions, gunshots, engine hums) 
            # require a substantial wave segment—usually between 1,000 and 40,000 bytes
            if 1000 <= run_length <= 40000:
                raw_pcm_bytes = asset_segment[start_run:ptr]
                
                wav_filename = os.path.join(output_dir, f"hellcats_audio_{sound_count}.wav")
                
                try:
                    with wave.open(wav_filename, 'wb') as wav_file:
                        wav_file.setnchannels(1)      # Mono
                        wav_file.setsampwidth(1)      # 8-bit Unsigned PCM
                        wav_file.setframerate(22050)  # Standard 90s playback default
                        wav_file.writeframes(raw_pcm_bytes)
                    sound_count += 1
                except:
                    pass
        ptr += 1

    print(f"\nAudio Harvesting Complete!")
    print(f"Successfully carved out {sound_count - 1} uncompressed audio wave assets into '{output_dir}'.")

if __name__ == '__main__':
    harvest_raw_audio_streams('Hellcats.rsrc')
