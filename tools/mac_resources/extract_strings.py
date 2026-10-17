import struct
import json
import os

def parse_mac_rsrc(filepath):
    if not os.path.exists(filepath):
        print(f"Error: File '{filepath}' not found.")
        return

    with open(filepath, 'rb') as f:
        data = f.read()

    # Read Macintosh Resource Fork Header
    # 0x0: Data offset (4 bytes), 0x4: Map offset (4 bytes)
    data_offset, map_offset, data_len, map_len = struct.unpack('>IIII', data[0:16])
    
    # Move directly to the Resource Map
    # Map header skips 16 bytes, then type list offset (2 bytes), name list offset (2 bytes)
    type_list_offset, name_list_offset = struct.unpack('>HH', data[map_offset+24:map_offset+28])
    
    # Calculate the actual start of the type list
    type_start = map_offset + type_list_offset
    num_types = struct.unpack('>H', data[type_start:type_start+2])[0] + 1
    
    strings_dict = {}

    # Scan the types looking for 'STR ' or 'STR#'
    for i in range(num_types):
        entry_offset = type_start + 2 + (i * 8)
        rsrc_type = data[entry_offset:entry_offset+4].decode('ascii', errors='ignore')
        num_res = struct.unpack('>H', data[entry_offset+4:entry_offset+6])[0] + 1
        rsrc_list_offset = struct.unpack('>H', data[entry_offset+6:entry_offset+8])[0]
        
        if rsrc_type in ['STR ', 'STR#']:
            ref_list_start = type_start + rsrc_list_offset
            
            for j in range(num_res):
                ref_offset = ref_list_start + (j * 12)
                rsrc_id = struct.unpack('>h', data[ref_offset:ref_offset+2])[0]
                data_offset_flags = struct.unpack('>I', data[ref_offset+4:ref_offset+8])[0]
                rsrc_data_offset = data_offset + (data_offset_flags & 0x00FFFFFF)
                
                # Length of this specific resource payload
                rsrc_len = struct.unpack('>I', data[rsrc_data_offset:rsrc_data_offset+4])[0]
                payload = data[rsrc_data_offset+4:rsrc_data_offset+4+rsrc_len]
                
                if rsrc_type == 'STR ':
                    # Pascal string format: byte 0 is length, followed by ASCII bytes
                    str_len = payload[0]
                    text = payload[1:1+str_len].decode('mac_roman', errors='ignore')
                    strings_dict[f"STR_{rsrc_id}"] = text
                    
                elif rsrc_type == 'STR#':
                    # String list format: 2 bytes count, then packed Pascal strings
                    num_strings = struct.unpack('>H', payload[0:2])[0]
                    idx = 2
                    for s in range(num_strings):
                        if idx >= len(payload): break
                        str_len = payload[idx]
                        text = payload[idx+1:idx+1+str_len].decode('mac_roman', errors='ignore')
                        strings_dict[f"STR_HASH_{rsrc_id}_index_{s}"] = text
                        idx += 1 + str_len

    # Save outputs to clean JSON
    with open('hellcats_strings.json', 'w', encoding='utf-8') as out:
        json.dump(strings_dict, out, indent=4, ensure_ascii=False)
        
    print(f"Success! Extracted {len(strings_dict)} game strings to 'hellcats_strings.json'")

if __name__ == '__main__':
    # Make sure this matches your unar file output name exactly
    parse_mac_rsrc('Hellcats.rsrc')
