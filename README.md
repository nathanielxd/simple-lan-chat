# Simple LAN Chat
<a href='https://play.google.com/store/apps/details?id=com.nathanielxd.SimpleLANChat&pcampaignid=MKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/images/generic/en_badge_web_generic.png' width=150/></a>

An application that allow users to chat on the same Local Area Network through simple UDP packets broadcasts.

` `  
` `  

The app requires a WiFi connection and will allow two or more people that are connected to the same network to chat in a most basic manner.

It opens a UDP protocol, listens to all data on the port (1050 and 1051 by default) and sends a UDP broadcasts to communicate. From 1.2 it also supports image sharing. The app has dark mode and a minimalist design. It can be used to have a little fun or quickly share links/images.

` `  
` `  

# Documentation
The app opens sockets on ports **1050** and **1051** and listens to them. The communication happens on port 1050 and connectivity ensues on port 1051.
Each type of message packet starts with a special identifier so that the app knows what to display.

Type | Identifier Byte
-----|----------------
Text | 48
File | 49 or higher

` `  
` `  

## Text messages
These messages are broadcasted to the whole LAN therefore anybody can listen to them.
All text message packets follow the next format:

0  | [...]
---|------
48 | DATA

Where DATA is the message itself as a byte array.

` `  
` `  

## File messages
These messages are sent to only sockets that are recognized as Simple LAN Chat apps. 
File message sockets are different as most of the files are bigger in size than the maximum packet size. 
To solve this issue, messages larger than **50000 bytes** are chopped in parts and sent one by one.

All file messages packets follow the net format:

0        | 1         | 2            | [...]    | [...]
---------|-----------|--------------|----------|------
49+index | 49+length | name length  | NAME     | DATA

Where,

term        | meaning
------------|----------------------------------------------------------
index       | the current index of the chop (0 if there's only one part)
length      | the length of the message (0 if there's only one part)
name length | the length of the name of the file
NAME        | the name of the file as a byte array
DATA        | the file itself as a byte array

` `  
` `  

## Heartbeats
You can see anyone's IP and nickname connected in the app.
Discovery of other connected devices is done on port 1051 through heartbeats. Each client broadcasts a specific message to keep the connection alive.

All heartbeats have the following format:
0 | 1 | [...]
--|---|------
h | b | NICK

Where **h** and **b** are utf8 decoded characters and **NICK** is the nickname of the device, if any.
