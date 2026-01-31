def x_in_screen(game_scroll_x,x):
    """
    checks if X is between min & max scroll, with the added difficulty that
    scroll value "wraps" to 0x1FF
    """
    max_scroll_x = (game_scroll_x + 0x110)
    if x < game_scroll_x and game_scroll_x > max_scroll_x % 0x200:
        # handle wrap case
        x += 0x200
    return game_scroll_x < x < max_scroll_x


for m,x,expected in [(0x20,0x40,True),(0x1F0,0x20,True),(0x1F0,0x1E0,False),(0x100,0x1E0,True),(0x1E0,0xA0,True),(0x1E0,0x120,False)]:
    result = x_in_screen(m,x)
    print(f"min_scroll=0x{m:03x} x=0x{x:03x} {result}, okay={result==expected}")