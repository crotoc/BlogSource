---
title: Modify the hotkey of Chinese-English language switching in Windows 10
date: 2018-09-25 11:51:49
tags: [Computer setup]
---

# Modify the hotkey of Chinese-English language switching in Windows 10

The problem is very annoying because the hotkey ctrl+space has conflicted with others in emacs or other program. My thought is changing it to another combination ctrl+F1.

1. Open regedit
2. Navigate to HKEY_USER\.DEFAULT\Input Method\Hot Keys\00000010\
3. Modify the Key Modifiers and Virtual Key.
4. Only disable the hotkey is change the first two digits of the two keys in 00.
	
		Key Modifiers: 00 c0 00 00.
		Virtual Key: 00 00 00 00

5. For Key modifiers, the rules of the number are like:
   
		__00__ c0 00 00 : The underlining two digits indicate one of modifier keys.
				
		CTRL: 02
		ALT: 01
		SHIFT: 04
		Disable: 00
		
		00 __c0__ 00 00 : The underlining two digits indicate the left or right position on the keybord.
		
		Left: 80
		Right: 40
		Left or Right: 8+4=12=c0
	
6. For virtual key, the rules are like:

		__00__ 00 00 00 : The hex of ascii of a virtual key.
	
	Please see the reference: https://docs.microsoft.com/en-us/windows/desktop/inputdev/virtual-key-codes
	
	So if we want F1, the hex code is 70:
		
		__70__ 00 00 00 : The hex of ascii of F1.
		
7. Restart your computer.

For my case, I just need to modify virtual key to 70 00 00 00
