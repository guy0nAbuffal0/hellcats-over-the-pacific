import re
import json

def scrape_binary_strings(filepath, min_length=4):
    with open(filepath, 'rb') as f:
        data = f.read()

    # Regex pattern to find printable ASCII text chunks
    # Looks for sequential readable characters ending in null or boundary bytes
    pattern = rb'[\x20-\x7E]{' + bytes(str(min_length), 'ascii') + rb',}'
    
    strings_dict = {}
    string_index = 1

    for match in re.finditer(pattern, data):
        # Decode the byte cluster into readable text
        try:
            text = match.group().decode('mac_roman').strip()
            # Filter out pure numbers or obvious code fragments to keep it clean
            if text and not text.isdigit() and len(text) > 3:
                strings_dict[f"STR_{string_index}"] = text
                string_index += 1
        except Exception:
            continue

    # Write out to your JSON file
    with open('hellcats_strings.json', 'w', encoding='utf-8') as out:
        json.dump(strings_dict, out, indent=4, ensure_ascii=False)

    print(f"Success! Scraped {len(strings_dict)} readable text strings directly out of the 68k engine binary.")

if __name__ == '__main__':
    scrape_binary_strings('Hellcats.rsrc')
