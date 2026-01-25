# one shot script used to replicate
with open("cavern","rb") as f:
    contents = bytearray(f.read())
    for x in range(0,0x20):
        for y in range(0,0x10):
            start_address = x*32 + y
            dest_address = x*32 + y+0x10
            contents[dest_address] = contents[start_address]
            contents[dest_address+0x400] = contents[start_address+0x400]

with open("new_cavern","wb") as f:
    f.write(contents)
