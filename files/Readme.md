# Samba Configuration File Changes - smb.conf
Note: The smb.conf file line<br><br>
&nbsp;&nbsp;&nbsp;&nbsp;`client max protocol = NT1`<br><br>
has been changed to<br><br>
&nbsp;&nbsp;&nbsp;&nbsp;`client min protocol = NT1`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`server min protocol = NT1`<br><br>
This change has occured since the introduction of Linux Mint 20 Ulyana.<br>
This might not be the same in other Linux distributions.
